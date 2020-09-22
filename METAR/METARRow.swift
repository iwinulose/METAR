//
//  METARRow.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

struct METARRow: View {
    let info: StationInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(info.station.id)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text(info.METAR.flightCategory ?? "--")
                    .font(.largeTitle)
                    .bold()
            }
            Text(info.METAR.rawText ?? "")
                .font(.body)
                .multilineTextAlignment(.leading)
        }
    }
}

struct METARRow_Previews: PreviewProvider {
    static var previews: some View {
        var m = METAR()
        m.stationID = "KSTS"
        m.flightCategory = "VFR"
        m.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        return METARRow(info:StationInfo(station:Station(id: "KSTS"), METAR:m))
    }
}
