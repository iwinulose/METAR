//
//  Logging.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/4/22.
//

import Foundation

public enum LogLevel: Int {
    case debug = 0
    case warning
    case error
}

public protocol Logger {
    func log(_ message: String, level: LogLevel)
}

public struct DefaultLogger : Logger {
    public var minLogLevel: LogLevel = .warning
    
    public func log(_ message: String, level: LogLevel) {
        if (level >= self.minLogLevel) {
            print(message)
        }
    }
}
