//
//  AppView.swift
//  METAR
//
//  Created by Charles Duyk on 2/1/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var model: AppModel
    @State var showAddStationSheet = false
    @State var selectedStation: Station?
    
    var body: some View {
        NavigationView {
            if model.stationIDs.isEmpty {
                VStack {
                    Text("Add some airports to get started")
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showAddStationSheet.toggle()
                        }) {
                            Text("Add")
                        }
                    )
                }
            }
            else {
                METARList(stationInfo:self.model.stationInfo,
                          mover: { self.model.stationIDs.move(fromOffsets: $0, toOffset: $1) },
                          deleter: { self.model.stationIDs.remove(atOffsets:$0) })
                .navigationBarTitle("My Airports")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showAddStationSheet.toggle()
                    }) {
                        Text("Add")
                    }
                )
            }
        }
        .sheet(isPresented: $showAddStationSheet, onDismiss: { self.handleAddStation() }, content: {
            AddAirportSheet(stations:self.model.allStations, selection:$selectedStation)
        })
    }
    
    func handleAddStation() {
        guard let station = self.selectedStation else {
            return
        }
        self.model.stationIDs.append(station.id)
        self.selectedStation = nil
    }
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let model = AppModel(ArrayAppModelDataSource(["KSFO", "PHNL"]))
        return AppView(model:model)
    }
}

