//
//  UserDefaultsDataSource.swift
//  METAR
//
//  Created by Charles Duyk on 7/25/22.
//

import Foundation

class UserDefaultsDataSource: AppModelDataSource {
    enum Keys: String {
        case requestedStationIDs
        case preferredAppearance
        case preferredMETARRowStyle
        case onboardingCompleted
    }
    
    var stationIDs: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey:Keys.requestedStationIDs.rawValue) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey:Keys.requestedStationIDs.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var preferredAppearance: Appearance {
        get {
            var ret: Appearance = .auto
            if let defaultsString = UserDefaults.standard.string(forKey: Keys.preferredAppearance.rawValue),
               let defaultsAppearance = Appearance(rawValue: defaultsString) {
                ret = defaultsAppearance
            }
            else {
                //FIXME: Logging cleanup (v1 OK)
                print("Unable to read appearance from user defaults, returning \(ret.rawValue)")
            }
            
            return ret
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey:Keys.preferredAppearance.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var preferredRowStyle: METARRow.Style {
        get {
            var ret = METARRow.Style.defaultStyle()
            if let defaultsString = UserDefaults.standard.string(forKey: Keys.preferredMETARRowStyle.rawValue),
               let defaultsStyle = METARRow.Style(rawValue: defaultsString) {
                ret = defaultsStyle
            }
            else {
                //FIXME: Logging cleanup (v1 OK)
                print("Unable to read style from user defaults, returning \(ret.rawValue)")
            }
            
            return ret
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.preferredMETARRowStyle.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var onboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey:Keys.onboardingCompleted.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey:Keys.onboardingCompleted.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
