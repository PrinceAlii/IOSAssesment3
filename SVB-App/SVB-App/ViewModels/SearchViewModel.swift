//
//  SearchViewModel.swift
//  SVB-App
//
//  Created by Ali bonagdaran on 10/5/2025.
//
// manages the state and logic for the stock search feature.
import Foundation
import Combine
@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [Stock] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let stockService: StockService
    private var cancellables = Set<AnyCancellable>()

    init(stockService: StockService = StockService()) {
        self.stockService = stockService
        setupDebouncer()
    }

    func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            self.searchResults = []
            self.errorMessage = nil
            return
        }

        self.isLoading = true
        self.errorMessage = nil
        self.searchResults = []
        
        Task {
            do {
                let stocks = try await stockService.searchStocks(query: query)

                self.searchResults = stocks
                if stocks.isEmpty {
                    self.errorMessage = "no results found for \"\(query)\"."
                }
                self.isLoading = false
            } catch let networkError as NetworkManager.NetworkError {
                switch networkError {
                case .apiError(let message):
                    self.errorMessage = message
                case .invalidURL:
                    self.errorMessage = "invalid search URL. please try again"
                case .requestFailed:
                    self.errorMessage = "network request failed. check the connection"
                case .invalidResponse:
                    self.errorMessage = "received an invalid response from the server"
                case .decodingError:
                    self.errorMessage = "failed to process search results. please try again"
                }
                self.isLoading = false
            } catch let serviceError as StockService.ServiceError {
                 switch serviceError {
                    case .urlConstructionFailed:
                        self.errorMessage = "could not construct search request"
                    case .noPriceDataFound(let ticker):
                        self.errorMessage = "price data not found for \(ticker)."
                    case .underlyingError(let error):
                        self.errorMessage = "an unexpected error occurred: \(error.localizedDescription)"
                    case .apiKeyMissing:
                        self.errorMessage = "The API key cound not be found. (For the group: do you have a secrets.swift file in ur xcode project? make sure u have APIKEY=insertkeyhere in the first line. if u do, something has gone terribly wrong"
                 }
                self.isLoading = false
            }
            catch {
                self.errorMessage = "a rare and unexpected error occurred: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    private func setupDebouncer() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newTextQuery in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
}
