//
//  AddAirportSheet.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

struct AddAirportSheet: View {
    let stations: [Station]
    @Binding var selection: Station?
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text:$searchText).padding(.top, 10)
                List {
                    ForEach(self.filterStations(searchText)) { station in
                        HStack {
                            Text(station.id + " - " + station.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture(count: 1, perform: {
                            self.selection = station
                            self.dismiss()
                        })
                    }
                }
            }
            .navigationBarTitle("Add Airport")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button("Done") {
                    self.dismiss()
                }
            )
        }
    }
    
    func filterStations(_ searchTerm: String) -> [Station] {
        if searchTerm.isEmpty {
            return self.stations
        }
        let searchTerm = searchTerm.lowercased()
        return stations.filter({ $0.id.lowercased().contains(searchTerm) || $0.name.lowercased().contains(searchTerm)})
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct AddStationSheet_Previews: PreviewProvider {
//    @State var selection: String?
//    
//    static var previews: some View {
//        let stations = ["KSFO", "KSTS"]
//        AddStationSheet(stations: stations, selectedStation:$selection)
//    }
//}
