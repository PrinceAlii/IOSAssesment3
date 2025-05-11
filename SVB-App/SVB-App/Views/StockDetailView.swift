//
//  StockDetailView.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 11/5/2025.
//

import SwiftUI

struct StockDetailView: View {
    @ObservedObject var viewModel: StockDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(viewModel.stock.companyName)
                    .font(.title2)
                    .padding(.top)

                Text("Ticker: \(viewModel.stock.ticker)")
                    .font(.subheadline)

                if let price = viewModel.stock.currentPrice {
                    Text(String(format: "Current Price: $%.2f", price))
                        .font(.headline)
                }

                // Example placeholder for chart
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("Chart Placeholder"))

                // News
                if !viewModel.news.isEmpty {
                    Text("Recent News")
                        .font(.title3)
                        .bold()
                        .padding(.top)

                    ForEach(viewModel.news, id: \.id) { article in
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.id)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.stock.ticker)
        .navigationBarTitleDisplayMode(.inline)
    }
}
