//
//  NewWordSheet.swift
//  TwoPanelNavigationSplitView
//
//  Created by Paul Patterson on 04/08/2024.
//

import SwiftUI
import SwiftData

struct NewWordSheet: View {
    
    @State var word: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isPresented: Bool
    
    @Binding var selectedWord: Word?
    
    @Query var words: [Word]
    
    func validateWord() {
        let candidate = word.trimmingCharacters(in: .whitespaces).lowercased()
        invalidWord = word.isEmpty || words.first(where: {$0.word.lowercased() == candidate } ) != nil
    }
    
    @State var invalidWord = true
    
    var body: some View {
        
        VStack {
            Text("Enter Word")
                .font(.title)
            TextField("", text: $word)
                .multilineTextAlignment(.center)
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                Spacer()
                Button("Add", role: .cancel) {
                    let word = Word(word: word)
                    modelContext.insert(word)
                    isPresented = false
                }
                .disabled(invalidWord)

            }
        }
        .onDisappear(perform: {
            DispatchQueue.main.async {
                selectedWord = Word.find(word, in: modelContext)
            }
        })
        .onChange(of: word) {
            self.validateWord()
        }
        .padding()
        
    }
    
}

//#Preview {
//    
//    NewWordSheet(isPresented: .constant(true), selection: .constant(nil))
//}
