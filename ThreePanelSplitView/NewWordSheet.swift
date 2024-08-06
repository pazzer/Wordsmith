//
//  NewWordSheet.swift
//  TwoPanelNavigationSplitView
//
//  Created by Paul Patterson on 04/08/2024.
//

import SwiftUI


struct NewWordSheet: View {
    
    @State var word: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isPresented: Bool
    
    @Binding var selectedWord: Word?
    
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

            }
        }
        .onDisappear(perform: {
            DispatchQueue.main.async {
                selectedWord = Word.withName(word, in: modelContext)
            }
        })
        .padding()
        
    }
    
}

//#Preview {
//    
//    NewWordSheet(isPresented: .constant(true), selection: .constant(nil))
//}
