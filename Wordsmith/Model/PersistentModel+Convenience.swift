//
//  PersistentModel+Convenience.swift
//  Wordsmith
//
//  Created by Paul Patterson on 22/08/2024.
//

import Foundation
import SwiftData

extension PersistentModel {
    
    static func all(in context: ModelContext) -> [Self] {
        let fetchDescriptor = FetchDescriptor<Self>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            return []
        }
    }
    
    static func withUUID(_ uuid: UUID, in context: ModelContext) -> Self where Self: UUIDAble {
        let fetchDescriptor = FetchDescriptor<Self>(predicate: #Predicate { item in
            item.uuid == uuid
        })
        
        guard let modelObject = try? context.fetch(fetchDescriptor).first else {
            preconditionFailure("no instance of type \(type(of: Self.self)) has requested UUID.")
        }
        
        return modelObject
    }
    
}
