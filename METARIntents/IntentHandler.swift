//
//  IntentHandler.swift
//  METARIntents
//
//  Created by Charles Duyk on 7/18/22.
//

import Intents
import UIKit // For NSDataAsset

import AviationWeather

class IntentHandler: INExtension, ViewSingleAirportWeatherIntentHandling {
    
    private(set) lazy var allStations: [Station] = try! Station.decodeJSONArray(NSDataAsset(name:"Stations")!.data)
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func defaultAirport(for intent: ViewSingleAirportWeatherIntent) -> Airport? {
        //FIXME: Get user's top favorite airport if possible
        let station = self.allStations.first(where: {$0.id == "KMIA"})!
        return createAirport(for: station)
    }
    
    func provideAirportOptionsCollection(for intent: ViewSingleAirportWeatherIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<Airport>?, Error?) -> Void) {
        let stations = self.allStations.search(searchTerm ?? "")
        let identifiers = stations.map {
            return createAirport(for: $0)
        }
        let collection = INObjectCollection(items: identifiers)
        completion(collection, nil)
    }
    
    private func createAirport(for station: Station) -> Airport {
        return Airport(identifier: station.id, display: "\(station.id) - \(station.name)")
    }
}
