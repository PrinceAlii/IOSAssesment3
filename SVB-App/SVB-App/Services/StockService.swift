import Foundation
// fetches stock data from polygons API

class StockService {
    private let networkManager = NetworkManager.shared
    private let apiKey = Secrets.apiKey
    private let polygonBaseURL = "https://api.polygon.io"

    enum ServiceError: Error {
        case urlConstructionFailed
        case noPriceDataFound(ticker: String)
        case underlyingError(Error)
        case apiKeyMissing
    }

    // MARK: - public interface

    /// searches for stock tickers and their previous day's price details.
    /// - Parameter query: the search string for stock tickers (e.g., "Apple", "AAPL").
    /// - Returns: an array of `Stock` objects with price data or basic info.
    /// - Throws: `ServiceError` or `NetworkManager.NetworkError`
    func searchStocks(query: String) async throws -> [Stock] {
        // 1. fetch matching ticker symbols and basic company info
        let polygonTickers: [PolygonTicker]
        do {
            polygonTickers = try await fetchMatchingTickers(query: query)
        } catch {
            print("Failed to fetch matching tickers for query '\(query)': \(error)")
            throw error
        }

        guard !polygonTickers.isEmpty else {
            return []
        }

        var stocks: [Stock] = []

        // 2. concurrently fetch previous day's price details for each ticker
        try await withThrowingTaskGroup(of: Stock.self) { group in
            for pt in polygonTickers {
                group.addTask {
                    // fetch previous day's OHLC data
                    let prevDayData = await self.fetchPreviousDayDetails(for: pt.ticker)
                    if let data = prevDayData {
                        let currentPrice = data.closePrice
                        let openPrice = data.openPrice
                        let priceChange = currentPrice - openPrice
                        let priceChangePercent = openPrice == 0 ? 0 : (priceChange / openPrice)
                        return Stock(
                            ticker: pt.ticker,
                            companyName: pt.name,
                            currentPrice: currentPrice,
                            priceChange: priceChange,
                            priceChangePercent: priceChangePercent
                        )
                    } else {
                        print("No price data found for \(pt.ticker) during search. Returning basic info.")
                        return Stock(ticker: pt.ticker, companyName: pt.name)
                    }
                }
            }

            // collect results from the task group
            for try await stock in group {
                stocks.append(stock)
            }
        }

        return stocks
    }

    // MARK: - private helper functions

    /// fetches a list of ticker symbols and basic company info matching the query.
    private func fetchMatchingTickers(query: String) async throws -> [PolygonTicker] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "\(polygonBaseURL)/v3/reference/tickers?search=\(encodedQuery)&active=true&limit=10&apiKey=\(apiKey)") else {
            throw ServiceError.urlConstructionFailed
        }
        print("Fetching tickers from URL: \(url.absoluteString)")
        let response: PolygonTickerSearchResponse = try await networkManager.fetchData(from: url)
        return response.results ?? []
    }

    /// fetches the previous day's open, high, low, close (OHLC) data for a single ticker symbol.
    /// - Parameter tickerSymbol: the ticker symbol to fetch data for.
    /// - Returns: `PolygonPrevDayData` if available, or `nil` if an error occurs.
    private func fetchPreviousDayDetails(for tickerSymbol: String) async -> PolygonPrevDayData? {
        guard let url = URL(string: "\(polygonBaseURL)/v2/aggs/ticker/\(tickerSymbol)/prev?apiKey=\(apiKey)") else {
            print("Failed to construct URL for previous day details for \(tickerSymbol)")
            return nil
        }

        do {
            print("Fetching previous day details from URL: \(url.absoluteString)")
            let response: PolygonPrevDayCloseResponse = try await networkManager.fetchData(from: url)
            return response.results?.first
        } catch {
            print("Error fetching previous day details for \(tickerSymbol): \(error)")
            if let networkError = error as? NetworkManager.NetworkError {
                switch networkError {
                case .apiError(let msg): print("API error for \(tickerSymbol): \(msg)")
                default: print("Network error for \(tickerSymbol): \(networkError)")
                }
            }
            return nil
        }
    }
}
