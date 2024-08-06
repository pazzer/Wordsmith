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
    var word: Word!
    var groups: [Group] = []
    let id = UUID()
    var dateCreated: Date
    
    var source: Source?
    
    init(definition: String, source: Source? = nil, wordType: WordType? = nil) {
        self.definition = definition
        self.wordType = wordType
        self.source = source
        self.dateCreated = .now
        
    }
}
