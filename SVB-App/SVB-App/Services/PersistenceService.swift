//
//  PersistenceService.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 11/5/2025.
//

import Foundation

enum PersistenceError:Error {
    case encodingFailed
    case decodingFailed
    case dataNotFound
    
}

class PersistenceService {
    static let shared = PersistenceService()
    
    private let userDefaults : UserDefaults
    private let favoriteskey = "favouriteStocks"
    
    init(userDefaults: UserDefaults = .standard){
        self.userDefaults = userDefaults
    }
    
    func saveFavorites( stocks: [Stock]) throws {
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(stocks)
            userDefaults.set(encodedData, forKey: favoriteskey)
            
        }catch {
            print("FAILED TO ENCODE FAVOURITES STOCKS: \(error)")
            throw PersistenceError.encodingFailed
        }
    }
 func loadFavorites() throws -> [Stock] {
        guard let savedData  = userDefaults.data(forKey: favoriteskey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Stock].self, from: savedData)
        } catch {
            return[]
        }
    }
    
    func clearRFavorites() {
        userDefaults.removeObject(forKey: favoriteskey)
    }
    
}

