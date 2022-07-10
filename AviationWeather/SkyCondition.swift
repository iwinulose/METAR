//
//  SkyCondition.swift
//  AviationWeather
//
//  Created by Charles Duyk on 7/9/22.
//

import Foundation

public struct SkyCondition : Identifiable {
    public let altitude: Int?
    public let coverage: SkyCoverage

    public var id: String {
        get {
            return "\(coverage.description())\(String(describing: altitude))"
        }
    }
    
    public init(altitude: Int?, coverage: SkyCondition.SkyCoverage) {
        self.altitude = altitude
        self.coverage = coverage
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
