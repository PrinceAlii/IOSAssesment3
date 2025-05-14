import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var favouriteStocks: [Stock] = []
    @Published var latestNews: [NewsArticle] = []
    
    private let stockService = StockService()
    private let newsService = NewsService()
    
    func fetchFavouriteStockDetails(favouriteTickers:[String]) async {
        do {
            var fetchedStocks : [Stock] = []
            for ticker in favouriteTickers {
                let stocks = try await stockService.searchStocks(query: ticker)
                fetchedStocks.append(contentsOf: stocks)
            }
            self.favouriteStocks = fetchedStocks
        } catch {
            print("Error in fetching favourite stocks")
        }
    }
    
    func fetchLatestNews(ticker:String) async {
        do {
            let news = try await newsService.fetchNews(for: ticker)
            self.latestNews = news
        } catch {
            print("Error in fethcing news")
        }
    }
    
    
}
