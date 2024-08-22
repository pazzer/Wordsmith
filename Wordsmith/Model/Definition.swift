//
//  Definition.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData

@Model
class Definition {
    
    var definition: String
    var wordType: WordType?
    
    @Relationship(inverse: \Word.definitions)
    var word: Word!
    
    var groups: [Group] = []
    
    @Relationship(inverse: \Image.definitions)
    var images: [SDImage] = []
    
    let uuid = UUID()
    var dateCreated: Date
    
    var source: Source?
    
    init(definition: String, source: Source? = nil, wordType: WordType? = nil) {
        self.definition = definition
        self.wordType = wordType
        self.source = source
        self.dateCreated = .now
    }
    
    var combinedMetedata: String? {
        var components = [String]()
        
        if let source = source?.name {
            components.append(source)
        }
        
        if let type = wordType?.name {
            components.append(type)
        }
        
        let metadata = components.joined(separator: ", ")
        
        return metadata.isEmpty ? nil : metadata
    }
    
    func isMember(of group: Group) -> Bool {
        groups.first(where: { $0.uuid == group.uuid }) != nil
    }
    
    static func all(in context: ModelContext) -> [Definition] {
        let fetchDescriptor = FetchDescriptor<Definition>()
        do {
            let results = try context.fetch(fetchDescriptor)
            return results
        } catch {
            return []
        }
    }
    

    
    static func withUUID(_ uuid: UUID, context: ModelContext) -> Definition {
        let fetchDescriptor = FetchDescriptor<Definition>(predicate: #Predicate { definition in
            definition.uuid == uuid
        })
        
        guard let definition = try? context.fetch(fetchDescriptor).first else {
            preconditionFailure()
        }
        return definition 
    }
    
}
