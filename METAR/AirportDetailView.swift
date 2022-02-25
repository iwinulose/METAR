//
//  METARDetailView.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI
import CoreSpotlight

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
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(self.info.id)
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
                    TwoItemRow(title:"Wind", value:formatWind(speed:info.METAR.windSpeed, direction:info.METAR.windDirection, gust:info.METAR.windGust))
                    TwoItemRow(title:"Visibility", value:formatValue(info.METAR.visibility, unit:" mi"))
                    TwoItemRow(title:"Altimeter", value:formatValue(info.METAR.altimeter, unit:" inHg"))
                    TwoItemRow(title:"Temperature", value:formatValue(info.METAR.temperature, unit:" °C", precision:1))
                    TwoItemRow(title:"Dew point", value:formatValue(info.METAR.dewpoint, unit:" °C", precision:1))
//                    TwoItemRow(title:"Weather", value:info.METAR.weatherString ?? "")
//                    TwoItemRow(title:"Density Altitude", value:"\(calculateDensityAltitude(info.METAR.temperature, info.METAR.) ?? "--")"
                }
                if !self.info.METAR.skyCondition.isEmpty {
                    Section (header:Text("Sky conditions")) {
                        Section {
                            ForEach (0 ..< self.info.METAR.skyCondition.count) { index -> TwoItemRow in
                                let condition = self.info.METAR.skyCondition[index]
                                let title = condition.coverage.description()
                                let altitudeString = condition.altitude != nil ? formatValue(condition.altitude, unit:"ft") : ""
                                return TwoItemRow(title:title, value:altitudeString)
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
        .navigationBarItems(trailing: Button(action: { self.refreshData() }) {
            Image(systemName: "arrow.clockwise")
        })
        .onAppear() {
            self.refreshData()
            self.becomeCurrentActivity()
        }
        .onDisappear() {
            self.resignCurrentActivity()
        }
    }
    
    func refreshData() {
        var request = METAR.Request(self.info.station.id)
        request.mostRecentForEachStation = true
        request.hoursBeforeNow = 12
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
                        //FIXME: show error
                        print("Fetched METAR for wrong station")
                    }
                }
            }
            else if let err = err {
                //FIXME: Show this error in the app
                print(err)
            }
            else {
                //FIXME: This should be an alert since it shouldn't happen.
                print("Wat")
            }
        }
    }
        
    func becomeCurrentActivity() {
        // FIXME: Implement
    }
    
    func resignCurrentActivity() {
        // FIXME: Implement
    }
}

fileprivate func formatWind(speed:Int?, direction:Int?, gust:Int?) -> String {
    let formattedSpeed = formatValue(speed, unit:"kts")
    let formattedDirection = formatValue(direction, unit:"°")
    var formattedGust = ""
    if let gust = gust {
        if gust > 0 {
            formattedGust = " (G \(formatValue(gust, unit:"kts")))"
        }
    }
    return "\(formattedDirection) @ \(formattedSpeed)\(formattedGust)"
}

//FIXME: there's probably a way to use generics here
fileprivate func formatValue(_ value: Int?, unit: String = "") -> String {
    var formattedValue = "--"
    var suffix = ""
    
    if let value = value {
        formattedValue = String(format:"%d", value)
    }
    
    if unit != "" {
        suffix = "\(unit)"
    }
    
    return formattedValue + suffix
}

fileprivate func formatValue(_ value: Double?, unit: String = "", precision: Int = 2) -> String {
    var formattedValue = "--"
    var suffix = ""
    
    if let value = value {
        formattedValue = String(format:"%.0\(precision)f", value)
    }
    
    if unit != "" {
        suffix = "\(unit)"
    }
    
    return formattedValue + suffix
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
    
    return minutes == 0 ? "METAR is fresh" : "METAR is \(minutes) \(unitString) old"
}

//fileprivate func calculateDensityAltitude() -> Double? {
//    guard
//}

struct AirportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        var m = METAR()
        m.stationID = "KSTS"
        m.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        return AirportDetailView(info:StationInfo(station:Station(id:"KSTS"), METAR:m))
    }
}
