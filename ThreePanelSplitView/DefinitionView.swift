//
//  DefinitionView.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 09/08/2024.
//

import SwiftUI
import SwiftData



struct DefinitionView: View {
    
    @Bindable var definition: Definition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WordBanner(word: definition.word)
            TextField("Definition", text: $definition.definition, axis: .vertical)
                .font(.title3)
                .textFieldStyle(.plain)
                .padding()
            ScrollView {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach($definition.images, id: \.uuid) { $image in
                        SwiftUI.Image(nsImage: image.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 148, height: 148)
                    }
                }
            }
            . contentMargins(.horizontal, 20.0, for: .scrollContent)
        }
            .inspector(isPresented: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Color.cyan
                    .inspectorColumnWidth(min: 220, ideal: 220, max: 275)
                   
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
