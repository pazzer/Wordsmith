//
//  WordDetail.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct WordDetail: View {
    
    @Binding var word: Word
    @Binding var selectedDefinition: Definition?
    
    var sortedDefinitions: [Definition] {
        word.definitions.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField("Word", text: $word.word)
                    .textFieldStyle(.plain)
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            .background(.white)
            
            NavigationStack {
                List(selection: $selectedDefinition) {
                    ForEach($word.definitions, id: \.uuid) { $definition in
                        NavigationLink {
                            Text("XYZ")
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(definition.definition)
                                        .font(.title3)
                            
                                    Text(definition.combinedMetedata)
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
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
                    }
                }
                .scrollContentBackground(.hidden)
                
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .frame(height: 1)
                        .foregroundStyle(.quinary)
                    HStack {
                        Button(action: {
    //                        newWordSheetPresented.toggle()
                            
                        }, label: {
                            Label("Add Definition", systemImage: "plus")
                        })
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                        .buttonStyle(.plain)
                        Spacer()
                            
                    }
                }
//                .background(.quinary)
            }
        }
    }
}


#Preview("WordDetail") {
    
    struct Preview: View {
        
        @State var word: Word
        
        var body: some View {
            WordDetail(word: $word, selectedDefinition: .constant(nil))
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        
        return Preview(word: Word.withName("arabesque", in: container.mainContext)!)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
