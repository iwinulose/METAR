//
//  Response.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/5/22.
//

import Foundation

public struct Response  {
    public var metars: [METAR]
    public var errors: [String]
    public var warnings: [String]
    
    init(_ data: Data) throws {
        let parser = try Parser(data)
        self.metars = parser.metars
        self.errors = parser.responseErrors
        self.warnings = parser.responseWarnings
    }
    
    internal class Parser: NSObject, XMLParserDelegate {
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
                //FIXME: Logging cleanup
                print("Skipping element named \(elementName)")
                return;
            }
            switch element {
            case .envelope:
                self.currentMETAR = METAR()
                self.currentElement = nil
            case .skyCondition:
                self.addSkyCondition(attributeDict)
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

        func addSkyCondition(_ attributeDict:[String: String]) {
            let rawAltitude = attributeDict[SkyCondition.XMLAttribute.altitude.rawValue]
            let rawCoverage = attributeDict[SkyCondition.XMLAttribute.skyCover.rawValue]

            let altitude = rawAltitude != nil ? Int(rawAltitude!) : nil
            let coverage = rawCoverage != nil ? SkyCondition.SkyCoverage(rawValue: rawCoverage!) : nil

            if let coverage = coverage {
                self.currentMETAR?.skyCondition.append(SkyCondition(altitude: altitude, coverage: coverage))
            }
            else {
                //FIXME: Logging cleanup
                print("Unknown sky coverage \(String(describing: rawCoverage))")
            }
        }
    }
}

extension METAR {
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
        case weatherString = "wx_string"
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
            //FIXME: Logging cleanup
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
            //FIXME: Logging cleanup
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
            //FIXME: Logging cleanup
            print("Shouldn't be handling warning here")
        case .weatherString:
            self.weatherString =  value
        case .windDirection:
            self.windDirection = intValue
        case .windSpeed:
            self.windSpeed = intValue
        case .windGust:
            self.windGust = intValue
        }
    }
}

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
