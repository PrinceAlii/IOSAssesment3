//
//  SearchView.swift
//  SVB-App
//
//  Created by Ali bonagdaran on 10/5/2025.
//
// UI for searching and displaying stocks
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel

    @MainActor
    init(viewModel: SearchViewModel? = nil) {
        let vm = viewModel ?? SearchViewModel()
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.searchResults.isEmpty {
                    ProgressView("Searching...")
                        .padding()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage, viewModel.searchResults.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .padding(.bottom)
                        Text(errorMessage)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        if errorMessage.contains("API Key") {
                             Text("The API KEY isn't detected, or something else with the API key has gone wrong :(")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        Button("Retry") {
                            viewModel.performSearch()
                        }
                        .padding(.top)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                } else {
                    // ** begin actual view **
                    List(viewModel.searchResults) { stock in
                        StockSearchRow(stock: stock)
                    }
                    if !viewModel.isLoading && viewModel.searchResults.isEmpty && viewModel.searchText.count > 0 && viewModel.errorMessage == nil {
                        Text("No results found for \"\(viewModel.searchText)\". Try a different name")
                            .foregroundColor(.secondary)
                            .padding()
                        Spacer()
                    } else if !viewModel.isLoading && viewModel.searchResults.isEmpty && viewModel.searchText.isEmpty && viewModel.errorMessage == nil {
                         Text("Enter a stock ticker or company name to search")
                            .foregroundColor(.secondary)
                            .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Search stocks")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search ticker or company name")
        }
    }
}

struct StockSearchRow: View {
    let stock: Stock

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .font(.headline)
                    .bold()
                Text(stock.companyName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            if let price = stock.currentPrice, let changePercent = stock.priceChangePercent {
                VStack(alignment: .trailing) {
                    Text(String(format: "%.2f", price))
                        .font(.headline)
                    Text(String(format: "%@%.2f%%", changePercent >= 0 ? "+" : "", changePercent * 100))
                        .font(.subheadline)
                        .foregroundColor(changePercent >= 0 ? .green : .red)
                }
            } else {
                 Text("N/A")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        // mock data so we dont get rate limited during testing
        let mockViewModel = SearchViewModel()
        mockViewModel.searchResults = [
            Stock(ticker: "AAPL", companyName: "Apple Inc.", currentPrice: 172.65, priceChange: 1.23, priceChangePercent: 0.0072, isFavorite: true),
            Stock(ticker: "TSLA", companyName: "Tesla Inc.", currentPrice: 245.12, priceChange: -3.87, priceChangePercent: -0.0156)
        ]
        return SearchView()
    }
}
