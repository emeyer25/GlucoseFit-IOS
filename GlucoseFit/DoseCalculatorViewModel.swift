import Foundation

class DoseCalculatorViewModel: ObservableObject {
    @Published var selectedMeal: String = "Breakfast"
    @Published var customCarbs: String = ""
    @Published var glucoseLevel: String = ""
    
    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack", "Custom"]
    let carbPresets: [String: Int] = [
        "Breakfast": 45,
        "Lunch": 60,
        "Dinner": 85,
        "Snack": 1000
    ]
    
    private let doseCalculator = DoseCalculator(insulinToCarbRatio: 10, correctionDoseFactor: 50, targetGlucose: 100)

    var suggestedDose: Double {
        let carbs = selectedMeal == "Custom" ? Double(customCarbs) ?? 0 : Double(carbPresets[selectedMeal] ?? 0)
        let glucose = Double(glucoseLevel) ?? 100
        return doseCalculator.calculateDose(carbs: carbs, glucose: glucose)
    }
}
