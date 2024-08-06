//
//  WordDetail.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct WordDetail: View {
    
    @Bindable var word: Word
    
    var body: some View {
        VStack {
            TextField("Word", text: $word.word)
            Spacer()
        }
        .padding()
        
    }
    
}
