//
//  QueryItemProviding.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/6/22.
//

import Foundation

protocol QueryItemProviding {
    func queryItems() -> [URLQueryItem]
}
