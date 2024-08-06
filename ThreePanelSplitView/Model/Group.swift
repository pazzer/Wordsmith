//
//  Group.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Group {
    var name: String
    var summary: String?
    let id = UUID()
    
    @Relationship(deleteRule: .nullify, inverse: \Definition.groups)
    var definitions: [Definition] = []
    
    init(name: String, summary: String? = nil) {
        self.name = name
        self.summary = summary
    }
    
    var wordCount: Int {
        Set(definitions.compactMap({$0.word?.word})).count
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
}

