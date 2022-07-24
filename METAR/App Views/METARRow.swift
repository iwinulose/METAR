//
//  METARRow.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

import AviationWeather

struct METARRow: View {
    enum Style: String, CaseIterable, Identifiable  {
        case metar
        case icons
        
        var id: Style {
            get {
                return self
            }
        }
        
        static func defaultStyle() -> Style {
            return .metar
        }
        
        func description() -> String {
            let ret: String
            
            switch (self) {
            case .metar:
                ret = "METAR"
            case .icons:
                ret = "Simplified"
            }
            
            return ret
        }
        
        @ViewBuilder func createAssociatedRow(_ stationInfo: StationInfo) -> some View {
            switch (self) {
            case .metar:
                METARRow(stationInfo)
            case .icons:
                METARIconRow(stationInfo)
            }
        }
    }

    let info: StationInfo
    
    init(_ info: StationInfo) {
        self.info = info
    }
    
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
        return METARRow(StationInfo(station:Station(id: "KSTS"), METAR:m))
    }
}
