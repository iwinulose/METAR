//
//  METARIconRow.swift
//  METAR
//
//  Created by Charles Duyk on 7/8/22.
//

import SwiftUI

import AviationWeather

struct METARIconRow: View {
    let info: StationInfo
    
    init(_ info: StationInfo) {
        self.info = info
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            HStack {
                Text(info.station.id)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text(info.METAR.flightCategory ?? "--")
                    .font(.largeTitle)
                    .bold()
            }
            HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                makeWindIcon()
                    .frame(maxWidth:.infinity)
                LabeledIcon(systemImageName:"binoculars", label: visibilityIconLabel)
                    .frame(maxWidth:.infinity)
                makeSkyConditionIcon()
                    .frame(maxWidth:.infinity)
            }
        }
    }
    
    //FIXME: This looks bad with particularly long strings and gusts, especially on smaller devices. (v1 OK)
    private func makeWindIcon() -> some View {
        let metar = info.METAR
        let speed = metar.windSpeed
        let direction = metar.windDirection
        let gust = metar.windGust
        let label = WeatherStringFormatter.formatWind(speed: speed, direction: direction, gust: gust, unit: .knots)
        let ret = LabeledIcon(systemImageName:"wind", label: label)
        return ret
    }
    
    private func makeSkyConditionIcon() -> some View {
        var ret = LabeledIcon(systemImageName: "arrow.triangle.2.circlepath", label: "Fetching")
        var skyCondition: SkyCondition? = nil
        
        if let ceiling = info.METAR.ceilingLayer() {
            skyCondition = ceiling
        }
        else {
            skyCondition = info.METAR.skyCondition.first
        }
        
        if let skyCondition = skyCondition {
            let imageName = imageNameForSkyCoverage(skyCondition.coverage, atTime:info.METAR.observationTime)
            let label = labelForSkyCondition(skyCondition)
            ret = LabeledIcon(systemImageName: imageName, label: label)
        }
        
        return ret
    }
    
    private var visibilityIconLabel: String {
        get {
            let metar = info.METAR
            let visibility = metar.visibility
            return WeatherStringFormatter.formatValue(visibility, unit: " mi", precision: 0)
        }
    }
}

fileprivate func imageNameForSkyCoverage(_ coverage: SkyCondition.SkyCoverage, atTime date: Date? = nil) -> String {
    var ret = "questionmark.circle"
    var isDaytime = true
    
    if let date = date {
        isDaytime = date.isDaytime()
    }
    
    switch (coverage) {
    case .skc, .clr, .cavoc:
        ret = isDaytime ? "sun.max" : "moon"
    case .few, .sct:
        ret = isDaytime ? "cloud.sun" : "cloud.moon"
    default:
        ret = "cloud"
    }
    
    return ret
}

fileprivate func labelForSkyCondition(_ skyCondition: SkyCondition) -> String {
    var ret = ""
    
    if let altitude = skyCondition.altitude {
        ret = " \(WeatherStringFormatter.formatValue(altitude, unit: " ft"))"
    }
    
    if ret.count > 0 {
        ret += "\n"
    }
     
    ret += skyCondition.coverage.description()
    
    return ret
}

extension Date {
    func isDaytime() -> Bool {
        let hours = Calendar.current.component(.hour, from: self)
        return hours >= 7 && hours < 20
    }
}

struct METARIconRow_Previews: PreviewProvider {
    static var previews: some View {
        var m = METAR()
        m.stationID = "KSTS"
        m.flightCategory = "VFR"
        m.windSpeed = 12
        m.visibility = 10.0
//        m.windGust = 15
        m.windDirection = 120
        m.rawText = "KSTS 200053Z AUTO 22007KT 7SM HZ CLR 28/11 A2988 RMK AO2 SLP112 T02830111"
        return METARIconRow(StationInfo(station:Station(id: "KSTS"), METAR:m))
    }
}


