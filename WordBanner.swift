//
//  WordBanner.swift
//  ThreePanelSplitView
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
