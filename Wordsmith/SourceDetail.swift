//
//  SourceDetail.swift
// Wordsmith
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct SourceDetail: View {
    
    @Bindable var source: Source
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TextField("Source", text: $source.name)
                    .textFieldStyle(.plain)
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            .background(.white)
            Spacer()
        }
        
    }
    
}
