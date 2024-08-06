//
//  WordType.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import SwiftData
import SwiftUI

@Model
class WordType: Nameable, CustomDebugStringConvertible {
 
    var name: String
    
    @Relationship(deleteRule: .nullify)
    var definitions: [Definition] = []
    
    let id: UUID
    
    init(name: String) {
        self.name = name
        self.id = UUID()
        self.definitions = definitions
    }
    
    var debugDescription: String {
        "\(name) (\(definitions.count)"
    }
    
    static func withName(_ name: String, in context: ModelContext) -> WordType? {
        let fetchDescriptor = FetchDescriptor<WordType>(predicate: #Predicate { wordType in
            wordType.name == name
        })
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            return nil
        }
    }
    
    
}
