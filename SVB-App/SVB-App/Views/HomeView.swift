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
                
            }
        }
    }
    
}
