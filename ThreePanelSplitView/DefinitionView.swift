//
//  DefinitionView.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 09/08/2024.
//

import SwiftUI
import SwiftData



struct DefinitionView: View {
    
    @Environment(\.modelContext) private var context
    
    @Bindable var definition: Definition
    
    private var columns: [GridItem] {
        
        [ GridItem(.adaptive(minimum: 148, maximum: 148), spacing: 16) ]
    }
    
    @State var imageDropPossible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WordBanner(word: definition.word)
            TextField("Definition", text: $definition.definition, axis: .vertical)
                .font(.title3)
                .textFieldStyle(.plain)
                .padding()
            
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                ForEach($definition.images, id: \.uuid) { $image in
                    if let nsImage = image.image {
                        SwiftUI.Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 148, height: 148)
                    }
                }
                RoundedRectangle(cornerRadius: 20)
                    .fill(imageDropPossible ? Color.green : Color(white: 0.85))
                    .overlay {
                        SwiftUI.Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                    }
                    .frame(width: 148, height: 148)
                    .dropDestination(for: Data.self) { items, location in
                        if let data = items.first, let image = NSImage(data: data) {
                            addImage(image)
                        }
                        return false
                    } isTargeted: { imageDropPossible = $0 }

                    
            }
            .padding()
            . contentMargins(.horizontal, 20.0, for: .scrollContent)
            Spacer()
            
        }
//            .inspector(isPresented: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/) {
//                Color.cyan
//                    .inspectorColumnWidth(min: 220, ideal: 220, max: 275)
//                   
//            }
            
    }
    
    func addImage(_ nsImage: NSImage) {
        let image = SDImage(image: nsImage)
        withAnimation {
            context.insert(image)
            definition.images.append(image)
        }
        
    }
    
    
}


#Preview {
    
    struct Preview: View {
        
        @State var definition: Definition
        
        var body: some View {
            DefinitionView(definition: definition)
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        let word = Word.withName("arabesque", in: container.mainContext)!
        let definition = word.definitions.first(where: { $0.definition.contains("intertwined") } )
        
        return Preview(definition: definition!)
            .modelContainer(container)
            
            
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
