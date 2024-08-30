//
//  SearchableWordsList.swift
//  Wordsmith
//
//  Created by Paul Patterson on 30/08/2024.
//

import SwiftData
import SwiftUI


struct SearchableWordsList: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Word.word, order: .forward)
    var words: [Word]
    
    @Bindable var group: Group
    
    @State var viewModel = ViewModel()
    
    init(searchString: String, restrictToRecents: Bool, group: Group) {
        let cutoff = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -3, to: .now)!
        _words = Query(filter: #Predicate {
            if restrictToRecents {
                if searchString.isEmpty {
                    return $0.created >= cutoff
                } else {
                    return $0.created >= cutoff && $0.word.contains(searchString)
                }
            } else {
                return searchString.isEmpty ? true : $0.word.contains(searchString)
            }
        }, sort: Word.defaultSortDescriptors)
        self.group = group
        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(words) { word in
                    VStack(alignment: .leading) {
                        HStack {
                            if word.isMember(of: group) {
                                Button(action: {
                                    removeAllDefinitions(word)
                                }, label: {
                                    Label("", systemImage: "checkmark.circle.fill")
                                })
                                .labelStyle(.iconOnly)
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                Button(action: {
                                    addAllDefinitions(word)
                                }, label: {
                                    Label("", systemImage: "circle")
                                })
                                .labelStyle(.iconOnly)
                                .buttonStyle(PlainButtonStyle())
                            }
                            Text(word.word)
                                .font(.system(size: 14))
                            Spacer()
                            if !word.definitionIsPlaceholder {
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
    }
    
    func addAllDefinitions(_ word: Word) {
        word.definitions.forEach { definition in
            group.add(definition)
        }
    }
    
    func removeAllDefinitions(_ word: Word) {
        word.definitions.forEach { definition in
            group.remove(definition)
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


extension SearchableWordsList {
    
    
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
