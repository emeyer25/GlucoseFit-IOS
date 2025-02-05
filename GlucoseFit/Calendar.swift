//
//  Calendar.swift
//  GlucoseFit
//

import SwiftData
import Foundation

@Model
class CalendarEntry {
    var id: UUID
    var date: Date
    var category: String // Example: "Glucose", "Carbs", "Insulin"
    var value: Double // Example: 120 mg/dL glucose, 45g carbs, 5 units insulin
    var notes: String

    init(date: Date, category: String, value: Double, notes: String = "") {
        self.id = UUID()
        self.date = date
        self.category = category
        self.value = value
        self.notes = notes
    }
}
