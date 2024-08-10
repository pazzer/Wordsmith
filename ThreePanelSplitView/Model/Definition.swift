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
    
    var combinedMetedata: String {
        let source = source?.name ?? "anon"
        let type = wordType?.name ?? "type unknown"
        return [source, type].joined(separator: ", ")
    }
}
