//
//  WordRow.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftUI
import SwiftData


struct WordRow: View {
    
    @Bindable var word: Word
    
    var body: some View {
        HStack {
            Text(word.word)
            Spacer()
            Text("\(word.definitions.count)")
                .foregroundStyle(.secondary)
        }
    }
    
}


