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
                Text(self.info.station.id)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text(self.info.METAR.flightCategory ?? "--")
                    .font(.largeTitle)
                    .bold()
            }
            HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                makeWindIcon()
                    .frame(maxWidth:.infinity)
                LabeledIcon(icon:Image(systemName:"binoculars"), label: visibilityIconLabel)
                    .frame(maxWidth:.infinity)
                makeSkyConditionIcon()
                    .frame(maxWidth:.infinity)
            }
        }
    }
    
    //FIXME: This looks bad with particularly long strings and gusts, especially on smaller devices. (v1 OK)
    private func makeWindIcon() -> some View {
        let metar = self.info.METAR
        let speed = metar.windSpeed
        let direction = metar.windDirection
        let gust = metar.windGust
        let label = WeatherStringFormatter.formatWind(speed: speed, direction: direction, gust: gust, unit: .knots)
        let icon = Image(systemName:"wind")
        let ret = LabeledIcon(icon:icon, label: label)
        return ret
    }
    
    private func makeSkyConditionIcon() -> AnyView {
        let ret: AnyView
        var skyCondition: SkyCondition? = nil
        let metar = self.info.METAR
        
        if let ceiling = metar.ceilingLayer() {
            skyCondition = ceiling
        }
        else {
            skyCondition = metar.skyCondition.first
        }
        
        if let skyCondition = skyCondition {
            ret = skyCondition.labeledIcon(forTime: metar.observationTime).eraseToAnyView()
        }
        else {
            ret = LabeledIcon(icon:Image(systemName: "arrow.triangle.2.circlepath"),
                               label: "Fetching").eraseToAnyView()
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

extension Date {
    func isDaytime() -> Bool {
        let hours = Calendar.current.component(.hour, from: self)
        return hours >= 7 && hours < 20
    }
}

extension SkyCondition { //Icon Generating
    @ViewBuilder func labeledIcon(forTime date: Date? = nil) -> some View {
        let icon = self.icon(forTime: date)
        let label = self.labelText()
        
        switch (self.coverage) {
        case .skc, .clr, .cavoc:
            let styledIcon = icon.foregroundColor(Color.yellow)
            LabeledIcon(icon: styledIcon, label: label)
        case .few, .sct:
            let styledIcon = icon
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.primary, Color.yellow, Color(red: 0.35, green: 0.72, blue: 0.83))
            LabeledIcon(icon:styledIcon, label: label)
        default:
            LabeledIcon(icon: icon, label: label)
        }
    }
    
    func labelText() -> String {
        var ret = ""
        
        if let altitude = self.altitude {
            ret = "\(WeatherStringFormatter.formatValue(altitude, unit: " ft"))"
        }
        
        if ret.count > 0 {
            ret += "\n"
        }
         
        ret += self.coverage.description()
        
        return ret
    }
    
    func icon(forTime date: Date? = nil) -> Image {
        var imageName = "questionmark.circle"
        var isDaytime = true
        
        if let date = date {
            isDaytime = date.isDaytime()
        }
        
        switch (self.coverage) {
        case .skc, .clr, .cavoc:
            imageName = isDaytime ? "sun.max" : "moon"
        case .few, .sct:
            imageName = isDaytime ? "cloud.sun" : "cloud.moon"
        default:
            imageName = "cloud"
        }
        
        return Image(systemName: imageName)
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


