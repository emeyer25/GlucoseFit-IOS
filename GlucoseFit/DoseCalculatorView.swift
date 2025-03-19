import SwiftUI
import SwiftData

public struct DoseCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = DoseCalculatorViewModel()
    
    @Query private var mealLogs: [MealLogEntry]
    @State private var selectedMeal: MealLogEntry? = nil

    public var body: some View {
        VStack {
            Text("Insulin Dose Calculator")
                .font(.title)
                .bold()
                .padding()
            
            VStack {
                // Meal Selection
                Text("Select Meal")
                    .font(.title2)
                Picker("Select Meal", selection: $selectedMeal) {
                    Text("None").tag(nil as MealLogEntry?)
                    ForEach(mealLogs, id: \.self) { meal in
                        Text(meal.mealName).tag(meal as MealLogEntry?)
                    }
                }
                .onChange(of: selectedMeal) { _, newMeal in
                    if let meal = newMeal {
                        let totalCarbs = meal.foods.reduce(0) { $0 + $1.carbs }
                        viewModel.carbs = String(totalCarbs)
                    } else {
                        viewModel.carbs = ""
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .accentColor(.white)
                .cornerRadius(10)
                .padding()
                Text("Note: Empty meals will not be shown")
                    .font(.caption)
            }
            .padding()
            .background(Color.white.opacity(0.7))
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 15) {
                

                // Carbs Input
                Text("Carbohydrates (g)")
                    .font(.headline)
                TextField("Enter carbs", text: $viewModel.carbs)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                // Glucose Input
                Text("Glucose Level (mg/dL)")
                    .font(.headline)
                TextField("Enter glucose", text: $viewModel.glucoseLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                // Calculate Button
                Button("Calculate Dose") {
                    viewModel.calculateDose()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Display Suggested Dose
                Text("Suggested Insulin Dose")
                    .font(.headline)
                    .padding(.top, 10)
                Text("\(viewModel.suggestedDose, specifier: "%.1f") units")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white.opacity(0.7))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
        )
    }
}

#Preview {
    DoseCalculatorView()
}
