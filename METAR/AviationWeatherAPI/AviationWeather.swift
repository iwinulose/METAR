//
//  AviationWeather.swift
//  METAR
//
//  Created by Charles Duyk on 2/13/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import Foundation

struct AviationWeather {
    static let defaultURL = URL(string:"https://aviationweather.gov/adds/dataserver_current/httpparam")!

    enum RequestError: LocalizedError {
        case baseURLMalformed
        case urlGenerationError
        case noData
    }
    
    static func fetch(_ request: METAR.Request, baseURL: URL = defaultURL, completion:@escaping (METAR.Response?, Error?) -> ()) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            print("baseURL didn't resolve")
            DispatchQueue.global().async {
                completion(nil, RequestError.baseURLMalformed)
            }
            return
        }
        
        components.queryItems = request.queryItems()
        
        guard let requestURL = components.url else {
            print("Error generating URL (components: \(components))")
            DispatchQueue.global().async {
                completion(nil, RequestError.urlGenerationError)
            }
            return
        }
                
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, err) in
            var metarResponse: METAR.Response?
            var outErr: Error?

            if let err = err {
                completion(nil, err)
                return
            }
                        
            guard let data = data else {
                completion(nil, RequestError.noData)
                return
            }
            
            print(String(data:data, encoding:.utf8)!)
            
            do {
                try metarResponse = METAR.Response(data)
            } catch let err {
                print(err)
                metarResponse = nil
                outErr = err
            }
            
            completion(metarResponse, outErr)
        }
        task.resume()
    }
    
    // Per Wikipedia: https://en.wikipedia.org/wiki/Density_altitude#The_National_Weather_Service_(NWS)_Formula
    // FIXME: Convert to a function when converting to Framework
    public static func approximateDensityAltitude(tempF: Double, pressureInHg: Double) -> Double {
        let altitudeCoefficientFt = 145442.16
        let pressureTemperatureConversionCoefficient = 17.326
        let temperatureDenominatorConstant = 459.67
        let exponent = 0.235
        let numerator = pressureTemperatureConversionCoefficient * pressureInHg
        let denominator = temperatureDenominatorConstant + tempF
        let fraction = numerator/denominator
        let exponentiationResult = pow(fraction, exponent)
        return altitudeCoefficientFt * (1.0 - exponentiationResult)
    }
    
    public static func celsiusToFarenheit(_ celsius: Double) -> Double {
        return 1.8 * celsius + 32
    }

}

