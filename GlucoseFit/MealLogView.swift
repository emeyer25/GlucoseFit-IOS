import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    var mealName: String? = nil
    var selectedDate: Date

    @Query private var mealLogs: [MealLogEntry]
    @Query private var savedFoods: [SavedFoodItem]
    @Query private var foodItems: [FoodItem]


    @State private var showAddFoodView = false
    @State private var showSavedFoodsView = false

    var mealsForSelectedDate: [MealLogEntry] {
        mealLogs.filter { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: selectedDate) &&
            (mealName == nil || entry.mealName == mealName)
        }
    }
    
    var foodList: some View {
        VStack {
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
                                        Text(food.name).font(.headline)
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
                                            .padding(.trailing, 10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        saveFoodToSavedFoods(food)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .contentShape(Rectangle())
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.7))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    var body: some View {
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

            VStack(spacing: 20) {
                Text(mealName == nil ? "All Meals for \(selectedDate, formatter: dateFormatter)" : "\(mealName!) for \(selectedDate, formatter: dateFormatter)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                foodList

                Button(action: { showAddFoodView.toggle() }) {
                    Text("Add Food")
                        .font(.title2).bold().foregroundColor(.white)
                        .padding().frame(maxWidth: .infinity)
                        .background(Color.green).cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showAddFoodView) {
                    AddFoodView(onAdd: {
                        newFood in addFoodToMealLog(newFood)
                    }, onSave: {
                        savedItem in
                        saveFoodToSavedFoods(savedItem)
                    })
                }

                Button(action: { showSavedFoodsView.toggle() }) {
                    Text("Add from Saved Foods")
                        .font(.title2).bold().foregroundColor(.white)
                        .padding().frame(maxWidth: .infinity)
                        .background(Color.orange).cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showSavedFoodsView) {
                    SavedFoodsView { selectedFood in addFoodToMealLog(selectedFood) }
                }

                Spacer()
            }
            .padding()
        }
        .modelContext(modelContext)
    }

    private func addFoodToMealLog(_ food: FoodItem) {
        let foodCopy = FoodItem(name: food.name, carbs: food.carbs, calories: food.calories)

        if let existingMealLog = mealsForSelectedDate.first(where: { $0.mealName == mealName }) {
            existingMealLog.foods.append(foodCopy)
        } else {
            let mealLog = MealLogEntry(mealName: mealName ?? "Meal", foods: [foodCopy], date: selectedDate)
            modelContext.insert(mealLog)
        }
    }

    private func removeFoodItem(_ food: FoodItem, from mealLog: MealLogEntry) {
        mealLog.foods.removeAll { $0.name == food.name }
    }

    private func saveFoodToSavedFoods(_ food: FoodItem) {
        let savedFood = SavedFoodItem(name: food.name, carbs: food.carbs, calories: food.calories)
        
        if !savedFoods.contains(where: { $0.name == savedFood.name && $0.carbs == savedFood.carbs && $0.calories == savedFood.calories }) {
            modelContext.insert(savedFood)
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
