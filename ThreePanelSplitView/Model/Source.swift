//
//  Source.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData



@Model
class Source {
    
    var name: String
    var definitions: [Definition] = []
    let id = UUID()
    
    init(name: String) {
        self.name = name
    }
    
    static func withName(_ name: String, in modelContext: ModelContext, create: Bool = false) -> Source? {
        let fetchDescriptor = FetchDescriptor<Source>(predicate: #Predicate { source in
            source.name == name
        })
        
        do {
            let sources = try modelContext.fetch(fetchDescriptor)
            if sources.isEmpty && create {
                let source = Source(name: name)
                modelContext.insert(source)
                return source
            } else {
                return sources.first
            }
        } catch {
            return nil
        }
        
    }
    
    
}
