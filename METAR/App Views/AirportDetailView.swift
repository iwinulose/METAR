//
//  AirportDetailView.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI
import CoreSpotlight

import AviationWeather

let kViewAirportDetailsActivityType = "com.duyk.GetMETAR.ViewAirportDetails"

struct AirportDetailView: View {
    @State var info: StationInfo
    
    var userActity: NSUserActivity {
        get {
            let stationID = self.info.id
            let searchAttributes = CSSearchableItemAttributeSet()
            searchAttributes.contentDescription = "Get METAR for \(stationID)"
            let activity = NSUserActivity(activityType: kViewAirportDetailsActivityType)
            activity.title = "\(stationID) METAR"
            activity.suggestedInvocationPhrase = "Check \(stationID) weather"
            activity.persistentIdentifier =  NSUserActivityPersistentIdentifier(self.info.id)
            activity.isEligibleForPrediction = true
            activity.isEligibleForSearch = true
            activity.contentAttributeSet = searchAttributes
            return activity
        }
    }
    
    var body: some View {
        VStack (alignment:.leading , spacing: 0.0) {
            List {
                Section {
                    TwoItemRow(title:"Flight category", value:info.METAR.flightCategory ?? "--")
                }
                Section {
                    let wind = WeatherStringFormatter.formatWind(speed:info.METAR.windSpeed, direction:info.METAR.windDirection, gust:info.METAR.windGust, unit:.knots)
                    TwoItemRow(title:"Wind", value:wind)
                    
                    let visibility = WeatherStringFormatter.formatValue(info.METAR.visibility, unit:" mi")
                    TwoItemRow(title:"Visibility", value:visibility)
                    
                    let altimeter = WeatherStringFormatter.formatValue(info.METAR.altimeter, unit:" inHg")
                    TwoItemRow(title:"Altimeter", value:altimeter)
                    TwoItemRow(title:"Temperature", value:WeatherStringFormatter.formatValue(info.METAR.temperature, unit:" °C", precision:1))
                    TwoItemRow(title:"Dew point", value:WeatherStringFormatter.formatValue(info.METAR.dewpoint, unit:" °C", precision:1))
                    TwoItemRow(
                        title:"Density altitude",
                        value:WeatherStringFormatter.formatValue(info.METAR.densityAltidueFt, unit:" ft")
//                    TwoItemRow(title:"Weather", value:info.METAR.weatherString ?? "")
                    )
                }
                if !self.info.METAR.skyCondition.isEmpty {
                    Section (header:Text("Sky conditions")) {
                        Section {
                            ForEach(self.info.METAR.skyCondition) { condition in
                                let title = condition.coverage.description()
                                let altitudeString = condition.altitude != nil ? WeatherStringFormatter.formatValue(condition.altitude, unit:" ft") : ""
                                TwoItemRow(title:title, value:altitudeString)
                            }
                        }
                    }
                }

                Section(header: Text("Full METAR")) {
                    Text(info.METAR.rawText ?? "--")
                }
                Section (footer: Text(formatObservationTimeFooter(info.METAR.observationTime))) {
                    TwoItemRow(title:"Observation time (Local)", value:formatDate(info.METAR.observationTime, timeZone:TimeZone.autoupdatingCurrent))
                    TwoItemRow(title:"Observation time (Zulu)", value:formatDate(info.METAR.observationTime, timeZone:TimeZone(secondsFromGMT: 0)!)) // Technically not UTC.
                }
            }.listStyle(GroupedListStyle())
        }
        .navigationBarTitle(info.station.id)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            self.refreshData()
            self.becomeCurrentActivity()
        }
        .onDisappear() {
            self.resignCurrentActivity()
        }
        .refreshable {
            self.refreshData()
        }
    }
    
    func refreshData() {
        let station = Stations(self.info.station.id)
        let timeFrame = TimeFrame(hoursBeforeNow: 12, mostRecentForEachStation: true)
        
        let request = Request(type:.METAR, stations:station, timeFrame:timeFrame)
        AviationWeather.fetch(request) { (response, err) in
            if let metars = response?.metars {
                if metars.count > 0 {
                    let metar = metars[0]
                    if metar.stationID == self.info.station.id {
                        DispatchQueue.main.async {
                            self.info = StationInfo(station:self.info.station, METAR:metars[0])
                        }
                    }
                    else {
                        //FIXME: show error (v1 OK)
                        print("Fetched METAR for wrong station")
                    }
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
        
    func becomeCurrentActivity() {
        // FIXME: Implement (v1 OK)
    }
    
    func resignCurrentActivity() {
        // FIXME: Implement (v1 OK)
    }
}

fileprivate func formatDate(_ date: Date?, timeZone: TimeZone) -> String {
    guard let date = date else {
        return "--:--"
    }
    
    let df = DateFormatter()
    df.timeZone = timeZone
    df.dateFormat = "HH:mm"
    return df.string(from: date)
}

fileprivate func formatObservationTimeFooter(_ date: Date?) -> String {
    guard let date = date else {
        return ""
    }
    
    let minutes: Int = -Int(date.timeIntervalSinceNow/60)
    let unitString = (minutes == 1) ? "minute" : "minutes"
    
    return minutes == 0 ? "METAR is brand new" : "METAR is \(minutes) \(unitString) old"
}

struct AirportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        var m = METAR()
        m.stationID = "KSTS"
        m.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        return AirportDetailView(info:StationInfo(station:Station(id:"KSTS"), METAR:m))
    }
}
