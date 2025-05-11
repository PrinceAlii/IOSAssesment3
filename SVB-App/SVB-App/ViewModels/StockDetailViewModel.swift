//
//  StockDetailViewModel.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 11/5/2025.
//

import Foundation

@MainActor
class StockDetailViewModel: ObservableObject {
    @Published var stock: Stock
    @Published var chartData: [Double] = [] // or a custom type
    @Published var news: [NewsArticle] = []

    init(stock: Stock) {
        self.stock = stock
        Task {
            await fetchChart()
            await fetchNews()
        }
    }

    func fetchChart() async {
        // example call
        // chartData = try await NetworkManager.shared.fetchData(...)
    }

    func fetchNews() async {
        // news = try await NetworkManager.shared.fetchData(...)
    }
}
