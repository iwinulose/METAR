//
//  METARList.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

import AviationWeather

struct METARList: View {
    let rowStyle: METARRow.Style
    let stationInfo : [StationInfo]
    let mover: ((IndexSet, Int) -> Void)?
    let deleter: ((IndexSet) -> Void)?
    
    var body: some View {
        List {
            ForEach(stationInfo) { info in
                NavigationLink(destination:AirportDetailView(info:info)) {
                    self.rowStyle.createAssociatedRow(info)
                }
            }
            .onMove(perform: mover)
            .onDelete(perform: deleter)
            .onDrag {
                NSItemProvider() // Weird trick lets reordering work via drag
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct METARList_Previews: PreviewProvider {
    static var previews: some View {
        let stations = [StationInfo.dummy("KSTS"),
                        StationInfo.dummy("KSFO")]
        return METARList(rowStyle:.metar, stationInfo: stations, mover: nil, deleter: nil)
    }
}
