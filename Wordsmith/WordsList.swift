//
//  WordsList.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct WordsList: View {
    
    
    @State private var newWordSheetPresented = false
    
    @Query(sort: \Word.word, order: .forward)
    var words: [Word]
    
    @Binding var selectedWord: Word?
        
    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selectedWord) {
                ForEach(words, id: \.uuid) { word in
                    WordRow(word: word)
                        .tag(word)
                }
            }
            
            Divider()
                
            HStack {
                Button(action: {
                    newWordSheetPresented.toggle()
                    
                }, label: {
                    Label("Add Word", systemImage: "plus")
                })
                .padding(.leading, 16)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                Spacer()
                    
            }
            .background(.quinary)
        }
        .background(.white)
        .sheet(isPresented: $newWordSheetPresented, content: {
            NewWordSheet(isPresented: $newWordSheetPresented, selectedWord: $selectedWord)
                .frame(width: 300, height: 300)
        })
        .navigationTitle("Words")
    }
    
    
    
}


struct AddToList: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .labelsHidden()
            .padding(.leading, 12)
            .padding(.vertical, 8)
            .opacity(configuration.isPressed ? 0.5 : 1)
        
            
    }
}
