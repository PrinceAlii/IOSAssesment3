//
//  NetworkManager.swift
//  SVB-App
//
//  Created by Ali bonagdaran on 9/5/2025.
//
// provides the networking capacity for fetching and decoding data from the Polygon API
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // custom error types
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingError(Error)
        case apiError(String)
    }
    

   // fetches data from the API and decodes it
   // returns a decoded object of type T
   func fetchData<T: Decodable>(from url: URL, apiKey: String? = nil) async throws -> T {
       var request = URLRequest(url: url)
       
       if let apiKey = apiKey {
           request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
       }
       
       // perfor the api call
       let (data, response) : (Data, URLResponse)
       do {
           (data, response) = try await URLSession.shared.data(for: request)
       } catch {
           throw NetworkError.requestFailed(error)
       }

       // check the response is valid
       guard let httpResponse = response as? HTTPURLResponse else {
           throw NetworkError.invalidResponse
       }
       
       
       // check if somethings wrong with our API key
       if httpResponse.statusCode == 401 {
           throw NetworkError.apiError("HTTP 401 error. check API key")
       }

       guard (200...299).contains(httpResponse.statusCode) else {
           // try and decode other error messages
           // add *POLYGON ERROR RESPONSE* later when I get to it
           if let polygonError = try? JSONDecoder().decode(*POLYGON ERROR RESPONSE* .self, from: data) {
                throw NetworkError.apiError("API Error: \(polygonError.message ?? "Unknown error") (Status: \(httpResponse.statusCode))")
           }
           throw NetworkError.invalidResponse
       }
       
       // decode JSON data
       do {
           let decoder = JSONDecoder()
           // if needed
           // let dateFormatter = DateFormatter()
           // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           // decoder.dateDecodingStrategy = .formatted(dateFormatter)
           return try decoder.decode(T.self, from: data)
       } catch {
           print("Decoding error!: \(error)")
           if let jsonString = String(data: data, encoding: .utf8) {
               print("Failed to decode JSON!: \(jsonString)")
           }
           throw NetworkError.decodingError(error)
       }
   }
}
