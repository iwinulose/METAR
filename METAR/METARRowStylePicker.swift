//
//  METARRowStylePicker.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

import AviationWeather

struct METARRowStylePicker: View {
    @Binding var selectedRowStyle: METARRowStyle
    let stationInfo: StationInfo
    
    var body: some View {
        List {
            ForEach (METARRowStyle.allCases, id: \.rawValue) { style in
                Section( content: {
                    CheckmarkRow(checked: self.selectedRowStyle == style) {
                        style.createAssociatedRow(stationInfo)
                    }
                    .onTapGesture {
                        self.selectedRowStyle = style
                    }
                }, header: {
                    Text(style.description())
                })
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct METARRowTypePicker_Previews: PreviewProvider {
    @State static var selectedRowType: METARRowStyle = .metar
    
    static var previews: some View {
        let station = Station(id: "KSTS")
        var metar = METAR()
        metar.stationID = "KSTS"
        metar.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        metar.windSpeed = 7
        metar.windDirection = 220
        metar.visibility = 7
        let stationInfo = StationInfo(station: station, METAR: metar)
        
        return METARRowStylePicker(
            selectedRowStyle: self.$selectedRowType,
            stationInfo: stationInfo
        )
    }
}
