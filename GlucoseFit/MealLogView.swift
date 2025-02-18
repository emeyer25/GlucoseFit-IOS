import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var mealName: String
    @Query private var mealLogs: [MealLogEntry] // Fetch all meal logs
    
    @State private var showAddFoodView = false
    
    // Filter meal logs to get the current meal's foods
    var currentMealFoods: [FoodItem] {
        mealLogs.first { $0.mealName == mealName }?.foods ?? []
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(mealName) Meal")
                .font(.largeTitle)
                .bold()
                .padding()
            
            if currentMealFoods.isEmpty {
                Text("No foods added yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(currentMealFoods, id: \.name) { food in
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
                                removeFoodItem(food)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
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
        if let mealLog = mealLogs.first(where: { $0.mealName == mealName }) {
            mealLog.foods.append(food)
        } else {
            let newMealLog = MealLogEntry(mealName: mealName, foods: [food], date: Date())
            modelContext.insert(newMealLog)
        }
    }
    
    private func removeFoodItem(_ food: FoodItem) {
        if let mealLog = mealLogs.first(where: { $0.mealName == mealName }) {
            mealLog.foods.removeAll { $0.name == food.name }
        }
    }
    
    private func saveMealLog() {
        dismiss()
    }
}
