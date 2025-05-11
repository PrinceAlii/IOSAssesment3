//
//  HomeView.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 9/5/2025.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var favouritesViewModel = FavouritesViewModel()
    
    @State private var selectedTab : Tab = .allStocks
    
    enum Tab {
        case allStocks
        case favourites
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("Select View", selection: $selectedTab) {
                    Text("All Stocks").tag(Tab.allStocks)
                    Text("Favourites").tag(Tab.favourites)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)
                
                //Tab switches
                
                switch selectedTab {
                case .allStocks:
                    allStocksListView
                case .favourites:
                    favouritesListView
                }
                Spacer()
            }
            .navigationTitle(Text("Stock Market"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab == .allStocks && !homeViewModel.isLoading {
                        Button {
                            homeViewModel.refreshStocks()
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                        }
                    }
                }
            }
        }
    }

    private var allStocksListView: some View {
        Group {
            if homeViewModel.isLoading && homeViewModel.stocks.isEmpty{
                loadingView
            } else if homeViewModel.stock.isEmpty{
                emptyStocksView
            } else {
                stockListContentView
            }
        }
    }
    
    private var loadingView:some View {
        ProgressView("Loading Stock...")
            .frame(maxWidth: .infinity, maxHeight:.infinity)
    }
    private var emptyStocksView:some View {
        ProgressView("Loading Stock...")
            .frame(maxWidth: .infinity, maxHeight:.infinity)
    }
    private var stockListContentView:some View {
        ProgressView("Loading Stock...")
            .frame(maxWidth: .infinity, maxHeight:.infinity)
    }
    private var favouritesListView: some View {
        Group {
            
        }
    }
}
