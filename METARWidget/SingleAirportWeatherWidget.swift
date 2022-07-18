//
//  SingleAirportWeatherWidget.swift
//  SingleAirportWeatherWidget
//
//  Created by Charles Duyk on 7/17/22.
//

import WidgetKit
import SwiftUI
import Intents

import AviationWeather

struct SingleAirportWidgetTimelineProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SingleAirportTimelineEntry {
        //FIXME: Try to get the user's default
        return SingleAirportTimelineEntry.dummy("KMIA")
    }
    
    func getSnapshot(for configuration: ViewSingleAirportWeatherIntent, in context: Context, completion: @escaping (SingleAirportTimelineEntry) -> ()) {
        let identifier = configuration.airport?.identifier ?? "KMIA"
        getCurrentMETAR(identifier) { metar, err in
            let now = Date()
            let entry = SingleAirportTimelineEntry(
                date: now,
                airportIdentifier: identifier,
                metar: metar,
                fetchError: err)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ViewSingleAirportWeatherIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let identifier = configuration.airport?.identifier ?? "KMIA"
        getCurrentMETAR(identifier) { metar, err in
            let now = Date()
            let entry = SingleAirportTimelineEntry(
                date: now,
                airportIdentifier: identifier,
                metar: metar,
                fetchError: err)
            let entries = [entry]
            let nextUpdate = calculateNextUpdateTime(for: metar)
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    private func getCurrentMETAR(_ airportIdentifier: String, completion: @escaping (METAR?, Error?) -> ()) {
        var timeFrame = TimeFrame()
        timeFrame.hoursBeforeNow = 12
        timeFrame.mostRecentForEachStation = true
        
        let stations = Stations(airportIdentifier)
        let request = Request(type:.METAR, stations: stations, timeFrame: timeFrame)
        
        AviationWeather.fetch(request) { (response, err) in
            let metar = response?.metars.first
            completion(metar, err)
        }
    }
        
    private func calculateNextUpdateTime(for metar: METAR?) -> Date {
        let kProposedIntervalAfterEstimateMinutes = 13
        let kRetryIntervalMinutes = 10
        let kJitterIntervalSeconds = 120
        
        let calendar = Calendar.current
        let now = Date()
        var ret: Date
        
        if let metar = metar,
           let observationDate = metar.observationTime {
            let nextObservationEstimate = calendar.date(byAdding: .hour, value: 1, to: observationDate)!
            let proposedUpdateTime = calendar.date(byAdding: .minute, value: kProposedIntervalAfterEstimateMinutes, to: nextObservationEstimate)!
            let intervalToProposedUpdateTime = now.distance(to: proposedUpdateTime)
            
            if intervalToProposedUpdateTime > 0 {
                ret = proposedUpdateTime
            }
            else {
                // We should have already seen this update (the observation was supposed to have already happened. Try again in a few minutes
                ret = calendar.date(byAdding: .minute, value: kRetryIntervalMinutes, to: now)!
            }
        }
        else {
            print("No METAR was found. Scheduling update in a few mintues.")
            ret = calendar.date(byAdding: .minute, value: kRetryIntervalMinutes, to: now)!
        }
        
        // Add some noise to the time so that devices don't all wake up at once
        let jitter = Int.random(in:-kJitterIntervalSeconds..<(kJitterIntervalSeconds + 1))
        ret = calendar.date(byAdding: .second, value: jitter, to: ret)!
        
        return ret
    }
}

struct SingleAirportTimelineEntry: TimelineEntry {
    let date: Date
    let airportIdentifier: String?
    let metar: METAR?
    let fetchError: Error?
    
    static func dummy(_ id: String, withData: Bool = true) -> SingleAirportTimelineEntry {
        var metar = METAR()
        
        if withData {
            let skyCondition = SkyCondition(altitude: nil, coverage: .clr)

            metar.stationID = id
            metar.flightCategory = "VFR"
            metar.rawText = "\(id) 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
            metar.windSpeed = 7
            metar.windDirection = 220
            metar.visibility = 7
            metar.skyCondition.append(skyCondition)
        }
        
        return SingleAirportTimelineEntry(date:Date(), airportIdentifier:id, metar:metar, fetchError:nil)
    }
}

struct SingleAirportWeatherWidgetEntryView : View {
    var entry: SingleAirportWidgetTimelineProvider.Entry
    //TODO: Customize based on widget family
    @Environment(\.widgetFamily) var widgetFamily: WidgetFamily
    
    private let edgePadding: CGFloat = 10

    var body: some View {
        VStack (spacing:8) {
            HStack{
                Text(entry.airportIdentifier ?? "---")
                    .bold()
                    .padding(EdgeInsets(top: edgePadding, leading: edgePadding, bottom: 0, trailing: 0))
                    Spacer()
                Text(entry.metar?.flightCategory ?? "---")
                    .bold()
                    .padding(EdgeInsets(top: edgePadding, leading: 0, bottom: 0, trailing: edgePadding))

            }
            VStack (spacing:0) {
                //FIXME: Show the simplified or METAR view.
                Text(entry.metar?.rawText ?? "---")
                    .padding(.horizontal, edgePadding)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

// Reminder: When it's time to create multiple widgets, we can conform to WidgetBundle instead of Widget as
@main
struct SingleAirportWeatherWidget: Widget {
    let kind: String = "SingleAirportWeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ViewSingleAirportWeatherIntent.self, provider: SingleAirportWidgetTimelineProvider()) { entry in
            SingleAirportWeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("View METAR")
        .description("Displays the current METAR for an airport.")
        .supportedFamilies([.systemSmall, .systemMedium]) //FIXME: Add other families
    }
}

struct SingleAirportWeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        SingleAirportWeatherWidgetEntryView(entry:SingleAirportTimelineEntry.dummy("KSFO"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        SingleAirportWeatherWidgetEntryView(entry:SingleAirportTimelineEntry.dummy("KSFO"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
