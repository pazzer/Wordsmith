//
//  Image.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 07/08/2024.
//

import Foundation
import SwiftData
import AppKit.NSImage

@Model
class Image {
    
    var data: Data?
    var uuid = UUID()
    var dateCreated = Date()
    
    @Relationship(inverse: \Definition.definition)
    var definitions: [Definition] = []
    
    init(image: NSImage) {
        self.data = image.tiffRepresentation
        self.definitions = definitions
    }
    
    var image: NSImage? {
        get {
            if let data = self.data {
                return NSImage(data: data)
            } else {
                return nil
            }
        } set {
            self.data = newValue?.tiffRepresentation
        }
    }
    
    static func withUUID(_ uuid: UUID, in context: ModelContext) -> Image? {
        let fetchDescriptor = FetchDescriptor<Image>(predicate: #Predicate { image in
            image.uuid == uuid
        })
        
        do {
            let images = try context.fetch(fetchDescriptor)
            assert(images.count < 2)
            return images.first
        } catch {
            return nil
        }
    }
}

