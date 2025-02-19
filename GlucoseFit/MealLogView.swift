import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var mealName: String? = nil  //  Made optional to show all meals if nil
    var selectedDate: Date
    @Query private var mealLogs: [MealLogEntry] // Fetch all meal logs
    
    @State private var showAddFoodView = false
    
    // Filter meal logs based on date and mealName (if provided)
    var mealsForSelectedDate: [MealLogEntry] {
        mealLogs.filter { entry in
            let sameDay = Calendar.current.isDate(entry.date, inSameDayAs: selectedDate)
            if let mealName = mealName {
                return sameDay && entry.mealName == mealName
            } else {
                return sameDay
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(mealName == nil ? "All Meals for \(selectedDate, formatter: dateFormatter)" : "\(mealName!) for \(selectedDate, formatter: dateFormatter)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            if mealsForSelectedDate.isEmpty {
                Text("No meals logged for this day.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(mealsForSelectedDate, id: \.mealName) { mealLog in
                        Section(header: Text(mealLog.mealName)) {
                            ForEach(mealLog.foods, id: \.name) { food in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(food.name)
                                            .font(.headline)
                                        Text("\(food.carbs, specifier: "%.1f")g carbs, \(food.calories, specifier: "%.1f") cal")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: {
                                        removeFoodItem(food, from: mealLog)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Button(action: { showAddFoodView.toggle() }) {
                Text("Add Food")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showAddFoodView) {
                AddFoodView { newFood in
                    addFoodItem(newFood)
                }
            }
            
            Button(action: saveMealLog) {
                Text("Save Meal")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.02, y: 0.61),
            endPoint: UnitPoint(x: 1.01, y: 0.61)
        )
        .edgesIgnoringSafeArea(.all))
    }
    
    private func addFoodItem(_ food: FoodItem) {
        let mealLog = MealLogEntry(mealName: mealName ?? "Meal", foods: [food], date: selectedDate)
        modelContext.insert(mealLog)
    }
    
    private func removeFoodItem(_ food: FoodItem, from mealLog: MealLogEntry) {
        mealLog.foods.removeAll { $0.name == food.name }
    }
    
    private func saveMealLog() {
        dismiss()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
