//
//  SVB_AppApp.swift
//
import SwiftUI
import SwiftData

// will need to change later, just set to this as this is our only viewß
@main
struct SVB_AppApp: App {
    @StateObject private var searchVM = SearchViewModel(
        stockService: StockService()
    )

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
            SearchView()
                .environmentObject(searchVM)
                .modelContainer(sharedModelContainer)
        }
    }
}
