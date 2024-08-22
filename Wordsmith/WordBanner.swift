//
//  WordBanner.swift
// Wordsmith
//
//  Created by Paul Patterson on 09/08/2024.
//

import SwiftUI


struct WordBanner: View {
    
    @Bindable var word: Word
    
    var body: some View {
        HStack(alignment: .center) {
            TextField("Word", text: $word.word)
                .textFieldStyle(.plain)
                .font(.largeTitle.bold())
                .padding()
            Spacer()
        }
        .background(.white)
    }
}

struct TitleView: View {
    
    // In the event of crashes revert to using `@Bindable` a la `WordBanner`.
    @Binding var title: String
    
    var body: some View {
        HStack(alignment: .center) {
            TextField("", text: $title)
                .textFieldStyle(.plain)
                .font(.largeTitle.bold())
                .padding()
            Spacer()
        }
        .background(.white)
    }
    
    
    
}
