//
//  SVB_AppApp.swift
//
import SwiftUI

// will need to change later, just set to this as this is our only viewß
@main
struct SVB_AppApp: App {
    @StateObject private var searchVM = SearchViewModel(
        stockService: StockService()
    )

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(searchVM)
        }
    }
}

