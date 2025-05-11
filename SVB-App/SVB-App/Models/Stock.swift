//
//  Stock.swift
//
import Foundation

struct Stock : Identifiable, Codable, Hashable {
    let id: UUID
    let symbol: String
    let name:String
    var price: Double
    var change: Double
    var changePercentage : Double
    var description:String?
    
    
    init(id: UUID = UUID(), symbol: String,name:String, price: Double, change: Double,changePercentage: Double, description:String? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.changePercentage = changePercentage
        self.description = description
        
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(symbol)
    }
    
    static func == (Ihs:Stock , rhs:Stock) -> Bool {
        return Ihs.id == rhs.id && Ihs.symbol == rhs.symbol
    }
    
    static var sampleStocks :[Stock] = [
        Stock(symbol:"AAPL",name: "Apple Inc.", price: 170.34,change: 1.5,changePercentage: 0.89,description: "Technology")
        Stock(symbol: "MSFT", name: "Microsoft Corporation", price: 280.5, change: -0.25, changePercentage: "Technology")
    ]
    }
}
