//
//  Stock.swift
//
// represent a stock, properties populated from polygons API
import Foundation
    
struct Stock: Identifiable, Decodable{
    let id: String
    let ticker: String
    let companyName: String
    var currentPrice: Double? // previous days closing price
    var priceChange: Double? // change from previous days open till close
    var priceChangePercent: Double? // percentage change from previous days open to its close
    var isFavorite: Bool = false
    
    // initialiser
    init(ticker: String, companyName: String, currentPrice: Double? = nil, priceChange: Double? = nil, priceChangePercent: Double? = nil, isFavorite: Bool = false) {
        self.id = ticker
        self.ticker = ticker
        self.companyName = companyName
        self.currentPrice = currentPrice
        self.priceChange = priceChange
        self.priceChangePercent = priceChangePercent
        self.isFavorite = isFavorite
    }
    
    
    enum CodingKeys: String, CodingKey {
         case id
         case ticker
         case companyName = "name" //
         // price data populated elsewhere
     }
    
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
       ticker = try container.decode(String.self, forKey: .ticker)
       companyName = try container.decode(String.self, forKey: .companyName)
       id = ticker // assign the ticker to an id

       currentPrice = nil
       priceChange = nil
       priceChangePercent = nil
       isFavorite = false // default
   }
}

// ref: https://polygon.io/docs/rest/stocks/tickers/ticker-overview

struct PolygonTickerSearchResponse: Decodable {
    let results: [PolygonTicker]?
    let status: String?
    let requestId: String?
    let count:   Int?

    enum CodingKeys: String, CodingKey {
        case results, status
        case requestId = "request_id"
        case count
    }


struct PolygonTicker: Decodable, Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let market: String?
    let locale: String?
    let primaryExchange: String?
    let type: String?
    let active: Bool?
    let currencyName: String?
    let lastUpdatedUTC: String?

    enum CodingKeys: String, CodingKey {
        case ticker, name, market, locale, type, active
        case primaryExchange = "primary_exchange"
        case currencyName = "currency_name"
        case lastUpdatedUTC = "last_updated_utc"
    }
}


// previous day close: /v2/aggs/ticker/{stocksTicker}/prev
struct PolygonPrevDayCloseResponse: Decodable {
    let ticker: String?
    let status: String?
    let results: [PolygonPrevDayData]?
    let resultsCount: Int?
}

struct PolygonPrevDayData: Decodable {
    let openPrice: Double // o = open price
    let closePrice: Double // c = closing price
    let highPrice: Double // h = high price
    let lowPrice: Double // l = low price
    let volume: Double? // v = volume
    let volumeWeightedAveragePrice: Double? // vw = volume weighted average price ??? idk

    enum CodingKeys: String, CodingKey {
        case openPrice = "o"
        case closePrice = "c"
        case highPrice = "h"
        case lowPrice = "l"
        case volume = "v"
        case volumeWeightedAveragePrice = "vw"
    }
}
