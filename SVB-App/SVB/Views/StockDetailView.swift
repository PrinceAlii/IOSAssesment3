//
//  StockDetailView.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 11/5/2025.
//

import SwiftUI
import SwiftData

struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel
    @Environment(\.modelContext) private var context
    @State private var selectedTab = 0

    init(stock: Stock) {
        _viewModel = StateObject(wrappedValue: StockDetailViewModel(stock: stock))
    }

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text(viewModel.stock.companyName)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(viewModel.stock.ticker)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Picker("Select Tab", selection: $selectedTab) {
                Text("Info").tag(0)
                Text("News").tag(1)
                Text("Alerts").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Divider()

            // Tab content
            Group {
                switch selectedTab {
                case 0:
                    infoTab
                case 1:
                    NewsListView(viewModel: viewModel)
                case 2:
                    AlertConfigView(
                        ticker: viewModel.stock.ticker,
                        companyName: viewModel.stock.companyName,
                        context: context
                    )
                default:
                    EmptyView()
                }
            }
            .padding()
            .animation(.easeInOut, value: selectedTab)

            Spacer()
        }
    }

    var infoTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Price:")
                    .font(.headline)
                Spacer()
                if let price = viewModel.stock.currentPrice {
                    Text("$\(price, specifier: "%.2f")")
                        .bold()
                } else {
                    Text("N/A")
                        .foregroundColor(.gray)
                }
            }

            HStack {
                Text("Change:")
                    .font(.headline)
                Spacer()
                if let change = viewModel.stock.priceChange,
                   let percent = viewModel.stock.priceChangePercent {
                    let isPositive = change >= 0
                    Text(String(format: "%.2f (%.2f%%)", change, percent * 100))
                        .foregroundColor(isPositive ? .green : .red)
                } else {
                    Text("N/A")
                        .foregroundColor(.gray)
                }
            }

            // placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(Text("Chart Placeholder"))

        }
    }
}
