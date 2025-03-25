import SwiftUI
import SwiftData

public struct HomeView: View {
    @StateObject private var settings = Settings.shared
    @Query private var mealLogs: [MealLogEntry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    var selectedDate: Date

    var loggedCalories: Double {
        mealLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { total, meal in
                total + meal.foods.reduce(0) { $0 + $1.calories }
            }
    }

    var remainingCalories: Double {
        let totalCalories = settings.computedFinalCalories
        return max(0, totalCalories - loggedCalories)
    }
    
    // Updated dynamic colors with brighter dark mode
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }
    
    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : .gray
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: backgroundColor, location: 0.00),
                        Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 15) {
                        Spacer()
                        
                        // Calories summary card
                        VStack {
                            Text(selectedDate, formatter: dateFormatter)
                                .font(Font.custom("Inter", size: 24))
                                .bold()
                                .foregroundColor(textColor)
                            
                            Text("Calories")
                                .font(Font.custom("Inter", size: 40))
                                .bold()
                                .foregroundColor(textColor)
                            
                            Text("\(Int(settings.computedFinalCalories)) - \(Int(loggedCalories))")
                                .font(Font.custom("Inter", size: 24))
                                .foregroundColor(secondaryTextColor)
                            
                            Text("\(Int(remainingCalories))")
                                .font(Font.custom("Inter", size: 40))
                                .bold()
                                .foregroundColor(textColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(cardBackgroundColor)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        
                        // Meal sections
                        mealSection(title: "Breakfast", selectedDate: selectedDate)
                        mealSection(title: "Lunch", selectedDate: selectedDate)
                        mealSection(title: "Dinner", selectedDate: selectedDate)
                        mealSection(title: "Snack", selectedDate: selectedDate)
                        
                        Spacer()
                    }
                    .padding(.top)
                }
            }
        }
        .modelContext(modelContext)
    }
    
    private func mealSection(title: String, selectedDate: Date) -> some View {
        let meals = mealLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) && $0.mealName == title }
        let totalCarbs = meals.reduce(0) { $0 + $1.foods.reduce(0) { $0 + $1.carbs } }
        
        return NavigationLink(destination: MealLogView(mealName: title, selectedDate: selectedDate)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.custom("Inter", size: 30))
                    .bold()
                    .foregroundColor(textColor)
                
                Text("Carbs: \(Int(totalCarbs))g")
                    .font(Font.custom("Inter", size: 22))
                    .foregroundColor(secondaryTextColor)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackgroundColor)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
        HomeView(selectedDate: Date())
            .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self])
            .preferredColorScheme(.dark)
}
