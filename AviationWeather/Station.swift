//
//  Station.swift
//  METAR
//
//  Created by Charles Duyk on 9/21/20.
//

import Foundation
import CoreLocation

public struct Station: Identifiable {
    public let id: String
    public let name: String
    public let state: String
    public let country: String
    public let coordinates: CLLocationCoordinate2D?
    public let altitudeMeters: Double
    public let types: [String]
    
    public static func decodeJSON(_ json:Data) throws -> Station {
        let decoder = JSONDecoder()
        let intermediate = try decoder.decode(_stationJSONStruct.self, from:json)
        return Station(decodedJSON:intermediate)
    }
    
    public static func decodeJSONArray(_ json:Data) throws -> [Station] {
        let decoder = JSONDecoder()
        let intermediate = try decoder.decode([_stationJSONStruct].self, from:json)
        return intermediate.map { Station(decodedJSON:$0) }
    }
    
    public init(id: String, name: String = "", state: String = "", country: String = "", coordinates: CLLocationCoordinate2D? = nil, altitudeMeters: Double = 0.0, types: [String] = []) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coordinates = coordinates
        self.altitudeMeters = altitudeMeters
        self.types = types
    }
    
    private init(decodedJSON: _stationJSONStruct) {
        let coordinates: CLLocationCoordinate2D?
        if let latitude = CLLocationDegrees(decodedJSON.latitude),
           let longitude = CLLocationDegrees(decodedJSON.longitude) {
            coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        }
        else {
            coordinates = nil
        }
        
        self.init(id:decodedJSON.station_id,
                  name:decodedJSON.site.capitalized,
                  state: decodedJSON.state,
                  country: decodedJSON.country,
                  coordinates: coordinates,
                  altitudeMeters: Double(decodedJSON.elevation_m) ?? 0.0,
                  types: decodedJSON.types)
    }
}

fileprivate struct _stationJSONStruct: Codable {
    var station_id: String
    var latitude: String
    var longitude: String
    var elevation_m: String
    var site: String
    var state: String
    var country: String
    var types: [String]
}


