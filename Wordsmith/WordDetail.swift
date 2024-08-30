//
//  WordDetail.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct WordDetail: View {
    
    @Bindable var word: Word
    @Binding var selectedDefinition: Definition?
    @Environment(\.modelContext) private var context
    
    @Query
    var definitions: [Definition]
    
    init(word: Word, selectedDefinition: Binding<Definition?>) {
        self.word = word
        let targetUUID = word.uuid
        self._definitions = Query(filter: #Predicate {
            if $0.word?.uuid == targetUUID && !$0.isPlaceholder {
                return true
            } else {
                return false
            }
        }, sort: \.dateCreated)
        self._selectedDefinition = selectedDefinition
    }
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            WordBanner(word: word)
            
            NavigationStack {
                List(selection: $selectedDefinition) {
                    ForEach(definitions, id: \.uuid) { definition in
                        NavigationLink {
                            DefinitionView(definition: definition)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(definition.definition)
                                        .font(.title3)
                                    
                                    if let metadata = definition.combinedMetedata {
                                        Text(metadata)
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                Spacer()
                                
                                if !definition.images.isEmpty {
                                    SwiftUI.Image(systemName: "photo")
                                }
                                

                                SwiftUI.Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                                
                                
                            }
                            .padding(.bottom, 4)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                word.delete(definition, in: context)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .frame(height: 1)
                        .foregroundStyle(.quinary)
                    HStack {
                        Button(action: {
                            DispatchQueue.main.async {
                                withAnimation {
                                    let _ = word.insertDefinition()
                                }
                            }
                        }, label: {
                            Label("Add Definition", systemImage: "plus")
                        })
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                        .buttonStyle(.plain)
                        Spacer()
                            
                    }
                }
            }
        }
    }
    
}


#Preview("WordDetail") {
    
    struct Preview: View {
        
        @State var word: Word
        
        var body: some View {
            WordDetail(word: word, selectedDefinition: .constant(nil))
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        
        return Preview(word: Word.find("arabesque", in: container.mainContext)!)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
