//
//  GroupDetailRow.swift
//  Wordsmith
//
//  Created by Paul Patterson on 30/08/2024.
//

import SwiftData
import SwiftUI

struct GroupItem: View {

    @Environment(\.modelContext) private var context
    
    @Bindable var definition: Definition
    
    @State var imageDropPossible: Bool = false
    
    var body: some View {
        HStack {
            image(for: definition)
                .frame(width: 128, height: 128)
            VStack(alignment: .leading) {
                Text(definition.word.word)
                    .font(.body.bold())
                Text(definition.definition)
            }
        }
    }
    
    @ViewBuilder func image(for definition: Definition) -> some View {
        if let image = definition.images.first?.image {
            SwiftUI.Image(nsImage: image)
                .resizable()
                .scaledToFit()
        } else {
            Color.white
                .overlay {
                    SwiftUI.Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundStyle(imageDropPossible ? Color.accentColor : .secondary)
                        
                }
                .border(imageDropPossible ? Color.accentColor : .clear)
                .padding()
                .dropDestination(for: Data.self) { items, location in
                    if let data = items.first, let image = NSImage(data: data) {
                        addImage(image, to: definition)
                    }
                    return false
                } isTargeted: { imageDropPossible = $0 }
        }
        
    }
    
    #if os(macOS)
    func addImage(_ nsImage: NSImage, to definition: Definition) {
        let image = SDImage(image: nsImage)
        withAnimation {
            context.insert(image)
            definition.add(image)
            
        }
    }
    #endif
}


