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

// Per Wikipedia: https://en.wikipedia.org/wiki/Density_altitude#Approximation_formula_for_calculating_the_density_altitude_from_the_pressure_altitude
public func approximateDensityAltitude(tempC: Double, altimeter: Double, fieldElevationFt: Int) -> Int {
    // Formula constants
    let standardPressure = 29.92
    let pressureAltitudeCoefficient = 1.2376
    let outsideAirTemperatureCoefficient = 118.8
    let altitudeCorrectionConstant = 1782
    
    let approximatePressureAltitudeDelta = Int((standardPressure - altimeter) * 1000)
    let approximatePressureAltitude = fieldElevationFt + approximatePressureAltitudeDelta
    let approximateDensityAltitude = Int(pressureAltitudeCoefficient * Double(approximatePressureAltitude) + outsideAirTemperatureCoefficient * tempC - Double(altitudeCorrectionConstant))
    
    return approximateDensityAltitude
}

public func celsiusToFarenheit(_ celsius: Double) -> Double {
    return 1.8 * celsius + 32
}

// More accurate formula but would require a lot more work to get the data
// Per Wikipedia: https://en.wikipedia.org/wiki/Density_altitude#The_National_Weather_Service_(NWS)_Formula
//public func approximateDensityAltitudeNWS(tempC: Double, altimeter: Double, fieldElevation: Double) -> Double {
//    let tempF = celsiusToFarenheit(tempC)
//    let altitudeCoefficientFt = 145442.16
//    let pressureTemperatureConversionCoefficient = 17.326
//    let temperatureDenominatorConstant = 459.67
//    let exponent = 0.235
//    let numerator = pressureTemperatureConversionCoefficient * pressureInHg
//    let denominator = temperatureDenominatorConstant + tempF
//    let fraction = numerator/denominator
//    let exponentiationResult = pow(fraction, exponent)
//    return altitudeCoefficientFt * (1.0 - exponentiationResult)
//}
