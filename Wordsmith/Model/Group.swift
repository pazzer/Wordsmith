//
//  Group.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
final public class Group: UUIDAble, StringCreatable, StringFetchable {
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
    
    static func withName(_ name: String, in modelContext: ModelContext, create: Bool = false) -> Group? {
        let fetchDescriptor = FetchDescriptor<Group>(predicate: #Predicate { source in
            source.name == name
        })
        
        do {
            let sources = try modelContext.fetch(fetchDescriptor)
            if sources.isEmpty && create {
                let group = Group(name: name)
                modelContext.insert(group)
                return group
            } else {
                return sources.first
            }
        } catch {
            return nil
        }
        
    }
    
    
    static func create(from string: String, in modelContext: ModelContext) -> Group? {
        let fetchDescriptor = FetchDescriptor<Group>(predicate: #Predicate { group in
            group.name == string
        })
        
        do {
            let groups = try modelContext.fetch(fetchDescriptor)
            precondition(groups.isEmpty)
            let group = Group(name: string)
            modelContext.insert(group)
            return group
        } catch {
            return nil
        }
    }
    
    static func fetch(from string: String, in modelContext: ModelContext) -> Group? {
        let fetchDescriptor = FetchDescriptor<Group>(predicate: #Predicate { group in
            group.name == string
        })
        
        return try? modelContext.fetch(fetchDescriptor).first
    }
}

