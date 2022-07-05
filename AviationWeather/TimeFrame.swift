//
//  TimeFrame.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/6/22.
//

import Foundation

public struct TimeFrame {
    public var startDate: Date?
    public var endDate: Date?
    public var hoursBeforeNow: Double?
    public var mostRecentForEachStation = false
    
    public init(startDate: Date? = nil, endDate: Date? = nil, hoursBeforeNow: Double? = nil, mostRecentForEachStation: Bool = false) {
        self.startDate = startDate
        self.endDate = endDate
        self.hoursBeforeNow = hoursBeforeNow
        self.mostRecentForEachStation = mostRecentForEachStation
    }
}

extension TimeFrame: QueryItemProviding {
    func queryItems() -> [URLQueryItem] {
        var ret = [URLQueryItem]()
        
        if let startDate = self.startDate {
            let dateString = startDate.ISO8601String()
            let item = URLQueryItem(name:"startTime", value:dateString)
            ret.append(item)
        }
        
        if let endDate = self.endDate {
            let dateString = endDate.ISO8601String()
            let item = URLQueryItem(name:"endTime", value:dateString)
            ret.append(item)
        }
        
        if let hoursBeforeNow = self.hoursBeforeNow {
            let item = URLQueryItem(name:"hoursBeforeNow", value:String(hoursBeforeNow))
            ret.append(item)
        }
        
        if self.mostRecentForEachStation {
            let item = URLQueryItem(name: "mostRecentForEachStation", value:"true")
            ret.append(item)
        }
        
        return ret
    }
}
