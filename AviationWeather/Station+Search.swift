//
//  Station+Search.swift
//  AviationWeather
//
//  Created by Charles Duyk on 7/18/22.
//

import Foundation

extension Array where Element == Station {
    public func search(_ searchTerm: String) -> [Station] {
        if searchTerm.isEmpty {
            return self
        }
        let searchTerm = searchTerm.lowercased()
        return self.filter({ $0.id.lowercased().contains(searchTerm) || $0.name.lowercased().contains(searchTerm)})
    }
}
