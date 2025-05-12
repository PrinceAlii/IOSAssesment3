//
//  HomeViewModel.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 12/5/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var favouriteStocks:[Stock] = []
    @Published var newsArticles : [NewsArticle] = []
    @Published var searchText : String = ""
    @Published var isLoadingFacvoriteStocks : Bool = false
    @Published var isLoadingNews : Bool = false
    @Published var errorMessages : String? = nil
    
    
    private let stockService:StockService
    private let newsService:NewsService
    private let favouriteProvider:FavouriteProviding
    
    private var cancellables = Set<AnyCancellable>()
    
    init(stockService: StockService = StockService(),
         newsService: NewsService = NewsService(),
         favouriteProvider:FavouriteProviding) {
        self.stockService = stockService
        self.newsService = newsService
        self.favouriteProvider = favouriteProvider
        
        fetchHomeData()
    }
    
    func 
    
}
