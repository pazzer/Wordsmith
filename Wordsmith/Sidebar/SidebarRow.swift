//
//  WordRow.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import Foundation
import SwiftUI

struct SidebarRow: View {
    
    var item: Sidebar.Item

    var body: some View {
        Label(item.rawValue.capitalized, systemImage: item.systemImage)
    }
    
    
}
