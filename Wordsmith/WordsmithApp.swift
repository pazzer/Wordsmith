//
// WordsmithApp.swift
// Wordsmith
//
//  Created by Paul Patterson on 06/08/2024.
//

import SwiftUI
import SwiftData
import os

@main
struct WordsmithApp: App {
    
    static var launchedFromXcode: Bool {
        ProcessInfo.launchedFromXcode
    }
    
    private(set) static var storingDataOnDisc: Bool = false
    
    static var configuration: WordsmithConfiguration = {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            Logger.app.fault("failed to extract app info dictionary")
            fatalError()
        }
        
        guard let rawConfigurationIdentifier = infoDictionary[WordsmithConfiguration.buildSettingKey] as? String else {
            Logger.app.fault("no key '\(WordsmithConfiguration.buildSettingKey)' in app info dictionary. Check key/value is present in (i) target's user-defined build settings, and (ii) its info table.")
            fatalError()
        }
        
        guard let configuration = WordsmithConfiguration(rawValue: rawConfigurationIdentifier) else {
            Logger.app.fault("failed to construct instance of <\(String(describing: type(of: WordsmithConfiguration.self)))> from raw value '\(rawConfigurationIdentifier)'")
            fatalError()
        }
        
        Logger.app.info("launched from Xcode: \(Self.launchedFromXcode ? "YES" : "NO")")
        Logger.app.info("using '\(configuration.rawValue)' configuration.")
        
        return configuration
    }()
    
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            Word.self
        ])
        
        var modelConfiguration: ModelConfiguration
        modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: WordsmithApp.configuration == .debug, allowsSave: true)
        Self.storingDataOnDisc = !modelConfiguration.isStoredInMemoryOnly
    
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        Logger.database.info("created store container.")
        if !WordsmithApp.storingDataOnDisc {
            Logger.database.info("using in-memory store.")
        } else if let path = sharedModelContainer.configurations.first?.url.path(percentEncoded: false) {
            Logger.database.info("using on-disk store: \(path, privacy: .public).")
        } else {
            Logger.database.warning("using on-disk store but failed to access store url.")
        }
        

        
        if WordType.all(in: sharedModelContainer.mainContext).isEmpty {
            WordType.installPresets(in: sharedModelContainer.mainContext)
        }
        
        if Self.configuration == .debug {
            SampleDataManager.loadSampleData(into: sharedModelContainer.mainContext)
        }
        
        return WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    static func summarizeLaunchEnvironment() {
        
    }
}



public extension ProcessInfo {
    static var launchedFromXcode: Bool {
        Self.processInfo.environment.keys.contains(CustomEnvironmentVariable.xCodeLaunch.rawValue)
    }
}



enum CustomEnvironmentVariable: String {
    case xCodeLaunch = "XCODE_LAUNCH"
}

enum WordsmithConfiguration: String {
    
    static let buildSettingKey = "CONFIG_ID"
    
    case personal = "personal"
    case debug = "debug"
    
    var usesInMemoryStore: Bool {
        switch self {
        case .personal:
            return false
        case .debug:
            return true
        }
    }
}
