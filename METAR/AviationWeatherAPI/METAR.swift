//
//  METAR.swift
//  METAR
//
//  Created by Charles Duyk on 2/13/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//


import Foundation

//enum SkyCondition: String {
//    case broken = "BKN"
//}

extension Date {
    init?(ISO8601String string:String) {
        guard let date = ISO8601DateFormatter().date(from: string) else {
            return nil
        }
        self = date
    }
    
    func ISO8601String(timeZone:TimeZone = TimeZone(secondsFromGMT: 0)!) -> String {
        return ISO8601DateFormatter.string(from: self, timeZone: timeZone, formatOptions:.withInternetDateTime)
    }
}

struct METAR {
    var altimeter: Double?
    var dewpoint: Double?
    var elevationMeters: Double?
    var flightCategory: String?
    var latitude: Double?
    var longitude: Double?
    var maxTemperature24h: Double?
    var minTemperature24h: Double?
//    var metarType: String?
    var observationTime: Date?
    var rawText: String?
    var seaLevelPressureMb: Double?
    var seaLevelPressureInHG: Double? {
        get {
            guard let seaLevelPressureMb = seaLevelPressureMb else { return nil }
            return 0.02953 * seaLevelPressureMb
        }
    }
//    var skyCondition: [SkyCondition]
    var snowInches: Double?
    var stationID: String?
    var temperature: Double?
    var visibility: Double?
    var windDirection: Int?
    var windSpeed: Int?
    var windGust: Int?
    
    enum Element: String {
        case altimeter = "altim_in_hg"
        case dewpoint = "dewpoint_c"
        case elevationMeters = "elevation_m"
        case envelope = "METAR"
        case error = "error"
        case flightCategory = "flight_category"
        case latitude
        case longitude
        case maxTemperature24h = "maxT24hr_c"
//        case metarType = "metar_type"
        case minTemperature24h = "lowT24hr_c"
        case observationTime = "observation_time"
        case rawText = "raw_text"
//        case qualityControlFlags = "quality_control_flags"
        case seaLevelPressureMb = "sea_level_pressure_mb"
        case skyCondition = "sky_condition"
        case stationID = "station_id"
        case snowInches = "snow_in"
        case temperature = "temp_c"
        case visibility = "visibility_statute_mi"
        case warning = "warning"
        case windDirection = "wind_dir_degrees"
        case windSpeed = "wind_speed_kt"
        case windGust = "wind_gust_kt"
    }
    
    mutating func set(_ element:Element, value: String) {
        let doubleValue = Double(value)
        let intValue = Int(value)
        
        switch element {
        case .altimeter:
            self.altimeter = doubleValue
        case .dewpoint:
            self.dewpoint = doubleValue
        case .elevationMeters:
            self.elevationMeters = doubleValue
        case .envelope:
            break
        case .error:
            print("Shouldn't be handling error here")
        case .flightCategory:
            self.flightCategory = value
        case .latitude:
            self.latitude = doubleValue
        case .longitude:
            self.longitude = doubleValue
        case .maxTemperature24h:
            self.maxTemperature24h = doubleValue
        case .minTemperature24h:
            self.minTemperature24h = doubleValue
        case .observationTime:
            self.observationTime = Date(ISO8601String:value)
        case .rawText:
            self.rawText = value
        case .seaLevelPressureMb:
            self.seaLevelPressureMb = doubleValue
        case .skyCondition:
            print("HANDLE SKYCONDITION")
        case .stationID:
            self.stationID = value
        case .snowInches:
            self.snowInches = doubleValue
        case .temperature:
            self.temperature = doubleValue
        case .visibility:
            self.visibility = doubleValue
        case .warning:
            print("Shouldn't be handling warning here")
        case .windDirection:
            self.windDirection = intValue
        case .windSpeed:
            self.windSpeed = intValue
        case .windGust:
            self.windGust = intValue
        }
    }
    
    struct Request {
        private var stations: Set<String> = []
        var startDate: Date?
        var endDate: Date?
        var hoursBeforeNow: Double?
        var mostRecentForEachStation = false
        
