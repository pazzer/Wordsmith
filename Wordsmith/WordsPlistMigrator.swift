//
//  WordsPlistMigrator.swift
//  Wordsmith
//
//  Created by Paul Patterson on 25/08/2024.
//

import Foundation
import SwiftData

//enum Location {
//    case resource(_ filename: String, extension: String)
//}
//
//func migrateWords(at location: Location, into modelContext: ModelContext) {
//    
//
//    let _words: [_Word] = plistLoader(location: location) ?? []
//    NSLog("preparing to migrate \(_words.count) words.")
//    
//    _words.forEach { _word in
//        let word = Word(word: _word.word)
//        modelContext.insert(word)
//        
//        _word.definitions.forEach { _definition in
//            
//            // Source/Dictionary
//            var source: Source? = nil
//            if let name = _definition.source {
//                source = Source.find(name, in: modelContext, create: true)
//            }
//            
//            let definition = Definition(definition: _definition.definition)
//            modelContext.insert(definition)
//            
//            definition.wordType = WordType.withName(_definition.classification.rawValue.lowercased(), in: modelContext)
//            
//            if let name = source?.name {
//                definition.source = Source.find(name, in: modelContext)
//            }
//            
//            word.definitions.append(definition)
//        }
//    }
//}
//
//func plistLoader<T: Decodable>(location: Location) -> T? {
//    guard case .resource(let filename, let `extension`) = location else { return nil }
//    
//    guard let url = Bundle.main.url(forResource: filename, withExtension: `extension`) else {
//        NSLog("failed to create url.")
//        return nil
//    }
//    
//    let data: Data
//    do {
//        data = try Data(contentsOf: url)
//    } catch {
//        NSLog("failed to extract contents of url.")
//        return nil
//    }
//    
//    do {
//        return try PropertyListDecoder().decode(T.self, from: data)
//    } catch {
//        NSLog("failed to decode data object.")
//        return nil
//    }
//}
//
//class _Word: ObservableObject, Codable {
//    
//    @Published var focused = false
//    @Published var word: String
//    @Published var definitions: [_Definition]
//    
//    enum CodingKeys: CodingKey {
//        case focused, word, definitions
//    }
//    
//    init(_ word: String, definitions: [_Definition] = [], focused: Bool = false) {
//        self.word = word
//        self.definitions = definitions
//        self.focused = focused
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.word = try container.decode(String.self, forKey: .word)
//        self.focused = try container.decode(Bool.self, forKey: .focused)
//        self.definitions = try container.decodeIfPresent([_Definition].self, forKey: .definitions) ?? []
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(focused, forKey: .focused)
//        try container.encode(word, forKey: .word)
//        try container.encode(definitions, forKey: .definitions)
//    }
//}
//
//class _Definition: Codable, Identifiable, ObservableObject {
//    
//    private(set) var id: UUID
//    @Published var definition: String
//    @Published var source: String?
//    @Published var classification: _WordType
//    @Published var approximation: Bool
//    
//    init(definition: String, source: String, classification: _WordType, approximation: Bool) {
//        self.definition = definition
//        self.source = source
//        self.classification = classification
//        self.approximation = approximation
//        self.id = UUID()
//    }
//    
//    enum CodingKeys: CodingKey {
//        case id, definition, source, classification, approximation
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            self.id = try container.decode(UUID.self, forKey: .id)
//        } catch {
//            self.id = UUID()
//        }
//        
//        self.definition = try container.decode(String.self, forKey: .definition)
//        self.source = try container.decodeIfPresent(String.self, forKey: .source)
//        
//        self.classification = try container.decode(_WordType.self, forKey: .classification)
//        self.approximation = try container.decode(Bool.self, forKey: .approximation)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(id, forKey: .id)
//        try container.encode(definition, forKey: .definition)
//        try container.encode(source, forKey: .source)
//        try container.encode(classification, forKey: .classification)
//        try container.encode(approximation, forKey: .approximation)
//    }
//}
//
//
//enum _WordType: String, Equatable, Codable, CaseIterable {
//    
//    case noun
//    case adverb
//    case adjective
//    case verb
//    case unknown
//    
//    var isSet: Bool {
//        if case .unknown = self {
//            return false
//        } else {
//            return true
//        }
//    }
//    
//}
