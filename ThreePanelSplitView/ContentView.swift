//
//  ContentView.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @State var selectedSidebarItem: Sidebar.Item?
    @State var selectedWord: Word?
    
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selectedItem: $selectedSidebarItem)
        } content: {
            if let selectedSidebarItem = selectedSidebarItem {
                switch selectedSidebarItem {
                case .words:
                    WordsList(selectedWord: $selectedWord)
                case .sources:
                    Text("Not Implemented")
                case .groups:
                    Text("Not Implemented")
                }
                
            }
        } detail: {
            if let selectedWord = selectedWord {
                WordDetail(word: selectedWord)
            }
        }
    }
    
    
    
    
}


#Preview {
    
    struct Preview: View {
        
        var body: some View {
            ContentView()
        }
    }
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Word.self,
        ])
        
        
        let container = try ModelContainer(for: schema, configurations: config)
        
        SampleDataManager.loadSampleData(into: container.mainContext)
        
        return Preview()
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
