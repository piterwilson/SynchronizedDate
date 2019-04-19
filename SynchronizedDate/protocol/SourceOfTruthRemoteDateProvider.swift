//
//  SourceOfTruthRemoteDateProvider.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import Foundation

protocol SourceOfTruthRemoteDateProvider {
    func fetchSourceOfTruthDate(completion: @escaping (Date?) -> Void)
}
