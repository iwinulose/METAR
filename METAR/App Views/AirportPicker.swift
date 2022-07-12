//
//  AirportPicker.swift
//  METAR
//
//  Created by Charles Duyk on 7/11/22.
//

import SwiftUI

struct AirportPicker: View {
    let stations: [Station]
    @Binding var selection: Station?
    let airportPicked: (() -> Void)?
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text:self.$searchText)
                .padding(.top, 10)
                .disableAutocorrection(true)
            if self.searchText.count < 2 {
                Spacer()
                Text("Search for airport by ICAO identifier or city")
                    .multilineTextAlignment(.center)
                Spacer()
            }
            else {
                List {
                    ForEach(self.filterStations(self.searchText)) { station in
                        HStack {
                            Text(station.id + " - " + station.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selection = station
                            self.airportPicked?()
                        }
                    }
                }
            }
        }
    }
    
    private func filterStations(_ searchTerm: String) -> [Station] {
        if searchTerm.isEmpty {
            return self.stations
        }
        let searchTerm = searchTerm.lowercased()
        return stations.filter({ $0.id.lowercased().contains(searchTerm) || $0.name.lowercased().contains(searchTerm)})
    }

}

struct AirportPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
//        AddAirportView()
    }
}
