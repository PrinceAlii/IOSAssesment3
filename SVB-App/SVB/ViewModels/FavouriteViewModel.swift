import Foundation
import Combine
@MainActor
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

