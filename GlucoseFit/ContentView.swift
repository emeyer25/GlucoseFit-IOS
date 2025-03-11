import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var selectedDate = Date()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(0)

            HomeView(selectedDate: selectedDate)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)

            DoseCalculatorView()
                .tabItem {
                    Label("Dose Calculator", systemImage: "syringe.fill")
                }
                .tag(2)

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self], inMemory: true)
}
