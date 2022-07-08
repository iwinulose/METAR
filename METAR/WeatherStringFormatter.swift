//
//  WeatherStringFormatter.swift
//  METAR
//
//  Created by Charles Duyk on 7/8/22.
//

import Foundation

struct WeatherStringFormatter {
    enum SpeedUnit: String {
        case knots = "kts"
        case mph
        case kph
    }
    
    static func formatWind(speed:Int?, direction:Int?, gust:Int?, unit:SpeedUnit) -> String {
        let formattedSpeed = formatValue(speed, unit:unit.rawValue)
        let formattedDirection = formatValue(direction, unit:"°")
        var formattedGust = ""
        if let gust = gust {
            if gust > 0 {
                formattedGust = " (G \(formatValue(gust, unit:unit.rawValue)))"
            }
        }
        return "\(formattedDirection) @ \(formattedSpeed)\(formattedGust)"
    }

    //FIXME: there's probably a way to use generics here
    static func formatValue(_ value: Int?, unit: String = "") -> String {
        var formattedValue = "--"
        var suffix = ""
        
        if let value = value {
            formattedValue = String(format:"%d", value)
        }
        
        if unit != "" {
            suffix = "\(unit)"
        }
        
        return formattedValue + suffix
    }

    static func formatValue(_ value: Double?, unit: String = "", precision: Int = 2) -> String {
        var formattedValue = "--"
        var suffix = ""
        
        if let value = value {
            formattedValue = String(format:"%.0\(precision)f", value)
        }
        
        if unit != "" {
            suffix = "\(unit)"
        }
        
        return formattedValue + suffix
    }

}
