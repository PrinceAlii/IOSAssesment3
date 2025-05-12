//
//  PersistenceService.swift
//  SVB-App
//
//  Created by Savya Rai on 10/5/2025.
//

// Provides basic CRUD for Alert objects via SwiftData
import Foundation
import SwiftData

class PersistenceService {
    static func fetchAllAlerts ( for ticker: String? = nil , in context:ModelContext) -> [Alert] {
        var descriptor:FetchDescriptor<Alert>
        
        if let ticker = ticker {
            descriptor = FetchDescriptor<Alert>(
                predicate: #Predicate { $0.ticker == ticker },
                sortBy: [SortDescriptor(\Alert.createdAt, order: .reverse)]
            )
        } else {
            descriptor = FetchDescriptor<Alert>(
                sortBy:[SortDescriptor(\Alert.createdAt, order: .reverse)]
            )
        }
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch alerts: \(error)")
            return []
        }
    }
            
    static func fetchAlerts(for ticker: String, in context: ModelContext) -> [Alert] {
        let descriptor = FetchDescriptor<Alert>(
            predicate: #Predicate { $0.ticker == ticker },
            sortBy: [SortDescriptor(\Alert.createdAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    static func add(alert: Alert, in context: ModelContext) {
        context.insert(alert)
        try? context.save()
    }

    static func delete(alert: Alert, in context: ModelContext) {
        context.delete(alert)
        try? context.save()
    }
}
