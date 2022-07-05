//
//  AppView.swift
//  METAR
//
//  Created by Charles Duyk on 2/1/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import SwiftUI
import CoreSpotlight
import Intents

import AviationWeather

let kViewMyAirportsActivityType = "com.duyk.GetMETAR.ViewMyAirports"

struct AppView: View {
    @ObservedObject var model: AppModel
    @State private var showAddStationSheet = false
    @State private var selectedStation: Station?
    @State private var pushedAirportStationID: String?
    @State private var pushedAirportStation: Station?
    @State private var pushAirportDetailView: Bool = false {
        didSet {
            if !self.pushAirportDetailView {
                self.pushedAirportStationID = nil
                self.pushedAirportStation = nil
            }
        }
    }

    static let viewMyAirportsActivityType = "com.duyk.GetMETAR.ViewMyAirports"
    static let viewMyAirportsActivity: NSUserActivity = _createViewMyAirportsActivity()
    static private func _createViewMyAirportsActivity() -> NSUserActivity {
        let searchAttributes = CSSearchableItemAttributeSet()
        searchAttributes.contentDescription = "Check the weather at your saved airports."
        let activity = NSUserActivity(activityType: kViewMyAirportsActivityType)
        activity.title = "Check METARs"
        activity.keywords = ["weather", "airport", "wind", "visibility", "altimeter", "temperature", "cloud", "METAR", "ATIS"]
        activity.suggestedInvocationPhrase = "Check airport weather"
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(kViewMyAirportsActivityType)
        activity.isEligibleForPrediction = true
        activity.isEligibleForSearch = true
        activity.contentAttributeSet = searchAttributes
        return activity
    }

    var detailDestinationView: AnyView {
        if let pushedStation = self.pushedAirportStation {
            return AirportDetailView(info:StationInfo(station:pushedStation, METAR:METAR())).eraseToAnyView()
        }
        else if let pushedID = self.pushedAirportStationID {
            return Text("No station information for \"\(pushedID)\"").eraseToAnyView()
        }
        else {
            return Text("Not sure how you got here, but you shouldn't").eraseToAnyView()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if model.stationIDs.isEmpty {
                    Text("Add some airports to get started")
                }
                else {
                    //FIXME: Factor this out into "MyAirportsView"
                    METARList(stationInfo:self.model.stationInfo,
                              mover: { self.model.stationIDs.move(fromOffsets: $0, toOffset: $1) },
                              deleter: { self.model.stationIDs.remove(atOffsets:$0) }
                    )
                    .onAppear {
                        AppView.viewMyAirportsActivity.becomeCurrent()
                    }
                    .onDisappear {
                        AppView.viewMyAirportsActivity.resignCurrent()
                    }
                }
                NavigationLink(destination:self.detailDestinationView, isActive:self.$pushAirportDetailView) {
                    EmptyView()
                }
            }
            .navigationTitle("My Airports")
            .navigationBarItems(trailing:Button(action: { self.showAddStationSheet.toggle() },
                                                label: { Text("Add") })
            )
        }
        .sheet(isPresented: self.$showAddStationSheet, onDismiss: { self.handleAddStation() }, content: {
            AddAirportSheet(stations:self.model.allStations, selection:self.$selectedStation)
        })
        .onContinueUserActivity(kViewMyAirportsActivityType) { activity in
        }
        .onContinueUserActivity(kViewAirportDetailsActivityType) { activity in
            
        }
    }
    
    private func handleAddStation() {
        guard let station = self.selectedStation else {
            return
        }
        self.model.stationIDs.append(station.id)
        self.selectedStation = nil
    }
    
    private func showAirportDetails(_ id:String) {
        self.pushedAirportStationID = id
        self.pushedAirportStation = self.model.getStation(id)
        self.pushAirportDetailView = true
        self.showAddStationSheet = false
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let model = AppModel(ArrayAppModelDataSource(["KSFO", "PHNL"]))
        return AppView(model:model)
    }
}
