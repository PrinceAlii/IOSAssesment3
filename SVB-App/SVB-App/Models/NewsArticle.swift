//
//  NewsArticle.swift
//
// NewsArticle.swift

import Foundation

struct PolygonNewsResponse: Decodable {
    let results: [NewsArticle]?
    let status: String?
    let requestId: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case results, status
        case requestId = "request_id"
        case count
    }
}

struct NewsArticle: Identifiable, Decodable {
    let id: String
    let title: String
    let author: String?
    let publishedUTC: String
    let articleURL: String
    let source: String?
    let summary: String?
    let tickers: [String]?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case publishedUTC = "published_utc"
        case articleURL = "article_url"
        case source
        case summary
        case tickers
        case imageURL = "image_url"
    }
}
