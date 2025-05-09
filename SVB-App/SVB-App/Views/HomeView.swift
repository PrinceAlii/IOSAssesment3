//
//  HomeView.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 9/5/2025.
//

import SwiftUI

struct HomeView: View {
    //FavouriteViewModel
    
    @StateObject private var viewModel:homeViewModel = HomeViewModel();
    
    @State private var selectedTab : Tab = .allStocks
    

}

var body : some View {
    NavigationView {
        VStack {
            //tab
            Picker("Select View", selection: $selectedTab) {
                
            }
        }
    }
}
