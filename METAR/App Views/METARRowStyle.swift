//
//  METARRowStyle.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

enum METARRowStyle: String, CaseIterable {
    case metar
    case icons
    
    static func defaultStyle() -> METARRowStyle {
        return .metar
    }
    
    func description() -> String {
        var ret = ""
        
        switch (self) {
        case .metar:
            ret = "METAR"
        case .icons:
            ret = "Simplified"
        }
        
        return ret
    }
}
