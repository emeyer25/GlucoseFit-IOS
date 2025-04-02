import SwiftUI
import SwiftData

public struct DoseCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = DoseCalculatorViewModel()
    @StateObject private var settings = Settings.shared

    @Query private var mealLogs: [MealLogEntry]
    @State private var selectedMeal: MealLogEntry?

    // Color definitions
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }

    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }

    private var buttonColor: Color {
        colorScheme == .dark ? Color.blue.opacity(0.8) : Color.blue
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : .gray
    }

    private var mealsToday: [MealLogEntry] {
        mealLogs.filter {
            !$0.foods.isEmpty &&
            Calendar.current.isDate($0.date, inSameDayAs: Date())
        }
    }

    public var body: some View {
        VStack {
            Text("Insulin Dose Calculator")
                .font(.title)
                .bold()
                .foregroundColor(textColor)
                .padding()

            // Current Time Settings Display
            VStack(alignment: .leading) {
                let currentSettings = settings.currentDoseSettings()
                Text("Current Settings")
                    .font(.headline)
                    .foregroundColor(textColor)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Insulin:Carb")
                            .font(.subheadline)
                            .foregroundColor(secondaryTextColor)
                        Text("1:\(currentSettings.insulinToCarbRatio)")
                            .font(.headline)
                            .foregroundColor(textColor)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Correction")
                            .font(.subheadline)
                            .foregroundColor(secondaryTextColor)
                        Text("1:\(currentSettings.correctionDose)")
                            .font(.headline)
                            .foregroundColor(textColor)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Target")
                            .font(.subheadline)
                            .foregroundColor(secondaryTextColor)
                        Text("\(currentSettings.targetGlucose) mg/dL")
                            .font(.headline)
                            .foregroundColor(textColor)
                    }
                }
            }
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)

            // Meal Picker
            VStack {
                Text("Select Meal")
                    .font(.title2)
                    .foregroundColor(textColor)

                Picker("Select Meal", selection: $selectedMeal) {
                    Text("None").tag(nil as MealLogEntry?)
                    ForEach(mealsToday, id: \.self) { meal in
                        Text(meal.mealName).tag(meal as MealLogEntry?)
                    }
                }
                .onChange(of: selectedMeal) { _, newMeal in
                    if let meal = newMeal {
                        let totalCarbs = meal.foods.reduce(0) { $0 + $1.carbs }
                        viewModel.carbs = String(format: "%.1f", totalCarbs)
                    } else {
                        viewModel.carbs = ""
                    }
                }
                .frame(maxWidth: .infinity)
                .background(buttonColor)
                .accentColor(.white)
                .cornerRadius(10)
                .padding()

                Text("Note: Empty meals will not be shown")
                    .font(.caption)
                    .foregroundColor(secondaryTextColor)
            }
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)

            // Calculator Card
            VStack(alignment: .leading, spacing: 15) {
                Text("Carbohydrates (g)")
                    .font(.headline)
                    .foregroundColor(textColor)

                TextField("Enter carbs", text: $viewModel.carbs)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .colorScheme(colorScheme)
                    .foregroundColor(textColor)

                Text("Glucose Level (mg/dL)")
                    .font(.headline)
                    .foregroundColor(textColor)

                TextField("Enter glucose", text: $viewModel.glucoseLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .colorScheme(colorScheme)
                    .foregroundColor(textColor)

                Button("Calculate Dose") {
                    viewModel.calculateDose(using: settings.currentDoseSettings())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(10)

                if viewModel.suggestedDose > 0 {
                    VStack {
                        Text("Suggested Insulin Dose")
                            .font(.headline)
                            .foregroundColor(textColor)
                            .padding(.top, 10)

                        Text("\(viewModel.suggestedDose, specifier: "%.1f") units")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(buttonColor)
                            .padding()
                            .background(cardBackgroundColor)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                        
                        if viewModel.correctionDose > 0 {
                            Text("Includes \(viewModel.correctionDose, specifier: "%.1f") units correction")
                                .font(.caption)
                                .foregroundColor(secondaryTextColor)
                        }
                    }
                }
            }
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: backgroundColor, location: 0.00),
                    Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)
        )
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Preview
#Preview {
    DoseCalculatorView()
        .preferredColorScheme(.dark)
        .modelContainer(for: [MealLogEntry.self, FoodItem.self])
}
