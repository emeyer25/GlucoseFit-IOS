import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
        .modelContainer(
            for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self],
            inMemory: false, // Set to false for production, true for development
            isAutosaveEnabled: true
        )
    }
}

#Preview {
    Main()
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self], inMemory: true)
}
