//
//  METARRowStylePicker.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

import AviationWeather

struct METARRowStylePicker: View {
    @Binding var selectedRowStyle: METARRow.Style
    let stationInfo: StationInfo
    
    var body: some View {
        List {
            ForEach (METARRow.Style.allCases) { style in
                Section( content: {
                    CheckmarkRow(checked: self.selectedRowStyle == style, checkmarkStyle: .filledCircle) {
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
    @State static var selectedRowType: METARRow.Style = .metar
    
    static var previews: some View {
        let stationInfo = StationInfo.dummy("KSTS")
        
        return METARRowStylePicker(
            selectedRowStyle: self.$selectedRowType,
            stationInfo: stationInfo
        )
    }
}
