//
//  SVB_AppApp.swift
//  SVB-App
//

import SwiftUI
import SwiftData

@main
struct SVB_AppApp: App {
    @StateObject private var searchVM = SearchViewModel(
        stockService: StockService()
    )
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UINavigationController.self])
            .tintColor = UIColor(Color.themePrimary)
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Alert.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all)

                SearchView()
                    .environmentObject(searchVM)
                    .modelContainer(sharedModelContainer)
                    .accentColor(.themePrimary)
            }
        }
    }
}
