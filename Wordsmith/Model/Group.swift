//
//  Group.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
final public class Group: UUIDAble, StringIdentifiable {
    
    var name: String
    var summary: String?
    let uuid = UUID()
    
    @Relationship(deleteRule: .nullify, inverse: \Definition.groups)
    var definitions: [Definition] = []
    
    
    
    init(name: String, summary: String? = nil) {
        self.name = name
        self.summary = summary
    }
    
    var wordCount: Int {
        Set(definitions.compactMap({$0.word?.word})).count
    }
    
    func remove(_ definition: Definition) {
        definitions.removeAll { $0.uuid == definition.uuid }
    }
    
    func add(_ definition: Definition) {
        guard !definition.isMember(of: self) else { return }
        definitions.append(definition)
    }
    
        
}

/// StringIdentifiable conformace
/// When predicates support key-paths this can become an extension on PersistentModel.
extension Group {
    
    static func find(_ string: String, in modelContext: ModelContext, create: Bool = false) -> Group? {
        if let group = Group.fetch(from: string, in: modelContext) {
            return group
        } else if create {
            let group = Group(name: string)
            modelContext.insert(group)
            return group
        } else {
            return nil
        }
    }
    
    static func fetch(from string: String, in modelContext: ModelContext) -> Group? {
        let fetchDescriptor = FetchDescriptor<Group>(predicate: #Predicate { group in
            group.name == string
        })
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            precondition(results.count < 2)
            return results.first
        } catch {
            preconditionFailure()
        }
    }
    
    static func create(from string: String, in modelContext: ModelContext) -> Group {
        guard Self.fetch(from: string, in: modelContext) == nil else {
            preconditionFailure("'\(string)' already exists.")
        }
        let word = Group(name: string)
        modelContext.insert(word)
        return word
    }
    
    static var stringIdentifiableKeyPath: KeyPath<Group, String> {
        \Group.name
    }

}

