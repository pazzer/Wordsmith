//
//  Nameable.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import SwiftData

protocol Nameable: PersistentModel {
    var name: String { get set }
}
