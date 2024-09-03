//
//  WordsList.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct WordsList: View {
    
    @Query(sort: \Word.word, order: .forward)
    var words: [Word]
    
    @Binding var selection: Word?
    
    var body: some View {
        SearchableWords(selection: $selection, rowView: { word in
            WordRow(word: word)
        }, includeAddOption: true)
        .searchableWordsBackground(.white)
    }
}

struct SearchableWordsBackground: ViewModifier {
    
    var color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(color)
    }
}

extension View {
    func searchableWordsBackground(_ color: Color) -> some View {
        modifier(SearchableWordsBackground(color))
    }
}
