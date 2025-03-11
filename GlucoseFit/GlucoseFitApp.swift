import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    @State private var isSplashScreenVisible = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashScreenVisible {
                    SplashScreenView()
                        .transition(.opacity)
                } else {
                    ContentView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isSplashScreenVisible = false
                    }
                }
            }
        }
        .modelContainer(
            for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self],
            inMemory: false, // Set to false for production, true for development
            isAutosaveEnabled: true
        )
    }
}
