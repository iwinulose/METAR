//
//  METARList.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

struct METARList: View {
    var stationInfo : [StationInfo]
    var mover: ((IndexSet, Int) -> Void)?
    var deleter: ((IndexSet) -> Void)?
    
    var body: some View {
        List {
            ForEach(stationInfo) { info in
                NavigationLink(destination:AirportDetailView(info:info)) {
                    METARRow(info:info)
                }
            }
            .onMove(perform: mover)
            .onDelete(perform: deleter)
        }
        .listStyle(PlainListStyle())
    }
}

struct METARList_Previews: PreviewProvider {
    static var previews: some View {
        var stations: [StationInfo] = []
        var m = METAR()
        m.stationID = "KSTS"
        m.flightCategory = "VFR"
        m.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        stations.append(StationInfo(station:Station(id:"KSTS"), METAR: m))
        return METARList(stationInfo: stations, deleter: nil)
    }
}
