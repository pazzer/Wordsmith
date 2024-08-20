//
//  ContentView.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @State var selectedSidebarItem: Sidebar.Item? = nil
    @State var selectedWord: Word? = nil
    @State var selectedSource: Source? = nil
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selectedItem: $selectedSidebarItem)
        } content: {
            if let selectedSidebarItem = selectedSidebarItem {
                switch selectedSidebarItem {
                case .words:
                    WordsList(selectedWord: $selectedWord)
                case .sources:
                    SourcesList(selectedSource: $selectedSource)
                case .groups:
                    Text("Not Implemented")
                }
                
            }
        } detail: {
            if let sidebarItem = selectedSidebarItem {
                switch sidebarItem {
                case .words:
                    if let selectedWord = selectedWord {
                        WordDetail(word: selectedWord, selectedDefinition: .constant(nil))
                    }
                case .sources:
                    if let selectedSource = selectedSource {
                        SourceDetail(source: selectedSource)
                    }
                case .groups:
                    Text("Not Implemented")
                }
            } else {
                ContentUnavailableView("No Selection", image: "exclamationmark")
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
