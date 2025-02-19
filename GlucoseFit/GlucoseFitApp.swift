import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView() // Start with CalendarView
        }
        .modelContainer(for: [MealLogEntry.self, FoodItem.self]) // Set up SwiftData container
    }
}
