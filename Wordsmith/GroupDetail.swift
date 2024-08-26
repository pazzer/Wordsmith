//
//  GroupView.swift
// Wordsmith
//
//  Created by Paul Patterson on 21/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct GroupDetail: View {
    
    @Environment(\.modelContext) private var context
    
    @Bindable var group: Group
    
    @State var presented = true
    
    var sortedDefinitions: [Definition] {
        group.definitions.sorted { $0.word.word < $1.word.word }
    }
    
    
    @State var imageDropPossible: Bool = false
    
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
    
    var body: some View {
        VStack {
            TitleView(title: $group.name)
            List(sortedDefinitions, id: \.uuid) { definition in
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
            .scrollContentBackground(.hidden)
        }
        .inspector(isPresented: $presented) {
            DefinitionsPicker(group: group)
                .inspectorColumnWidth(min: 200, ideal: 325, max: 400)
        }
        
    }
}





#Preview {
    
    struct Preview: View {
        
        @State var group: Group
        
        var body: some View {
            GroupDetail(group: group)
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        let group = Group.find("The Christian Church", in: container.mainContext)!
        
        return Preview(group: group)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
