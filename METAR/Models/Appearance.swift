//
//  Appearance.swift
//  METAR
//
//  Created by Charles Duyk on 7/25/22.
//

import Foundation

import SwiftUI

enum Appearance: String, CaseIterable, CustomStringConvertible, Identifiable {
    case auto
    case light
    case dark
    
    var id: Appearance {
        return self
    }
    
    var description: String {
        let ret: String
        
        switch (self) {
        case .light:
            ret = "Light"
        case .dark:
            ret = "Dark"
        case .auto:
            ret = "Automatic"
        }
        
        return ret
    }
    
    func toColorScheme() -> ColorScheme? {
        var ret: ColorScheme?
        
        switch (self) {
        case .light:
            ret = .light
        case .dark:
            ret = .dark
        default:
            ret = nil
        }
        
        return ret
    }
}
