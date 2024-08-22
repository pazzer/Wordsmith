//
//  GroupView.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 21/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct GroupDetail: View {
    
    @Bindable var group: Group
    
    @Environment(\.modelContext) private var context
    
    @State var presented = true

    
    
    var sortedDefinitions: [Definition] {
        group.definitions.sorted { $0.word.word < $1.word.word }
    }
    
    var body: some View {
        VStack {
            TitleView(title: $group.name)
            List(sortedDefinitions, id: \.uuid) { definition in
                VStack(alignment: .leading) {
                    Text(definition.word.word)
                        .font(.body.bold())
                    Text(definition.definition)
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .inspector(isPresented: $presented) {
//            let viewModel = DefinitionsPickerViewModel(context: context)
            DefinitionsPicker(group: group)
        }
    }
}


@Observable
class DefinitionsPickerViewModel {
    
    var expanded = Set<UUID>()
    
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
}



