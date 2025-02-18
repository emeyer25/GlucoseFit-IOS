import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(0)

            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1) // Home is the default tab

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
        .modelContainer(for: MealLogEntry.self)
}
