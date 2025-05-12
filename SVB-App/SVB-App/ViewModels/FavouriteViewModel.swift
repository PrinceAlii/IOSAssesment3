//
//  FavouriteViewModel.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 12/5/2025.
//

import Foundation
import Combine
import SwiftUI
@MainActor

class FavouriteViewModel: ObservableObject{

    @Published private(set) var favouriteTickers:Set<String>
    
    private let userDefaultsKeys = "favouriteStockTickers"
    
    init(){
        let savedTickers = UserDefaults.standard.stringArray( forKey : userDefaultsKeys) ?? []
        self.favouriteTickers = Set(savedTickers)
        print("Loaded Favourtioes:\(self.favouriteTickers)")
    }
    
    func getFavouriteTickers() -> Set<String>{
        return favouriteTickers
    }
    
    func toggleFavourite(ticker:String){
        if favouriteTickers.contains(ticker){
            favouriteTickers.remove(ticker)
        }else {
            addFavourite(ticker:ticker)
        }
    }
    
    private func addFavourite(ticker:String){
        
        guard !favouriteTickers.contains(ticker) else { return }
        print("Adding \(ticker) to favourites")
        favouriteTickers.insert(ticker)
        saveFavourites()
    }
    
    private func saveFavourites(){
        print("Saving Favourites:\(Array(favouriteTickers))")
        UserDefaults.standard.set(Array(favouriteTickers), forKey: userDefaultsKeys)
    }
    
    func isFavourite(ticker:String) -> Bool{
         favouriteTickers.contains(ticker)
    }
    
    
}
