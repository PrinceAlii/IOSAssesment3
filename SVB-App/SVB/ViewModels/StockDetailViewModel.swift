//
//  StockDetailViewModel.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 11/5/2025.
//

import Foundation

class StockDetailViewModel: ObservableObject {
    let stock: Stock
    @Published var news: [NewsArticle] = []
    @Published var isLoadingNews = false
    @Published var newsError: Error?

    private let newsService = NewsService()

    init(stock: Stock) {
        self.stock = stock
    }

    @MainActor
    func loadNews() async {
        isLoadingNews = true
        newsError = nil
        do {
            let fetchedNews = try await newsService.fetchNews(for: stock.ticker)
            news = fetchedNews
        } catch {
            newsError = error
        }
        isLoadingNews = false
    }
}
