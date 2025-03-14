import SwiftUI
import SwiftData

public struct CarbHomeView: View {
    @StateObject private var settings = Settings.shared
    @Query private var mealLogs: [MealLogEntry]
    @Environment(\.modelContext) private var modelContext

    var selectedDate: Date

    var loggedCarbs: Double {
        mealLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { total, meal in
                total + meal.foods.reduce(0) { $0 + $1.carbs }
            }
    }

    public var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 15) {
                        Spacer()
                        
                        VStack {
                            Text(selectedDate, formatter: dateFormatter)
                                .font(Font.custom("Inter", size: 24))
                                .bold()
                                .foregroundColor(.black)
                            
                            Text("Total Carbs")
                                .font(Font.custom("Inter", size: 40))
                                .bold()
                                .foregroundColor(.black)
                            
                            Text("\(Int(loggedCarbs))g")
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
                        
                        mealSection(title: "Breakfast", selectedDate: selectedDate)
                        mealSection(title: "Lunch", selectedDate: selectedDate)
                        mealSection(title: "Dinner", selectedDate: selectedDate)
                        mealSection(title: "Snack", selectedDate: selectedDate)
                        
                        Spacer()
                    }
                }
            }
        }
    }

    private func mealSection(title: String, selectedDate: Date) -> some View {
        let meals = mealLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) && $0.mealName == title }
        let totalCarbs = meals.reduce(0) { $0 + $1.foods.reduce(0) { $0 + $1.carbs } }
        return NavigationLink(destination: MealLogView(mealName: title, selectedDate: selectedDate)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.custom("Inter", size: 30))
                    .bold()
                    .foregroundColor(.black)
                
                Text("Carbs: \(Int(totalCarbs))g")
                    .font(Font.custom("Inter", size: 22))
                    .foregroundColor(.gray)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.8))
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
    CarbHomeView(selectedDate: Date())
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self]) // Provide a preview container
}
