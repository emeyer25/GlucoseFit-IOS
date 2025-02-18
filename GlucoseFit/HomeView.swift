import SwiftUI
import SwiftData

public struct HomeView: View {
    @StateObject private var settings = Settings.shared
    @Query private var mealLogs: [MealLogEntry] // Fetch all meal logs using SwiftData

    // 🔹 Calculate logged calories dynamically
    var loggedCalories: Double {
        mealLogs.reduce(0) { $0 + $1.calories }
    }

    var remainingCalories: Double {
        let totalCalories = settings.computedFinalCalories
        return max(0, totalCalories - loggedCalories) // Prevents negative values
    }

    public var body: some View {
        NavigationView {
            ZStack {
                // 🔹 Background Gradient
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()

                    // 🔥 Calorie Summary
                    VStack {
                        Text("Calories")
                            .font(Font.custom("Inter", size: 40))
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("\(Int(settings.computedFinalCalories)) - \(Int(loggedCalories))")
                            .font(Font.custom("Inter", size: 24))
                            .foregroundColor(.gray)

                        Text("\(Int(remainingCalories))")
                            .font(Font.custom("Inter", size: 40))
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    // � Meal Sections (Clickable)
                    mealSection(title: "Breakfast")
                    mealSection(title: "Lunch")
                    mealSection(title: "Dinner")
                    mealSection(title: "Snack")

                    Spacer()
                }
            }
        }
    }
}

// 🔹 Clickable Meal Sections that Open `MealLogView`
private func mealSection(title: String) -> some View {
    NavigationLink(destination: MealLogView(mealName: title)) {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.custom("Inter", size: 32))
                .bold()
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: MealLogEntry.self) // Provide a preview container
}
