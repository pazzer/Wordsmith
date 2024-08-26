//
//  Logger+.swift
//  Wordsmith
//
//  Created by Paul Patterson on 24/08/2024.
//

import Foundation
import os

extension Logger {
    
    private static var wordsmith = "wordsmith"
    
    static let database = Logger(subsystem: wordsmith, category: "database")
    
    static let app = Logger(subsystem: wordsmith, category: "app")
    
}
