//
//  DefinitionSelector.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 21/08/2024.
//

import SwiftUI
import SwiftData

struct DefinitionsPicker: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Word.word, order: .forward)
    var words: [Word]
    
    @Bindable var group: Group
    
    var body: some View {
        List {
            ForEach(words) { word in
                Section(word.word) {
                    ForEach(word.definitions) { definition in
                        Toggle(isOn: binding(for: definition)) {
                            Text(definition.definition)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func binding(for definition: Definition) -> Binding<Bool> {
        return Binding(get: {
            return definition.isMember(of: group)
        }, set: { isOn in
            isOn ? group.add(definition) : group.remove(definition)
        })
    }
}



#Preview {
    
    struct Preview: View {
        
        @State var group: Group
        
        var body: some View {
            DefinitionsPicker(group: group)
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        
        let architecture = Group.withName("Architecture", in: container.mainContext)!
        
        
        return Preview(group: architecture)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
