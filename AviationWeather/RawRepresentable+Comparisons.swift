//
//  RawRepresentable+Comparisons.swift
//  METAR
//
//  Created by Charles Duyk on 3/2/22.
//

import Foundation

func <<T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue < b.rawValue
}

func ><T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue > b.rawValue
}

func <=<T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue <= b.rawValue
}

func >=<T: RawRepresentable>(a: T, b: T) -> Bool where T.RawValue: Comparable {
    return a.rawValue >= b.rawValue
}
