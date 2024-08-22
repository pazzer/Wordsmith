//
//  Image.swift
// Wordsmith
//
//  Created by Paul Patterson on 07/08/2024.
//

import Foundation
import SwiftData

#if os(macOS)
import AppKit.NSImage
#else
import UIKit.UIImage
#endif

@Model
final class Image: UUIDAble {
    
    var data: Data? = nil
    var uuid = UUID()
    var dateCreated = Date()
    
    @Relationship(inverse: \Definition.definition)
    var definitions: [Definition] = []
    
    #if os(macOS)
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
    #else
    init(image: UIImage) {
        self.data = image.jpegData(compressionQuality: 1.0)
        self.definitions = definitions
    }
    
    
    var image: UIImage? {
        get {
            if let data = self.data {
                return UIImage(data: data)
            } else {
                return nil
            }
        } set {
            self.data = newValue?.jpegData(compressionQuality: 1.0)
        }
    }
    #endif
    
    
    /// To satisfy compiler.
    init() {
        self.data = nil
    }
    
    
    
    
    
}

