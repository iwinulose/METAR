//
//  METARRowStyle.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

enum METARRowStyle: String, CaseIterable {
    case raw
    case icons
    
    static func defaultStyle() -> METARRowStyle {
        return .raw
    }
    
    func description() -> String {
        var ret = ""
        
        switch (self) {
        case .raw:
            ret = "METAR"
        case .icons:
            ret = "Simplified"
        }
        
        return ret
    }
}
