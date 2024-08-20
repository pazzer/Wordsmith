//
//  SourceRow.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct SourceRow: View {
    
    @Bindable var source: Source
    
    var body: some View {
        HStack {
            Text(source.name)
            Spacer()
            Text("\(source.definitions.count)")
                .foregroundStyle(.secondary)
        }
    }
    
}
