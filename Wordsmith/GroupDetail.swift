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
    
    var body: some View {
        VStack {
            TitleView(title: $group.name)
            List(sortedDefinitions, id: \.uuid) { definition in
                GroupItem(definition: definition)

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
