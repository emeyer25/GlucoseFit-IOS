import SwiftUI
import SwiftData

@main
struct GlucoseFitApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
        .modelContainer(
            for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self],
            inMemory: true, // Set to false for production, true for development
            isAutosaveEnabled: true
        )
    }
}

struct Main: View {
    @AppStorage("setupComplete") private var setupCompleted = false
    @State private var animateOnComplete = false
    var body: some View {
        ZStack {
            if (!setupCompleted) {
                OnBoardingView(complete: {
                    withAnimation(.easeInOut(duration: 2)) {
                        animateOnComplete = true
                        setupCompleted = true
                    }
                })
                .offset(animateOnComplete ? CGSize(width: 0, height: UIScreen.main.bounds.maxY) : CGSize(width: 0, height: 0))
            }
            else {
                ContentView()
            }
        }
    }
}

#Preview {
    Main()
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self], inMemory: true)
}
