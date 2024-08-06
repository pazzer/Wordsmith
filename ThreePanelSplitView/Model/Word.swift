//
//  Word.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import Foundation
import SwiftData

@Model
class Word: CustomDebugStringConvertible {
    
    enum ValidationError: LocalizedError {
        case isDuplicate
    }
    
    var word: String
    private(set) var created: Date
    let id = UUID()
    
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
    
    var debugDescription: String {
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
    
    static func withName(_ name: String, in modelContext: ModelContext, create: Bool = false) -> Word? {
        let fetchDescriptor = FetchDescriptor<Word>(predicate: #Predicate { word in
            word.word == name
        })
        
        do {
            let words = try modelContext.fetch(fetchDescriptor)
            if words.isEmpty && create {
                let word = Word(word: name)
                modelContext.insert(word)
                return word
            } else {
                return words.first
            }
        } catch {
            return nil
        }
        
    }
}
