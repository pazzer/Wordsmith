//
//  Word.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData
import os

protocol StringIdentifiable: PersistentModel {
    static func find(_ string: String, in modelContext: ModelContext, create: Bool) -> Self?
    static func fetch(from string: String, in modelContext: ModelContext) -> Self?
    static func create(from string: String, in modelContext: ModelContext) -> Self
    static var stringIdentifiableKeyPath: KeyPath<Self, String> { get }
}

protocol UUIDAble {
    var uuid: UUID { get }
}


@Model
final public class Word: CustomDebugStringConvertible, StringIdentifiable, UUIDAble, WordsmithModel {
    
    enum ValidationError: LocalizedError {
        case isDuplicate
    }
    
    static var defaultSortDescriptors = [SortDescriptor(\Word.word)]
    
    var word: String
    let uuid = UUID()
    private(set) var created: Date
    
    @Relationship(deleteRule: .cascade)
    private(set) var definitions: [Definition]
    
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
    

    var definitionIsPlaceholder: Bool {
        definitions.count == 1 && definitions.first?.isPlaceholder == true
    }
    
    func delete(_ definition: Definition, in context: ModelContext) {
        definitions.removeAll(where: {$0.uuid == uuid})
        context.delete(definition)
        
        if definitions.isEmpty {
            Logger.database.info("removed last definition from '\(self.word)")
            insertPlaceholderDefinition()
        } else {
            Logger.database.info("removed definition from '\(self.word)")
        }
    }
    
    func insertDefinition(text: String? = nil) -> Definition {
        if definitionIsPlaceholder {
            removePlaceholderDefinition()
        }
        
        let definition = Definition(definition: text ?? "\(self.word) means...")
        modelContext?.insert(definition)
        definitions.append(definition)
        Logger.database.debug("added new definition to '\(self.word)'")
        return definition
    }
    
    func insertPlaceholderDefinition() {
        precondition(definitions.isEmpty)
        let definition = Definition.placeholderDefinition()
        modelContext?.insert(definition)
        definitions.append(definition)
        Logger.database.info("added placeholder definition to '\(self.word)'.")
    }
    
    func removePlaceholderDefinition() {
        precondition(definitions.count == 1 && definitions.first?.isPlaceholder == true)
        let definition = definitions.removeFirst()
        modelContext?.delete(definition)
        Logger.database.info("deleted placeholder definition belonging to '\(self.word)'")
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
        let fetchDescriptor = FetchDescriptor<Word>(predicate: #Predicate { word in
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

    static func new(word: String, in context: ModelContext) -> Word {
        let word = Word(word: word)
        context.insert(word)
        Logger.database.info("inserted word '\(word.word)'")
        word.insertPlaceholderDefinition()
        return word
    }
    
    static func alreadyExists(string: String, in context: ModelContext) -> Bool {
        Word.all(in: context).first { $0.word.lowercased() == string.lowercased() } != nil
    }
    
    
    
}






