//
//  MealLogEntry.swift
//  GlucoseFit
//

import SwiftData
import Foundation

@Model
class MealLogEntry {
    var id: UUID
    var foodName: String
    var calories: Double
    var carbs: Double
    var mealType: String // "Breakfast", "Lunch", "Dinner", "Snack"

    init(foodName: String, calories: Double, carbs: Double, mealType: String) {
        self.id = UUID()
        self.foodName = foodName
        self.calories = calories
        self.carbs = carbs
        self.mealType = mealType
    }

    // ✅ Add a New Meal Entry
    static func addEntry(foodName: String, calories: Double, carbs: Double, mealType: String, context: ModelContext) {
        let newEntry = MealLogEntry(foodName: foodName, calories: calories, carbs: carbs, mealType: mealType)
        context.insert(newEntry)
    }

    // ✅ Update an Existing Meal Entry
    func updateEntry(foodName: String, calories: Double, carbs: Double) {
        self.foodName = foodName
        self.calories = calories
        self.carbs = carbs
    }

    // ✅ Delete a Meal Entry
    static func deleteEntry(entry: MealLogEntry, context: ModelContext) {
        context.delete(entry)
    }
}
