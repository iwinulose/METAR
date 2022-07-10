//
//  SettingsSheet.swift
//  METAR
//
//  Created by Charles Duyk on 7/8/22.
//

import SwiftUI

import AviationWeather

struct SettingsSheet: View {
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        DismissableSheet {
            List {
                Section("Appearance") {
                    NavigationLink(
                        destination: {
                            METARRowStyleChooser(
                                selectedRowStyle: $model.preferredRowStyle,
                                stationInfo: _defaultStationInfo()
                            )
                            .navigationTitle("Choose your style")
                        },
                        label: {
                            TwoItemRow(title:"Row style", value: model.preferredRowStyle.description())
                        }
                    )
                }
            }
            .navigationTitle("Settings")
        }
    }
}

fileprivate func _defaultStationInfo() -> StationInfo {
    let station = Station(id: "KMIA")
    let skyCondition = SkyCondition(altitude:nil, coverage:.clr)
    var metar = METAR()
    metar.stationID = "KMIA"
    metar.flightCategory = "VFR"
    metar.rawText = "KMIA 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
    metar.windSpeed = 7
    metar.windDirection = 220
    metar.visibility = 7
    metar.skyCondition.append(skyCondition)
    return StationInfo(station: station, METAR: metar)
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
