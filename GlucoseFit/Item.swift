//
//  Item.swift
//  GlucoseFit
//

import SwiftData
import Foundation

@Model
class Item {
    var id: UUID
    var name: String
    var value: Double
    var timestamp: Date
    var category: String // Example: "Glucose", "Carbs", "Insulin"

    init(name: String, value: Double, category: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.value = value
        self.category = category
        self.timestamp = timestamp
    }
}
