//
//  NetworkManager.swift
//  SVB-App
//
//  Created by Ali bonagdaran on 9/5/2025.
//
// fetches stock data from polygons API
import Foundation

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
    
    // searches for the ticker and previous days price.
    // returns an array of Stock object with price info
    // takes a query as its paramater e.g. apple or APPL
    func searchStocks(query: String) async throws -> [Stock] {
        
        let polygonTickers: [PolygonTicker]
        do {
            polygonTickers = try await fetchMatchingTickers(query: query)
        } catch {
            print("problem finding tickers that match the query: '\(query)': \(error)")
            throw error
        }

        guard !polygonTickers.isEmpty else {
            return []
        }

        var stocks: [Stock] = []

        // concurrently fetch previous days price details for each ticker
        try await withThrowingTaskGroup(of: Stock.self) { group in
            for pt in polygonTickers {
                group.addTask {
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
                        print("price data not found \(pt.ticker) during search. returning basic stock info only")
                        return Stock(ticker: pt.ticker, companyName: pt.name)
                    }
                }
            }
            
            for try await stock in group {
                stocks.append(stock)
            }
        }

        return stocks
    }

    // fetches a list of tickers and companiy info matching the query string
    private func fetchMatchingTickers(query: String) async throws -> [PolygonTicker] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "\(polygonBaseURL)/v3/reference/tickers?search=\(encodedQuery)&active=true&limit=50&apiKey=\(apiKey)") else {
            throw ServiceError.urlConstructionFailed
        }
        print("fetching tickers from this url: \(url.absoluteString)")
        let response: PolygonTickerSearchResponse = try await networkManager.fetchData(from: url)
        return response.results ?? []
    }
    
    // getches the previous days open, high, low and close data for the ticker
    // returns: PolygonPrevDayData or nil if somethings gone wrong
    // takes the ticker symbol as its paramater
    private func fetchPreviousDayDetails(for tickerSymbol: String) async -> PolygonPrevDayData? {
        guard let url = URL(string: "\(polygonBaseURL)/v2/aggs/ticker/\(tickerSymbol)/prev?apiKey=\(apiKey)") else {
            print("failed to make the url to fetch previous day data for \(tickerSymbol)")
            return nil
        }

        do {
            print("fetching previous day data using url: \(url.absoluteString)")
            let response: PolygonPrevDayCloseResponse = try await networkManager.fetchData(from: url)
            return response.results?.first
        } catch {
            print("something went wrong fetching the previous days data for ticker: \(tickerSymbol): \(error)")
            if let networkError = error as? NetworkManager.NetworkError {
                print("network or api error for \(tickerSymbol): \(networkError)")
            }
            return nil
        }
    }
}
