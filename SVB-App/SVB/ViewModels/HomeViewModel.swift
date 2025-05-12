
import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var favouriteStocks: [Stock] = []
    @Published var newsArticles: [NewsArticle] = []
    @Published var searchText: String = ""
    @Published var isLoadingFavourites: Bool = false
    @Published var isLoadingNews: Bool = false
    @Published var errorMessage: String? = nil

 
    private let stockService: StockService
    private let newsService: NewsService
    private var favouriteViewModel: FavouriteViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(
        favouriteViewModel: FavouriteViewModel,
        stockService: StockService = StockService(),
        newsService: NewsService = NewsService()
    ) {
        self.favouriteViewModel = favouriteViewModel
        self.stockService = stockService
        self.newsService = newsService

    
        favouriteViewModel.$favouriteTickers
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                print("HomeViewModel: Detected change in favourite tickers. Refreshing favourite stock details.")
                Task {
                    await self?.fetchFavouriteStockDetails()
                }
            }
            .store(in: &cancellables)
        
       
    }


    func fetchHomeData() async {
        // Reset states
        isLoadingFavourites = true
        isLoadingNews = true
        errorMessage = nil

        print("HomeViewModel: Starting to fetch home data...")

       
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchFavouriteStockDetails()
            }
         
            group.addTask {
                await self.fetchNews(ticker: "AAPL")
            }
        }
        print("HomeViewModel: Finished fetching home data.")
    }

  
    private func fetchFavouriteStockDetails() async {
  
        if !isLoadingFavourites { isLoadingFavourites = true }
        defer { isLoadingFavourites = false } // Ensure it's set to false on exit

        let tickers = favouriteViewModel.getFavouriteTickers()
        print("HomeViewModel: Fetching details for favourite tickers: \(tickers)")

        guard !tickers.isEmpty else {
            self.favouriteStocks = [] // Clear if no favourites
            print("HomeViewModel: No favourite tickers to fetch details for.")
            return
        }

        var fetchedStocks: [Stock] = []
        // Use TaskGroup to fetch details for each favourite ticker concurrently
     
        await withTaskGroup(of: Stock?.self) { group in
            for ticker in tickers {
                group.addTask {
                    do {
                        // Using searchStocks to get details for an individual ticker.
                   
                        let results = try await self.stockService.searchStocks(query: ticker)
                        if var stock = results.first(where: { $0.ticker.uppercased() == ticker.uppercased() }) {
                            stock.isFavorite = true // Mark as favourite (though FavouriteViewModel is the source of truth)
                            return stock
                        } else {
                            print("HomeViewModel: Could not find details for favourite ticker \(ticker) via search.")
                            return nil
                        }
                    } catch {
                        print("HomeViewModel: Error fetching details for favourite ticker \(ticker): \(error.localizedDescription)")
                        return nil
                    }
                }
            }

            for await stockResult in group {
                if let stock = stockResult {
                    fetchedStocks.append(stock)
                }
            }
        }

        self.favouriteStocks = fetchedStocks.sorted { $0.ticker < $1.ticker } // Optional: Sort favourites
        print("HomeViewModel: Updated favouriteStocks: \(self.favouriteStocks.map { $0.ticker } )")
    }

    /// Fetches news articles for a given ticker (used here for general news).
    private func fetchNews(ticker: String) async {
        if !isLoadingNews { isLoadingNews = true } // Set if called independently
        defer { isLoadingNews = false } // Ensure it's set to false on exit

        print("HomeViewModel: Fetching news for ticker: \(ticker)")
        do {
            // Assumes newsService.fetchNews(for:) exists
            let articles = try await newsService.fetchNews(for: ticker)
            self.newsArticles = articles
            print("HomeViewModel: Fetched \(articles.count) news articles.")
        } catch {
            let errorDescription = "Failed to fetch news: \(error.localizedDescription)"
            print("HomeViewModel: \(errorDescription)")
            self.errorMessage = errorDescription // Update error message
        }
    }



    func initiateSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("HomeViewModel: Search text is empty, not initiating search.")

            return
        }

    }
}
