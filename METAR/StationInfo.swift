//
//  Station.swift
//  METAR
//
//  Created by Charles Duyk on 9/19/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import Foundation
import AviationWeather

struct StationInfo : Identifiable {
    let station: Station
    let METAR: METAR
    
    var id: String {
        get {
            return self.station.id
        }
    }
}
