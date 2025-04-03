import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var selectedDate = Date()
    @Environment(\.modelContext) private var modelContext
    @StateObject private var settings = Settings.shared
    @State private var showSettingsMenu = false

    // Computed property to get the top safe area inset.
    var topSafeAreaInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            return 20
        }
        return window.safeAreaInsets.top
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(0)

                if settings.isCarbOnlyViewEnabled {
                    CarbHomeView(selectedDate: selectedDate)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(1)
                } else {
                    HomeView(selectedDate: selectedDate)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(1)
                }

                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(2)
            }
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }

            if showSettingsMenu {
                VStack {
                    SettingsMenuView(settings: settings, onClose: {
                        withAnimation {
                            showSettingsMenu = false
                        }
                    })
                    Spacer()
                }
                .transition(.move(edge: .top))
                .zIndex(1)
            }
        }
        // Floating syringe button positioned using overlay with alignment and offset.
        .overlay(
            Button(action: {
                withAnimation {
                    showSettingsMenu.toggle()
                }
            }) {
                Image(systemName: "syringe")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Circle())
            }
            .padding(.trailing, 16)
            .padding(.top, topSafeAreaInset)
            .offset(y: -80),  // Moves the button higher.
            alignment: .topTrailing
        )
    }
}


#Preview {
    ContentView()
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self], inMemory: true)
}
