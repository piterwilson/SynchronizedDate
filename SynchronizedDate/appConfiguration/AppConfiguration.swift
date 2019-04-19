//
//  AppConfiguration.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import Foundation
/// A container for the Application dependencies.
struct AppConfiguration {
    static var synchronizedDateProvider: SynchronizedDateProvider = SynchronizedDateService()
    static var sourceOfTruthRemoteDateProvider: SourceOfTruthRemoteDateProvider = WorldClockApiService()
}
