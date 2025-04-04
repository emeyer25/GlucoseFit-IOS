import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    var mealName: String? = nil
    var selectedDate: Date

    @Query private var mealLogs: [MealLogEntry]
    @Query private var savedFoods: [SavedFoodItem]
    @Query private var foodItems: [FoodItem]
    @Query private var insulinLogs: [InsulinLogEntry]

    @State private var showAddFoodView = false
    @State private var showSavedFoodsView = false
    @State private var insulinDose: String = ""

    // MARK: - Dynamic Colors
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

    private var mealsForSelectedDate: [MealLogEntry] {
        mealLogs.filter { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: selectedDate) &&
            (mealName == nil || entry.mealName == mealName)
        }
    }

    private var insulinLogsForSelectedDate: [InsulinLogEntry] {
        insulinLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var foodList: some View {
        VStack {
            if mealsForSelectedDate.isEmpty {
                Text("No meals logged for this day.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(mealsForSelectedDate, id: \.mealName) { mealLog in
                        Section(header: Text(mealLog.mealName).foregroundColor(textColor)) {
                            ForEach(mealLog.foods, id: \.name) { food in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(food.name)
                                            .font(.headline)
                                            .foregroundColor(textColor)
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
                .listStyle(InsetGroupedListStyle())
                .background(cardBackgroundColor)
            }
        }
        .frame(maxWidth: .infinity)
        .background(cardBackgroundColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }

    var body: some View {
        
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
                VStack(spacing: 20) {
                    Text(mealName == nil ?
                         "All Meals for \(selectedDate, formatter: dateFormatter)" :
                            "\(mealName!) for \(selectedDate, formatter: dateFormatter)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(textColor)
                    
                    foodList
                    
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
                        AddFoodView(onAdd: { newFood in
                            addFoodToMealLog(newFood)
                        }, onSave: { savedItem in
                            saveFoodToSavedFoods(savedItem)
                        })
                        .presentationDetents([.medium])
                    }
                    
                    Button(action: { showSavedFoodsView.toggle() }) {
                        Text("Add from Saved Foods")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $showSavedFoodsView) {
                        SavedFoodsView { selectedFood in
                            addFoodToMealLog(selectedFood)
                        }
                        .presentationDetents([.medium])
                    }
                    
                    // Insulin Logging Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Log Insulin Dose")
                            .font(.title2)
                            .bold()
                            .foregroundColor(textColor)
                            .padding(.horizontal)
                        HStack {
                            TextField("Enter units", text: $insulinDose)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                logInsulin()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Display logged insulin entries for the day
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Insulin Logs")
                                .font(.headline)
                                .foregroundColor(textColor)
                                .padding(.horizontal)
                            if insulinLogsForSelectedDate.isEmpty {
                                Text("No insulin logs for this day.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                List {
                                    ForEach(insulinLogsForSelectedDate, id: \.id) { log in
                                        HStack {
                                            Text("Units: \(log.units, specifier: "%.1f")")
                                            Spacer()
                                            Text(log.date, style: .time)
                                            Button(action: {
                                                deleteInsulinLog(log)
                                            }) {
                                                Image(systemName: "trash")
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            .foregroundColor(.red)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                }
                                .listStyle(InsetGroupedListStyle())
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .modelContext(modelContext)
        }
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

    // Now, the insulin log is simply added and shown in the list.
    private func logInsulin() {
        guard let units = Double(insulinDose) else {
            return
        }
        let insulinEntry = InsulinLogEntry(units: units, date: Date())
        modelContext.insert(insulinEntry)
        insulinDose = ""
    }
    
    private func deleteInsulinLog(_ log: InsulinLogEntry) {
        modelContext.delete(log)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
