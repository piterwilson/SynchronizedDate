//
//  WorldClockApiService.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import Foundation

class WorldClockApiService: SourceOfTruthRemoteDateProvider {
    /// Remote API endpoint
    private let remoteURL: String = "http://worldclockapi.com/api/json/utc/now"
    
    /// Makes a call to the remote server to fetch the "source of truth" Date.
    ///
    /// - Parameter completion: Callback to be executed when the remote server call is complete. A `nil` value signals an error in the network call.
    func fetchSourceOfTruthDate(completion: @escaping (Date?) -> Void) {
        guard let url = URL(string: remoteURL) else {
            completion(nil)
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // if there's an error execute the callback with a `nil` Date response
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            // if no data is available execute the callback with a `nil` Date response
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                // try to decode our response using `JSONDecoder` and `WorldClockApiCodable`
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.worldClockApiDate)
                let decodedObject = try decoder.decode(WorldClockApiCodable.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedObject.currentDateTime)
                }
            } catch let error {
                // if there's an error execute the callback with a `nil` Date response
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
}

struct WorldClockApiCodable: Codable {
    let currentDateTime: Date
}

extension DateFormatter {
    // Workclockapi.com uses a non-standard date format
    static let worldClockApiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
