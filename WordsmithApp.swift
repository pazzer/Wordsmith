//
// WordsmithApp.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftUI
import SwiftData

@main
struct WordsmithApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Word.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        
        SampleDataManager.loadSampleData(into: sharedModelContainer.mainContext)
        
        return WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
