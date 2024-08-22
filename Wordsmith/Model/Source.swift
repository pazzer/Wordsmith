//
//  Source.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData



@Model
final class Source: StringIdentifiable {
    
    
    var name: String
    
    @Relationship(inverse: \Definition.source)
    var definitions: [Definition] = []
    
    let uuid = UUID()
    
    init(name: String) {
        self.name = name
    }
}

/// StringIdentifiable conformace
/// When predicates support key-paths this can become an extension on PersistentModel.
extension Source {
    
    static func find(_ string: String, in modelContext: ModelContext, create: Bool = false) -> Source? {
        if let source = Source.fetch(from: string, in: modelContext) {
            return source
        } else if create {
            let source = Source(name: string)
            modelContext.insert(source)
            return source
        } else {
            return nil
        }
    }
    
    static func fetch(from string: String, in modelContext: ModelContext) -> Source? {
        let fetchDescriptor = FetchDescriptor<Source>(predicate: #Predicate { source in
            source.name == string
        })
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            precondition(results.count < 2)
            return results.first
        } catch {
            preconditionFailure()
        }
    }
    
    static func create(from string: String, in modelContext: ModelContext) -> Source {
        guard Self.fetch(from: string, in: modelContext) == nil else {
            preconditionFailure("'\(string)' already exists.")
        }
        let word = Source(name: string)
        modelContext.insert(word)
        return word
    }
    
    static var stringIdentifiableKeyPath: KeyPath<Source, String> {
        \Source.name
    }

    
}
