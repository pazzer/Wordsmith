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
        ContentList(selection: $selection) { word in
            WordRow(word: word)
        } newItemValidator: { candidateName in
            words.first(where: { $0.word.lowercased() == candidateName.lowercased() }) == nil
        } addItem: { string, context in
            _ = Word.new(word: string, in: context)
        }
        
    }
}
