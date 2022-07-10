//
//  AviationWeather.swift
//  METAR
//
//  Created by Charles Duyk on 2/13/20.
//  Copyright © 2020 Charles Duyk. All rights reserved.
//

import Foundation

internal var defaultClient = Client(logger: DefaultLogger())

public func fetch(_ request: Request, completion:@escaping (Response?, Error?) -> ()) {
    defaultClient.fetch(request, completion:completion)
}

// FIXME: are these functions needed? Is this the right spot for this? (v1 OK)
// Per Wikipedia: https://en.wikipedia.org/wiki/Density_altitude#The_National_Weather_Service_(NWS)_Formula
public func approximateDensityAltitude(tempC: Double, pressureInHg: Double) -> Double {
    let tempF = 1.8 * tempC + 32
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

public func celsiusToFarenheit(_ celsius: Double) -> Double {
    return 1.8 * celsius + 32
}
