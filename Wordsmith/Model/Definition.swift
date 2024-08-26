//
//  Definition.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData

@Model
final class Definition: UUIDAble, WordsmithModel {
    
    static var defaultSortDescriptors = [SortDescriptor(\Definition.definition)]
    
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
    
    func add(_ image: SDImage) {
        images.append(image)
    }
    
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
    


    

    
}
