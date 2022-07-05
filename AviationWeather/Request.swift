//
//  Request.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/4/22.
//

import Foundation

public enum InfoType {
    case METAR
}

extension InfoType {
    var ADDSDataSource: String {
        get {
            switch self {
            case .METAR:
                return "metars"
            }
        }
    }
}

public struct Request: QueryItemProviding {
    public var type: InfoType
    public var stations = Stations()
    public var timeFrame = TimeFrame()
            
    public init(type: InfoType, stations: Stations = Stations(), timeFrame: TimeFrame = TimeFrame()) {
        self.type = type
        self.stations = stations
        self.timeFrame = timeFrame
    }
    
    func queryItems() -> [URLQueryItem] {
        var ret = [URLQueryItem]()
        
        ret.append(URLQueryItem(name:"dataSource", value:type.ADDSDataSource))
        ret.append(URLQueryItem(name:"requestType", value:"retrieve"))
        ret.append(URLQueryItem(name:"format", value:"xml"))
        
        ret.append(contentsOf: self.stations.queryItems())
        ret.append(contentsOf: self.timeFrame.queryItems())
        
        return ret
    }
}
