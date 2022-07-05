//
//  Client.swift
//  AviationWeather
//
//  Created by Charles Duyk on 3/4/22.
//

import Foundation

public struct Client {
    public static let defaultURL = URL(string:"https://aviationweather.gov/adds/dataserver_current/httpparam")!
    
    public var baseURL = defaultURL
    public var logger: Logger?
    
    enum RequestError: LocalizedError {
        case baseURLMalformed
        case urlGenerationError
        case noData
    }
    
    public func fetch(_ request: Request, completion:@escaping (Response?, Error?) -> ()) {
        guard var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            self._log("baseURL (\(self.baseURL)) didn't resolve", level: .error)
            DispatchQueue.global().async {
                completion(nil, RequestError.baseURLMalformed)
            }
            return
        }
        
        components.queryItems = request.queryItems()
        
        guard let requestURL = components.url else {
            self._log("Error generating URL (components: \(components))", level: .error)
            DispatchQueue.global().async {
                completion(nil, RequestError.urlGenerationError)
            }
            return
        }
                
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, err) in
            var metarResponse: Response?
            var outErr: Error?

            if let err = err {
                completion(nil, err)
                return
            }
                        
            guard let data = data else {
                completion(nil, RequestError.noData)
                return
            }
            
            self._log("Successfully completed response for \(requestURL)", level:.debug)
            self._log(String(data:data, encoding:.utf8)!, level:.debug)
        
            do {
                try metarResponse = Response(data)
            } catch let err {
                self._log("Error parsing response:\(err)", level: .error)
                metarResponse = nil
                outErr = err
            }
            
            completion(metarResponse, outErr)
        }
        task.resume()
    }
    
    private func _log(_ message: String, level: LogLevel) {
        self.logger?.log(message, level:level)
    }
}

