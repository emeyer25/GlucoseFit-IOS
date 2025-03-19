import SwiftData
import Foundation

@Model
final class FoodItem {
    var name: String
    var carbs: Double
    var calories: Double
    
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

