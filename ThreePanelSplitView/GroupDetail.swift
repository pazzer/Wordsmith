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
            DefinitionSelector(group: group)
        }
    }
}



