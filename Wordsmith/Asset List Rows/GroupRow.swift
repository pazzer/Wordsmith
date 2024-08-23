//
//  GroupRow.swift
// Wordsmith
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct GroupRow: View {
    
    @Bindable var group: Group
    
    var body: some View {
        HStack {
            Text(group.name)
            Spacer()
            Text("\($group.definitions.count)")
                .foregroundStyle(.secondary)
        }
    }
    
}

