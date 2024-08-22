//
//  Sidebar.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftData
import SwiftUI


struct Sidebar: View {
    
    
    enum Item: String, CaseIterable {
        case words
        case sources
        case groups
    }
    
    @Binding var selectedItem: Item?
    
    
    @Query(sort: \Word.created, order: .forward)
    var words: [Word]
    
    
    
    var body: some View {
        List(selection: $selectedItem) {
            ForEach(Item.allCases, id: \.rawValue) { item in
                NavigationLink(value: item) {
                    SidebarRow(item: item)
                }
            }
            
        }
        .navigationTitle("Words")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
            ToolbarItem {
                Button(action: {}) {
                    Label("Add Word", systemImage: "plus")
                }
            }
        }
    }
}
