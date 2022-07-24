//
//  METARApp.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

@main
struct METARApp: App {
    @StateObject private var model: AppModel = AppModel(UserDefaultsDataSource())
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(model)
        }
        .onChange(of: scenePhase) { phase in
            handlePhaseChange(phase)
        }
    }
    
    private func handlePhaseChange(_ phase:ScenePhase) {
        if phase == .active {
            model.fetchStationData()
        }
    }
}
