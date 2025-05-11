//
//  HomeViewModel.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 9/5/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var isLoading: Bool = false
    @Published var error:String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        fetchInitialStocks()
    }
    
    func fetchInitialStocks(){
        isLoading = true
        error = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            //USE API HERE PLEASE IM JUST USING SAMPLE DATA FROM STOCK.SWIFT
            self.stocks = Stock.sampleStocks
            self.isLoading = false
            
        }
    }
    
    func refreshStocks(){
        
    }
}
