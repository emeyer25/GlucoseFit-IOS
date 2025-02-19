import Foundation
import SwiftData

struct DataManager {
    static func resetData(context: ModelContext) {
        let mealRequest = FetchDescriptor<MealLogEntry>()
        let foodRequest = FetchDescriptor<FoodItem>()

        if let meals = try? context.fetch(mealRequest) {
            for meal in meals {
                context.delete(meal)
            }
        }
        if let foods = try? context.fetch(foodRequest) {
            for food in foods {
                context.delete(food)
            }
        }
        try? context.save()
    }
}
