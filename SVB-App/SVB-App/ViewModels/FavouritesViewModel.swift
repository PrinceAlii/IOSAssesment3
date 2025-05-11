//
//  FavouritesViewModel.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 11/5/2025.
//

import Foundation
import Combine

class FavouritesViewModel: ObservableObject {
    
    @Published var favouriteStocks: [Stock] = []
    
    private let persistenceService: PersistenceService
    
    init( persistenceService : PersistenceService = PersistenceService.shared) {
        self.persistenceService = persistenceService
        loadFavourites()
    }
    
    func loadFavourites() {
        do { self.favouriteStocks = try persistenceService.loadFavorites()
        } catch {
            print("Error loading favourites: \(error.localizedDescription)")
            self.favouriteStocks = []
        }
            
        }
    
    func addFavourite(stock:Stock) {
        guard !isFavourite(stock:stock) else {
            print( "\(stock.symbol) is already a favourite.")
            
            return
        }
        favouriteStocks.append(stock)
        saveFavourites()
        print("Added \(stock.symbol) is already a favourite")
    }
    
    func removeFavourite(at offsets: IndexSet){
        favouriteStocks.remove(atOffsets:offsets)
        saveFavourites()
        print("Removed Favourites at offsets: \(offsets).")
    }
    
    func isFavourite(stock:Stock) -> Bool {
        return favouriteStocks.contains(where: { $0.symbol == stock.symbol })
    }
    
    private func saveFavourites() {
        do {
            try persistenceService.saveFavorites(stocks: favouriteStocks)
            print ("Sucsessfully Saved \(favouriteStocks.count) favourites.")
        } catch {
            print("Error Savings Favourites \(error.localizedDescription)")
        }
    }
    
}
