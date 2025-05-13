//
//  StockDetailView.swift
//  SVB-App
//
//  Created by Tien Dung Vu on 11/5/2025.
//

import SwiftUI
import SwiftData
import Charts

enum ChartPeriod: CaseIterable, Identifiable {
    case sevenDay, oneMonth, sixMonth, oneYear, fiveYear
    
    var id: Self { self }
    var title: String {
        switch self {
        case .sevenDay: return "7D"
        case .oneMonth: return "1M"
        case .sixMonth: return "6M"
        case .oneYear: return "1Y"
        case .fiveYear: return "5Y"
        }
    }
    var components: DateComponents {
        switch self {
        case .sevenDay:  return DateComponents(day: -7)
        case .oneMonth:  return DateComponents(month: -1)
        case .sixMonth:  return DateComponents(month: -6)
        case .oneYear:   return DateComponents(year: -1)
        case .fiveYear:  return DateComponents(year: -5)
        }
    }
}

struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel
    @Environment(\.modelContext) private var context
    @State private var selectedTab = 0
    @State private var selectedPeriod: ChartPeriod = .oneMonth

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
        .task {
            let now = Date()
            let from = Calendar.current.date(byAdding: selectedPeriod.components, to: now) ?? now
            await viewModel.loadNews()
            await viewModel.loadBars(from: from, to: now)
        }
        .onChange(of: selectedPeriod) { newPeriod in
            let now = Date()
            let from = Calendar.current.date(byAdding: newPeriod.components, to: now) ?? now
            Task { await viewModel.loadBars(from: from, to: now) }
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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(ChartPeriod.allCases) { period in
                        Button(period.title) {
                            selectedPeriod = period
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedPeriod == period ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }

            if let bars = viewModel.bars {
                Chart(bars) { bar in
                    let date = Date(timeIntervalSince1970: bar.t / 1000)
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Close", bar.c)
                    )
                }
                .chartXAxis { AxisMarks(values: .automatic) }
                .chartYAxis { AxisMarks(position: .leading) }
                .frame(height: 200)
            } else if viewModel.isLoadingBars {
                ProgressView()
                    .frame(height: 200)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("The chart couldm't be generated. This is most likely due to an API error, or data restriction."))
            }
        }
    }
}
