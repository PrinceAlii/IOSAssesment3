//
//  NewsListView.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 12/5/2025.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel: StockDetailViewModel

    var body: some View {
        Group {
            if viewModel.isLoadingNews {
                ProgressView("Loading News…")
            } else if let error = viewModel.newsError {
                Text("Failed to load news: \(error.localizedDescription)")
            } else {
                List(viewModel.news) { article in
                    NewsRowView(article: article)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadNews()
            }
        }
        //.navigationTitle("News for \(viewModel.stock.ticker)")
    }
}
