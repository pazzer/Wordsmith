//
//  DefinitionSelector.swift
// Wordsmith
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
    
    @State var viewModel = DefinitionsPickerViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(words) { word in
                    VStack(alignment: .leading) {
                        HStack {
                            if word.isMember(of: group) {
                                SwiftUI.Image(systemName: "checkmark")
                            }
                            Text(word.word)
                                .font(.title3)
                            Spacer()
                            if !word.definitions.isEmpty {
                                Button("Expand/Collapse", systemImage: viewModel.isExpanded(word) ? "chevron.down" : "chevron.right") {
                                    viewModel.toggle(word)
                                }
                                .labelStyle(.iconOnly)
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            
                        }
                        if viewModel.isExpanded(word) {
                            VStack(alignment: .leading) {
                                ForEach(word.definitions) { definition in
                                    Toggle(isOn: binding(for: definition)) {
                                        Text(definition.definition)
                                    }
                                }
                            }
                            .padding([.leading, .bottom], 16)
                        }
                        
                    }
                }
            }
        }
        .padding()
    }

    
    private func isExpandedBinding(for word: Word) -> Binding<Bool> {
        return Binding(get: {
            return viewModel.isExpanded(word)
        }, set: { isExpanded in
            isExpanded ? viewModel.expand(word) : viewModel.collapse(word)
        })
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
        
        let architecture = Group.find("Architecture", in: container.mainContext, create: false)!
        
        return Preview(group: architecture)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
