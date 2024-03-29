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
        NavigationView {
            DismissingView {
                List {
                    Section("Appearance") {
                        NavigationLink(
                            destination: {
                                METARRowStylePicker(
                                    selectedRowStyle: self.$model.preferredRowStyle,
                                    stationInfo: self._exampleStationInfo()
                                )
                                    .navigationTitle("Choose a row style")
                            },
                            label: {
                                TwoItemRow(title:"Row style", value: self.model.preferredRowStyle.description)
                            }
                        )
                        NavigationLink(
                            destination: {
                                CasePicker(selected:self.$model.preferredAppearance)
                                    .navigationTitle("Choose appearance")
                            },
                            label: {
                                TwoItemRow(title:"Appearance", value: self.model.preferredAppearance.description)
                            }
                        )
                    }
                    Section("The boring stuff") {
                        NavigationLink(
                            destination: {
                                Text("Legal and stuff")
                            },
                            label: {
                                TwoItemRow(title: "Privacy & Legal")
                            }
                        )
                    }
                }
                .navigationTitle("Settings")
            }
        }
        .preferredColorScheme(model.preferredAppearance.toColorScheme())
    }
    
    private func _exampleStationInfo() -> StationInfo {
        let stationInfo: StationInfo
        
        // Show a real world example if the user has one, or use dummy data
        if let userStationInfo = self.model.stationInfo.first,
            userStationInfo.METAR.flightCategory != nil {
            stationInfo = userStationInfo
        }
        else {
            stationInfo = StationInfo.dummy("KMIA")
        }
        
        return stationInfo
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
