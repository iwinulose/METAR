//
//  AppModel.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import Foundation
import UIKit
import AviationWeather

class AppModel: ObservableObject {
    @Published private(set) var stationInfo: [StationInfo] = []
    var preferredRowStyle: METARRowStyle {
        get {
            return self.dataSource.preferredRowStyle
        }
        set {
            self.objectWillChange.send()
            self.dataSource.preferredRowStyle = newValue
        }
    }

    private var dataSource: AppModelDataSource
    private(set) lazy var allStations: [Station] = try! Station.decodeJSONArray(NSDataAsset(name:"Stations")!.data)

    var stationIDs: [String] {
        get {
            return self.dataSource.stationIDs
        }
        set {
            self.dataSource.stationIDs = newValue
            self.updateStationInfo()
            self.fetchStationData()
        }
    }
    
    var metars: [METAR] = [] {
        didSet {
            self.updateStationInfo()
        }
    }

    required init(_ dataSource: AppModelDataSource) {
        self.dataSource = dataSource
        self.updateStationInfo()
    }
    
    private func updateStationInfo() {
        var newStationInfo: [StationInfo] = []
        
        for id in self.stationIDs {
            let newInfo: StationInfo
            let newStation: Station
            let newMETAR: METAR
            let currentStationInfo = self.stationInfo.first(where: {$0.station.id == id})
            
            if let currentStationInfo = currentStationInfo {
                newStation = currentStationInfo.station
            }
            else if let station = self.getStation(id) {
                newStation = station
            }
            else {
                //FIXME: Inform user somehow (v1 OK)
                print("WARNING: No station known info for \(id)")
                newStation = Station(id:id)
            }
            
            if let metar = self.metars.first(where: {$0.stationID == id}) {
                newMETAR = metar
            }
            else {
                newMETAR = METAR()
            }
            
            newInfo = StationInfo(station:newStation, METAR: newMETAR)
            
            newStationInfo.append(newInfo)
        }
        
        self.stationInfo = newStationInfo
    }
    
    func fetchStationData() {
        if self.stationIDs.count == 0 {
            self.stationInfo = []
            return
        }
        
        var timeFrame = TimeFrame()
        timeFrame.hoursBeforeNow = 12
        timeFrame.mostRecentForEachStation = true
        
        var request = Request(type:.METAR, timeFrame: timeFrame)
        request.stations.add(self.stationIDs)
        AviationWeather.fetch(request) { (response, err) in
            if let metars = response?.metars {
                DispatchQueue.main.async {
                    self.metars = metars
                }
            }
            else if let err = err {
                //FIXME: Show this error in the app (v1 OK)
                print(err)
            }
            else {
                //FIXME: This should be an alert since it shouldn't happen. (v1 OK)
                print("Wat")
            }
        }
    }
    
    func getStation(_ id:String) -> Station? {
        return self.allStations.first( where: { $0.id == id })
    }
}

protocol AppModelDataSource {
    var stationIDs: [String] {get set}
    var preferredRowStyle: METARRowStyle {get set}
}

class ArrayAppModelDataSource: AppModelDataSource {
    var stationIDs: [String]
    var preferredRowStyle: METARRowStyle
    
    init(_ stationIDs:[String] = [], preferredRowStyle: METARRowStyle = METARRowStyle.defaultStyle()) {
        self.stationIDs = stationIDs
        self.preferredRowStyle = preferredRowStyle
    }
}

class UserDefaultsDataSource: AppModelDataSource {
    enum Keys: String {
        case requestedStationIDs
        case preferredMETARRowStyle
    }
    
    var stationIDs: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey:Keys.requestedStationIDs.rawValue) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey:Keys.requestedStationIDs.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var preferredRowStyle: METARRowStyle {
        get {
            var ret = METARRowStyle.defaultStyle()
            if let defaultsString = UserDefaults.standard.string(forKey: Keys.preferredMETARRowStyle.rawValue),
               let defaultsStyle = METARRowStyle(rawValue: defaultsString) {
                ret = defaultsStyle
            }
            else {
                //FIXME: Logging cleanup (v1 OK)
                print("Unable to read style from user defaults, returning \(ret.rawValue)")
            }
            
            return ret
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.preferredMETARRowStyle.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
