//
//  METAR.swift
//  METAR
//
//  Created by Charles Duyk on 2/13/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//


import Foundation

public struct METAR {
    static let ADDSDataSource = "metars"
    
    public var altimeter: Double?
    public var dewpoint: Double?
    public var elevationMeters: Double?
    public var flightCategory: String?
    public var latitude: Double?
    public var longitude: Double?
    public var maxTemperature24h: Double?
    public var minTemperature24h: Double?
//    var metarType: String?
    public var observationTime: Date?
    public var rawText: String?
    public var seaLevelPressureMb: Double?
    public var seaLevelPressureInHG: Double? {
        get {
            guard let seaLevelPressureMb = seaLevelPressureMb else { return nil }
            return 0.02953 * seaLevelPressureMb
        }
    }
    public var skyCondition: [SkyCondition] = []
    public var snowInches: Double?
    public var stationID: String?
    public var temperature: Double?
    public var visibility: Double?
    public var weatherString: String?
    public var windDirection: Int?
    public var windSpeed: Int?
    public var windGust: Int?
    
    public init(altimeter: Double? = nil, dewpoint: Double? = nil, elevationMeters: Double? = nil, flightCategory: String? = nil, latitude: Double? = nil, longitude: Double? = nil, maxTemperature24h: Double? = nil, minTemperature24h: Double? = nil, observationTime: Date? = nil, rawText: String? = nil, seaLevelPressureMb: Double? = nil, skyCondition: [SkyCondition] = [], snowInches: Double? = nil, stationID: String? = nil, temperature: Double? = nil, visibility: Double? = nil, weatherString: String? = nil, windDirection: Int? = nil, windSpeed: Int? = nil, windGust: Int? = nil) {
        self.altimeter = altimeter
        self.dewpoint = dewpoint
        self.elevationMeters = elevationMeters
        self.flightCategory = flightCategory
        self.latitude = latitude
        self.longitude = longitude
        self.maxTemperature24h = maxTemperature24h
        self.minTemperature24h = minTemperature24h
        self.observationTime = observationTime
        self.rawText = rawText
        self.seaLevelPressureMb = seaLevelPressureMb
        self.skyCondition = skyCondition
        self.snowInches = snowInches
        self.stationID = stationID
        self.temperature = temperature
        self.visibility = visibility
        self.weatherString = weatherString
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.windGust = windGust
    }
    
    public func ceilingLayer() -> SkyCondition? {
        // FIXME: relies on skyCondition always being sorted by altitude. Which it is but that could break.
        return self.skyCondition.first(where: { condition in
            switch (condition.coverage) {
            case .bkn, .ovc, .ovx:
                return true
            default:
                return false
            }
        })
    }
}

public struct SkyCondition : Identifiable {
    public let altitude: Int?
    public let coverage: SkyCoverage
    
    public var id: String {
        get {
            return "\(coverage.description())\(String(describing: altitude))"
        }
    }
    
    enum XMLAttribute: String {
        case altitude = "cloud_base_ft_agl"
        case skyCover = "sky_cover"
    }
    // Cloud coverage is reported by the number of 'oktas' (eighths) of the sky that is occupied by cloud.
    // https://en.wikipedia.org/wiki/METAR#Cloud_reporting
    public enum SkyCoverage: String {
        case skc = "SKC" // No cloud/sky clear. In US, indicates human observation.
        case clr = "CLR" // No clouds below 12,000ft. In US, indicates the station is at least partially automated.
        case cavoc = "CAVOC" // Ceiling and visibility OK
        case few = "FEW" // 1-2 oktas
        case sct = "SCT" // 3-4 oktas
        case bkn = "BKN" // 5-7 oktas
        case ovc = "OVC" // 8 oktas
        case ovx = "OVX" // Sky is obscured but no clouds reported

        public func description() -> String {
            let ret: String
            switch self {
            case .skc:
                ret = "Sky clear"
            case .clr:
                ret = "Clear"
            case .cavoc:
                ret = "Ceiling/visibility OK"
            case .few:
                ret = "Few"
            case .sct:
                ret = "Scattered"
            case .bkn:
                ret = "Broken"
            case .ovc:
                ret = "Overcast"
            case .ovx:
                ret = "Obscured w/o cloud"
            }
            return ret
        }
    }
}
