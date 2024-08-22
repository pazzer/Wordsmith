//
//  LoadSampleData.swift
//  CrossWords
//
//  Created by Paul Patterson on 03/08/2024.
//

import SwiftData
import AppKit.NSImage

typealias SDImage = Wordsmith.Image

class SampleDataManager {
    
    private enum WordType: String, CaseIterable {
        case adjective
        case noun
        case adverb
        case verb
    }
    
    private enum ImageResource: String, CaseIterable {
        case arabesquePattern1 = "arabesque-pattern1"
        case arabesquePattern2 = "arabesque-pattern2"
        case arabesquePattern3 = "arabesque-pattern3"
        case arabesqueBallet = "arabesque-ballet"
        case mausoleum = "mausoleum"
    }
    
    private enum Group: CaseIterable {
        case theChristianChurch
        case architecture
        case theLaw
        
        var name: String {
            switch self {
            case .theChristianChurch:
                return "The Christian Church"
            case .architecture:
                return "Architecture"
            case .theLaw:
                return "The Law"
            }
        }
    }
    
    
    private enum DefinitionSource: CaseIterable {
        case oxfordLanguages
        case merriamWebster
        case cambridge
        case wikipedia
        case wiktionary
        case collins
        
        var name: String {
            switch self {
            case .oxfordLanguages:
                return "Oxford Languages"
            case .merriamWebster:
                return "Merriam Webster"
            case .cambridge:
                return "Cambridge"
            case .wikipedia:
                return "Wikipedia"
            case .wiktionary:
                return "Wiktionary"
            case .collins:
                return "Collins"
            }
        }
    }
    
    static func loadSampleData(into context: ModelContext) {
        Self.loadSources(into: context)
        Self.loadWordTypes(into: context)
        Self.loadGroups(into: context)
        Self.loadWordsAndDefinitions(into: context)
    }

    private static func loadWordTypes(into context: ModelContext) {
        WordType.allCases.forEach {
            context.insert( Wordsmith.WordType(name: $0.rawValue ))
        }
    }
    
    private static func loadSources(into context: ModelContext) {
        DefinitionSource.allCases.forEach {
            context.insert( Source(name: $0.name) )
        }
    }
    
    private static func loadGroups(into context: ModelContext) {
        Group.allCases.forEach {
            context.insert( Wordsmith.Group(name: $0.name) )
        }
    }

    private static func loadWordsAndDefinitions(into context: ModelContext) {
        
        var imagesMap = [ImageResource : UUID]()
        
        Self.wordsAndDefinitions.forEach { (word, definitions)  in
            let word = Word(word: word)
            context.insert(word)
            
            definitions.forEach { (text, wordType, source, groups, images) in
                
                let definition = Definition(definition: text)
                context.insert(definition)
                
                if let name = wordType?.rawValue {
                   definition.wordType = Wordsmith.WordType.withName(name, in: context)
                } else {
                    definition.wordType = nil
                }
                
                if let name = source?.name,
                   let source = Source.withName(name, in: context) {
                    definition.source = source
                }
                
                groups
                    .compactMap {  Wordsmith.Group.withName($0.name, in: context) }
                    .forEach { definition.groups.append($0) }
                
                images
                    .forEach { imageResource in
                        if let uuid = imagesMap[imageResource] {
                            if let image = Image.withUUID(uuid, in: context) {
                                definition.images.append(image)
                            } else {
                                NSLog("failed to fetch image with id \(uuid.uuidString)")
                            }
                        } else {
                            let nsImage = NSImage(imageLiteralResourceName: imageResource.rawValue)
                            let image = Image(image: nsImage)
                            context.insert(image)
                            definition.images.append(image)
                            imagesMap[imageResource] = image.uuid
                        }
                    }
                
                word.definitions.append(definition)
            }
        }
    }
    

    
    private static var wordsAndDefinitions: [String: [(String, WordType?, DefinitionSource?, [Group], [ImageResource])]] {
         [
            "sepulchre":
                [(
                    "a small room or monument, cut in rock or built of stone, in which a dead person is laid or buried.",
                    .noun,
                    DefinitionSource.oxfordLanguages,
                    [.theChristianChurch, .architecture],
                    []
                )],
            
            "mausoleum":
                [(
                    "a stately or impressive building housing a tomb or group of tombs.",
                    .noun,
                    DefinitionSource.cambridge,
                    [.theChristianChurch],
                    [.mausoleum]
                )],
            
            "loop-hole":
                [(
                    "a small opening through which small arms may be fired.",
                    .noun,
                    .merriamWebster,
                    [.architecture],
                    []
                ),
                 (
                    "a small mistake in an agreement or law that gives someone the chance to avoid having to do something.",
                    .noun,
                    .cambridge,
                    [.theLaw],
                    []
                 )],
            
            "parapet":
                [(
                    "a low protective wall along the edge of a roof, bridge, or balcony.",
                    .noun,
                    .oxfordLanguages,
                    [.architecture],
                    []
                )],
            
            "retaining wall":
                [(
                    "a wall designed to hold in place a mass of earth or the like, such as the edge of a terrace or excavation.",
                    nil,
                    .wikipedia,
                    [.architecture],
                    []
                )],
            
            "stertor":
                [(
                    "laborious or noisy breathing caused by obstructed air passages",
                    .noun,
                    .collins,
                    [],
                    []
                )],
            
            "arabesque":
                [(
                    "an ornate composition, especially for the piano.",
                    .noun,
                    .wiktionary,
                    [],
                    []
                ),
                 (
                    "a ballet position in which the dancer stands on one leg, with the other raised backwards and the arms outstretched.",
                    .noun,
                    .wiktionary,
                    [],
                    [.arabesqueBallet]
                 ),
                 (
                    "an elaborate design of intertwined floral figures or complex geometrical patterns, mainly used in Islamic art and architechture.",
                    .noun,
                    .wiktionary,
                    [],
                    [.arabesquePattern1, .arabesquePattern2, .arabesquePattern3]
                 )
                ],
            
            "usurp":
                [(
                    "take (a position of power or importance) illegally or by force.",
                    .verb,
                    .oxfordLanguages,
                    [],
                    []
                )],
            
            "collier": []
            ]
    }
    
    
    
    
    
}


