import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }
            DoseCalculatorView().tabItem {
                Label("Dose Calculator", systemImage: "syringe.fill")
            }
            CalendarView().tabItem {
                Label("Calendar", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    ContentView()
}
