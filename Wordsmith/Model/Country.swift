//
//  Country.swift
//  Wordsmith
//
//  Created by Paul Patterson on 03/09/2024.
//

import Foundation
import SwiftData
import os

@Model
final class Country: UUIDAble, WordsmithModel {
    
    static var defaultSortDescriptors = [SortDescriptor(\Country.name)]
    
    var name: String
    var abbreviation: String
    var flag: String
    
    @Relationship
    var definitions: [Definition] = []
    
    let uuid = UUID()
    
    init(name: String, abbreviation: String, flag: String) {
        self.name = name
        self.abbreviation = abbreviation
        self.flag = flag
    }
    
    
}

extension Country {
    
    
    private static func fetch(_ name: String, in modelContext: ModelContext) -> Country? {
        let fetchDescriptor = FetchDescriptor<Country>(predicate: #Predicate { country in
            country.name == name
        })
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            precondition(results.count < 2)
            return results.first
        } catch {
            preconditionFailure()
        }
    }
    
    
    static func installPresets(in context: ModelContext) {
        
        let presetData = [
            ("Australia", "aus", "🇦🇺"),
            ("Canada", "can", "🇨🇦"),
            ("Scotland", "sco", "🏴󠁧󠁢󠁳󠁣󠁴󠁿"),
            ("New Zealand", "nz", "🇳🇿"),
            ("U.S.A", "us", "🇺🇸"),
            ("England", "eng", "🏴󠁧󠁢󠁥󠁮󠁧󠁿"),
            ("Ireland", "ire", "🇮🇪")]
        
        presetData.forEach { (name, abbr, flag) in
            if Country.fetch(name, in: context) == nil {
                let country = Country(name: name, abbreviation: abbr, flag: flag)
                context.insert(country)
                Logger.database.info("inserted '\(name)'")
            }
            
            
        }
    }
}



