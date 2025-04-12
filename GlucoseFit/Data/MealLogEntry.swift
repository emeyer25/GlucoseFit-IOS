import SwiftData
import Foundation

@Model
final class FoodItem {
    var name: String
    var carbs: Double
    var calories: Double
    var id = UUID()
    
    init(name: String, carbs: Double, calories: Double) {
        self.name = name
        self.carbs = carbs
        self.calories = calories
    }
}

@Model
final class SavedFoodItem {
    var name: String
    var carbs: Double
    var calories: Double
    var id = UUID()

    init(name: String, carbs: Double, calories: Double) {
        self.name = name
        self.carbs = carbs
        self.calories = calories
    }
}

@Model
final class MealLogEntry {
    public final var mealName: String
    var foods: [FoodItem]
    var date: Date
    var id = UUID()
    
    init(mealName: String, foods: [FoodItem], date: Date) {
        self.mealName = mealName
        self.foods = foods
        self.date = date
    }
}

@Model
final class InsulinLogEntry {
    var id: UUID = UUID()
    var units: Double
    var date: Date

    init(units: Double, date: Date) {
        self.units = units
        self.date = date
    }
}
