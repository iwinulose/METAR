//
//  Stations.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/6/22.
//

import Foundation

public struct Stations  {
    private var stations: Set<String> = []
    
    public init() {
        self.init(Set())
    }
    
    public init(_ stations: String...) {
        self.init(stations)
    }
    
    public init(_ stations: [String]) {
        self.init(Set(stations))
    }
    
    public init(_ stations: Set<String>) {
        self.stations = stations
    }
    
    public mutating func add(_ station: String) {
        self.stations.insert(station)
    }
    
    public mutating func add(_ stations: [String]) {
        for station in stations {
            self.add(station)
        }
    }
    
    public mutating func add(_ stations: String...) {
        self.add(stations)
    }
    
    public mutating func remove(_ station: String) {
        self.stations.remove(station)
    }
    
    public mutating func remove(_ stations: [String]) {
        for station in stations {
            self.remove(station)
        }
    }
    
    public mutating func remove(_ stations: String...) {
        self.remove(stations)
    }
}

extension Stations: QueryItemProviding {
    func queryItems() -> [URLQueryItem] {
        var ret = [URLQueryItem]()
        
        if self.stations.count > 0 {
            let item = URLQueryItem(name:"stationString", value:self.stations.joined(separator: ","))
            ret.append(item)
        }
        
        return ret
    }
}
