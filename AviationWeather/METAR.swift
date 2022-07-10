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
        // FIXME: relies on skyCondition always being sorted by altitude. Which it is but that could break. (v1 OK)
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
