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
    
    @State var viewModel = ViewModel()
    
    @State var searchString: String = ""

    @State var restrictToRecents: Bool = false
    
    var body: some View {
        VStack {
            SearchableWordsList(searchString: searchString, restrictToRecents: restrictToRecents, group: group)
                .padding()
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.filterBarStroke)
                    .fill(.filterBarBackground)
                    .overlay {
                        HStack {
                            TextField("Search Words", text: $searchString, prompt: Text("Filter"))
                                .textFieldStyle(.plain)
                                .padding(.horizontal, 8)
                                .font(.caption)
                            Spacer()
                            HStack {
                                if !searchString.isEmpty {
                                    Button(action: {
                                        searchString = ""
                                    }) {
                                        Label("Clear", systemImage: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                            
                                    }
                                    .controlSize(.small)
                                }
                                Button(action: {
                                    restrictToRecents.toggle()
                                }) {
                                    Label("Recents", systemImage: restrictToRecents ? "clock.fill" : "clock")
                                        .foregroundStyle(restrictToRecents ? Color.accentColor : Color.secondary)
                                }
                            }
                            .padding(.trailing, 8)
                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .labelStyle(IconOnlyLabelStyle())
                    .frame(maxHeight: 24)
            }
            .padding(.horizontal, 7)
            .padding(.bottom, 6)
        }
        
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


extension DefinitionsPicker {
    
    @Observable
    class ViewModel {
        
        private(set) var expanded = Set<UUID>()
        
        func expand(_ word: Word) {
            expanded.insert(word.uuid)
        }
        
        func collapse(_ word: Word) {
            expanded.remove(word.uuid)
        }
        
        func isExpanded(_ word: Word) -> Bool {
            expanded.contains(word.uuid)
        }
        
        func toggle(_ word: Word) {
            if expanded.contains(word.uuid) {
                expanded.remove(word.uuid)
            } else {
                expanded.insert(word.uuid)
            }
        }
        
        func expandAll(in context: ModelContext) {
            Word.all(in: context).forEach { word in
                if !expanded.contains(word.uuid) {
                    expanded.insert(word.uuid)
                }
            }
        }
        
        func collapseAll() {
            expanded.removeAll()
        }
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
