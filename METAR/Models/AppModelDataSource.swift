//
//  AppModelDataSource.swift
//  METAR
//
//  Created by Charles Duyk on 7/25/22.
//

import Foundation

protocol AppModelDataSource {
    var stationIDs: [String] {get set}
    var onboardingCompleted: Bool {get set}
    var preferredRowStyle: METARRow.Style {get set}
    var preferredAppearance: Appearance {get set}
}
