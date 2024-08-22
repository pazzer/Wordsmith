//
//  Word.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData


protocol StringIdentifiable: PersistentModel {
    static func find(_ string: String, in modelContext: ModelContext, create: Bool) -> Self?
    static func fetch(from string: String, in modelContext: ModelContext) -> Self?
    static func create(from string: String, in modelContext: ModelContext) -> Self
    static var stringIdentifiableKeyPath: KeyPath<Self, String> { get }
}


@Model
final public class Word: CustomDebugStringConvertible, StringIdentifiable {
    
    
    enum ValidationError: LocalizedError {
        case isDuplicate
    }
    
    var word: String
    private(set) var created: Date
    let uuid = UUID()
    
    @Relationship(deleteRule: .cascade)
    var definitions: [Definition]
    
    init(word: String) {
        self.word = word
        self.definitions = []
        self.created = Date.now
    }
    
    func isMember(of group: Group) -> Bool {
        definitions.filter {$0.groups.contains(group)}.count > 0
    }
    
    func join(_ group: Group) {
        definitions.forEach { definition in
            group.definitions.append(definition)
        }
    }
    
    func unjoin(_ group: Group) {
        group.definitions.removeAll { definition in
            return definition.word === self
        }
    }
    
    static func insert(_ string: String, into modelContext: ModelContext) throws {
        if Self.canInsert(string, into: modelContext) {
            let word = Word(word: string)
            modelContext.insert(word)
        } else {
            throw ValidationError.isDuplicate
        }
    }
    
    static func canInsert(_ string: String, into modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<Word>(predicate: #Predicate { $0.word == string })
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        return count == 0
    }
    
    public var debugDescription: String {
        let definitions = definitions.map { definition in
            definition.definition.prefix(12)
        }.joined(separator: "; ")
        return "\(word): \(definitions)"
    }
    
    static func lastCreatedWord(in context: ModelContext) -> Word? {
        context.insertedModelsArray
            .compactMap { $0 as? Word }
            .sorted(by: {$0.created > $1.created})
            .first
    }
    
    
    

}

/// StringIdentifiable conformace
/// When predicates support key-paths this can become an extension on PersistentModel.
extension Word {
    
    static var stringIdentifiableKeyPath: KeyPath<Word, String> {
        \Word.word
    }
    
    static func find(_ string: String, in modelContext: ModelContext, create: Bool = false) -> Word? {
        if let word = Word.fetch(from: string, in: modelContext) {
            return word
        } else if create {
            let word = Word(word: string)
            modelContext.insert(word)
            return word
        } else {
            return nil
        }
    }
    
    static func fetch(from string: String, in modelContext: ModelContext) -> Word? {
        let fetchDescriptor = FetchDescriptor<Self>(predicate: #Predicate { word in
            word.word == string
        })
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            precondition(results.count < 2)
            return results.first
        } catch {
            preconditionFailure()
        }
    }
    
    static func create(from string: String, in modelContext: ModelContext) -> Word {
        guard Self.fetch(from: string, in: modelContext) == nil else {
            preconditionFailure("'\(string)' already exists.")
        }
        let word = Word(word: string)
        modelContext.insert(word)
        return word
        
    }

    
}






