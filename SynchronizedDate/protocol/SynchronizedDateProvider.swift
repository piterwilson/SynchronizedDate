//
//  SynchronizedDateProvider.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import Foundation

protocol SynchronizedDateProvider {
    var synchronizedDate: Date { get }
    func setSourceOfTruth(date: Date)
}
