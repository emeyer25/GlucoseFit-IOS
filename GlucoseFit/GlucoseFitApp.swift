import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    @AppStorage("hasCompletedSetup") private var hasCompletedSetup = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedSetup {
                ContentView()
            } else {
                WelcomeMenuView()
            }
        }
        .modelContainer(
            for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self],
            inMemory: true, // Set to false for production, true for development
            isAutosaveEnabled: true
        )
    }
}