        init() {
            self.init(Set())
        }
        
        init(_ stations: String...) {
            self.init(stations)
        }
        
        init(_ stations: [String]) {
            self.init(Set(stations))
        }
        
        init(_ stations: Set<String>) {
            self.stations = stations
        }
        
        mutating func addStation(_ station: String) {
            self.stations.insert(station)
        }
        
        mutating func addStations(_ stations: [String]) {
            for station in stations {
                self.addStation(station)
            }
        }
        
        mutating func addStations(_ stations: String...) {
            self.addStations(stations)
        }
        
        mutating func removeStation(_ station: String) {
            self.stations.remove(station)
        }
        
        mutating func removeStations(_ stations: [String]) {
            for station in stations {
                self.removeStation(station)
            }
        }
        
        mutating func removeStations(_ stations: String...) {
            self.removeStations(stations)
        }
        
        func queryItems() -> [URLQueryItem] {
            var ret = [URLQueryItem]()
            
            ret.append(URLQueryItem(name:"dataSource", value:"metars"))
            ret.append(URLQueryItem(name:"requestType", value:"retrieve"))
            ret.append(URLQueryItem(name:"format", value:"xml"))
            
            if self.stations.count > 0 {
                let item = URLQueryItem(name:"stationString", value:self.stations.joined(separator: ","))
                ret.append(item)
            }
            
            if let startDate = self.startDate {
                let dateString = startDate.ISO8601String()
                let item = URLQueryItem(name:"startTime", value:dateString)
                ret.append(item)
            }
            
            if let endDate = self.endDate {
                let dateString = endDate.ISO8601String()
                let item = URLQueryItem(name:"endTime", value:dateString)
                ret.append(item)
            }
            
            if let hoursBeforeNow = self.hoursBeforeNow {
                let item = URLQueryItem(name:"hoursBeforeNow", value:String(hoursBeforeNow))
                ret.append(item)
            }
            
            if self.mostRecentForEachStation {
                let item = URLQueryItem(name: "mostRecentForEachStation", value:"true")
                ret.append(item)
            }
            
            return ret
        }
    }
    
    struct Response  {
        var metars: [METAR]
        var errors: [String]
        var warnings: [String]
        
        init(_ data: Data) throws {
            let parser = try Parser(data)
            self.metars = parser.metars
            self.errors = parser.responseErrors
            self.warnings = parser.responseWarnings
        }
        
        private class Parser: NSObject, XMLParserDelegate {
            var metars: [METAR] = []
            var responseErrors: [String] = []
            var responseWarnings: [String] = []
            
            private var currentElement: METAR.Element?
            private var currentMETAR: METAR?
            private var currentText = ""
            private var parseError: Error?
            
            init(_ data: Data) throws {
                super.init()
                let parser = XMLParser(data:data)
                parser.delegate = self
                parser.parse()
                if let err = self.parseError {
                    throw err;
                }
            }
            
            func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
                guard let element = METAR.Element(rawValue: elementName) else {
                    print("Skipping element named \(elementName)")
                    return;
                }
                switch element {
                case .envelope:
                    self.currentMETAR = METAR()
                    self.currentElement = nil
                case .skyCondition:
                    print("TODO: Handle SkyCondition")
                default:
                    self.currentElement = element
                }
                self.currentText = ""
            }
            
            func parser(_ parser: XMLParser, foundCharacters string: String) {
                self.currentText += string
            }
            
            func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
                guard let element = METAR.Element(rawValue: elementName) else {
                    return
                }
                
                switch element {
                case .envelope:
                    if let currentMETAR = self.currentMETAR {
                        self.metars.append(currentMETAR)
                        self.currentMETAR = nil
                    }
                case .error:
                    self.responseErrors.append(self.currentText)
                case .warning:
                    self.responseWarnings.append(self.currentText)
                case .skyCondition:
                    //SkyCondition doesn't have text--it uses XML attributes and is handled in parser(_:didStartElement:...)
                    break
                default:
                    self.currentMETAR?.set(element, value:self.currentText)
                }
            }
            
            func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
                self.parseError = parseError
            }
        }
    }
}
