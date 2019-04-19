//
//  SynchronizedDateService.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import Foundation

class SynchronizedDateService: SynchronizedDateProvider {
    
    /// A place to store the difference between local time and the 'source of truth` date
    private var localTimeDifference: TimeInterval = 0
    
    /// The calculated Date synchronized
    var synchronizedDate: Date {
        return Date().addingTimeInterval(localTimeDifference)
    }
    
    /// Signals the "source of truth" Date, which calculates the value of `localTimeDifference`
    func setSourceOfTruth(date: Date) {
        localTimeDifference = date.timeIntervalSince1970 - Date().timeIntervalSince1970
    }
}
