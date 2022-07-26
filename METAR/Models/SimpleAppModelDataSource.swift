//
//  SimpleDataSource.swift
//  METAR
//
//  Created by Charles Duyk on 7/25/22.
//

import Foundation

class SimpleAppModelDataSource: AppModelDataSource {
    var stationIDs: [String]
    var onboardingCompleted: Bool = false
    var preferredRowStyle: METARRow.Style = METARRow.Style.defaultStyle()
    var preferredAppearance: Appearance = .auto

    
    init(_ stationIDs:[String] = []) {
        self.stationIDs = stationIDs
    }
}
