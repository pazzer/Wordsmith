//
//  WordRow.swift
// Wordsmith
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
            Text("\(word.definitions.filter { !$0.isPlaceholder }.count)")
                .foregroundStyle(.secondary)
        }
    }
    
}


