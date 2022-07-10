//
//  METARRowStyle+ViewBuilder.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

extension METARRowStyle {
    @ViewBuilder func createAssociatedRow(_ stationInfo: StationInfo) -> some View {
        switch (self) {
        case .raw:
            METARRow(stationInfo)
        case .icons:
            METARIconRow(stationInfo)
        }
    }
}
