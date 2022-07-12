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
    @EnvironmentObject var model: AppModel
    @State private var showAddStationSheet = false
    @State private var showSettingsSheet = false
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

    @ViewBuilder var detailDestinationView: some View {
        if let pushedStation = self.pushedAirportStation {
            AirportDetailView(info:StationInfo(station:pushedStation, METAR:METAR()))
        }
        else if let pushedID = self.pushedAirportStationID {
            Text("No station information for \"\(pushedID)\"")
        }
        else {
            Text("Not sure how you got here, but you shouldn't")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if model.stationIDs.isEmpty {
                    WelcomeView()
                }
                else {
                    //FIXME: Factor this out into "MyAirportsView" (v1 OK)
                    METARList(
                        rowStyle: self.model.preferredRowStyle,
                        stationInfo:self.model.stationInfo,
                        mover: { self.model.stationIDs.move(fromOffsets: $0, toOffset: $1) },
                        deleter: { self.model.stationIDs.remove(atOffsets:$0) }
                    )
                    .navigationTitle("My Airports")
                    .onAppear {
                        AppView.viewMyAirportsActivity.becomeCurrent()
                    }
                    .onDisappear {
                        AppView.viewMyAirportsActivity.resignCurrent()
                    }
                    .refreshable {
                        model.fetchStationData()
                    }
                }
                NavigationLink(destination:self.detailDestinationView, isActive:self.$pushAirportDetailView) {
                    EmptyView()
                }
            }
            .navigationBarItems(
                leading: makeSettingsButton(),
                trailing: makeAddStationButton()
            )
            // TODO: Use NavigationSplitView on iOS 16 and up
            // On iPad (or big phones in landscape) iOS will show this label
            Text("Choose an airport form the sidebar")
        }
        .sheet(
            isPresented: self.$showAddStationSheet,
            onDismiss: { self.handleAddStation() },
            content: {
                AddAirportSheet(
                    stations:self.model.allStations,
                    selection:self.$selectedStation,
                    showsOnboardingAfterSelection: !self.model.onboardingCompleted
                )
            })
        .sheet(
            isPresented: self.$showSettingsSheet,
            content: {
                SettingsSheet()
            })
        .onContinueUserActivity(kViewMyAirportsActivityType) { activity in
        }
    }
    
    private func makeSettingsButton() -> some View {
        let icon = Image(systemName: "gearshape")
        return Button(action: { self.showSettingsSheet.toggle() }, label: { icon })
    }
    
    private func makeAddStationButton() -> some View {
        return Button(action: { self.showAddStationSheet.toggle() },
                                        label: { Text("Add") })
    }
    
    private func handleAddStation() {
        guard let station = self.selectedStation else {
            return
        }
        self.model.stationIDs.append(station.id)
        if (!self.model.onboardingCompleted) {
            self.model.onboardingCompleted = true
        }
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
        return AppView().environmentObject(model)
    }
}
