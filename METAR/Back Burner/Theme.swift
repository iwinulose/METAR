//
//  Theme.swift
//  METAR
//
//  Created by Charles Duyk on 7/20/22.
//

import Foundation

enum Theme: CaseIterable, CustomStringConvertible, Identifiable {
    case basic
    case color
    
    var description: String {
        let ret: String
        
        switch (self) {
        case .basic:
            ret = "Basic"
        case .color:
            ret = "Founder"
        }
        
        return ret
    }
    
    var id: Theme {
        return self
    }
}
