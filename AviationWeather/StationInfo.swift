//
//  StationInfo.swift
//  METAR
//
//  Created by Charles Duyk on 9/19/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import Foundation

public struct StationInfo : Identifiable {
    public let station: Station
    public let METAR: METAR
        
    public var id: String {
        get {
            return self.station.id
        }
    }
    
    public init(station: Station, METAR: METAR) {
        self.station = station
        self.METAR = METAR
    }
    
    public static func dummy(_ id: String) -> StationInfo {
        let station = Station(id: id)
        let skyCondition = SkyCondition(altitude:nil, coverage:.clr)
        var metar = AviationWeather.METAR()
        metar.stationID = id
        metar.flightCategory = "VFR"
        metar.rawText = "\(id) 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        metar.windSpeed = 7
        metar.windDirection = 220
        metar.visibility = 7
        metar.skyCondition.append(skyCondition)
        return StationInfo(station: station, METAR: metar)
    }
}
