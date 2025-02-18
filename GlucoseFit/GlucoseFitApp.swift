import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: MealLogEntry.self) // Set up SwiftData container
    }
}
