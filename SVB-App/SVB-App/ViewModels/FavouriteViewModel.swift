//
//  FavouriteViewModel.swift
//  SVB-App
//
//  Created by Person 1 / AI on 13/5/2025.
//

import Foundation
import Combine // For ObservableObject and @Published

@MainActor // Ensures UI updates are on the main thread
class FavouriteViewModel: ObservableObject {

    @Published private(set) var favouriteTickers: Set<String>

    private let userDefaultsKey = "favouriteStockTickers"

    init() {
        let savedTickers = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        self.favouriteTickers = Set(savedTickers)
        print("FavouriteViewModel: Loaded favourites - \(self.favouriteTickers)")
    }

   
    func isFavourite(ticker: String) -> Bool {
        favouriteTickers.contains(ticker.uppercased()) // Store and check in uppercase for consistency
    }


    func toggleFavourite(ticker: String) {
        let upperTicker = ticker.uppercased()
        if isFavourite(ticker: upperTicker) {
            removeFavourite(ticker: upperTicker)
        } else {
            addFavourite(ticker: upperTicker)
        }
    }

    // MARK: - Private Methods for Persistence

    private func addFavourite(ticker: String) {
        guard !favouriteTickers.contains(ticker) else { return }
        print("FavouriteViewModel: Adding \(ticker) to favourites")
        favouriteTickers.insert(ticker)
        saveFavourites()
    }

    private func removeFavourite(ticker: String) {
        guard favouriteTickers.contains(ticker) else { return }
        print("FavouriteViewModel: Removing \(ticker) from favourites")
        favouriteTickers.remove(ticker)
        saveFavourites()
    }

    private func saveFavourites() {
        print("FavouriteViewModel: Saving favourites - \(Array(favouriteTickers))")
        UserDefaults.standard.set(Array(favouriteTickers), forKey: userDefaultsKey)
        
    }
    
    
    func getFavouriteTickers() -> [String] {
        return Array(favouriteTickers)
    }
}
