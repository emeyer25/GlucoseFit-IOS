import SwiftData
import Foundation

@Model
final class MealLogEntry {
    var mealName: String
    var carbs: Double
    var calories: Double
    var date: Date
    
    init(mealName: String, carbs: Double, calories: Double, date: Date) {
        self.mealName = mealName
        self.carbs = carbs
        self.calories = calories
        self.date = date
    }
}
