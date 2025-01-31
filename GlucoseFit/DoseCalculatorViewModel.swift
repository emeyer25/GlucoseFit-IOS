
import Foundation

class DoseCalculatorViewModel: ObservableObject {
    @Published var selectedMeal: String = "Breakfast"
    @Published var customCarbs: String = ""
    @Published var glucoseLevel: String = ""
    
    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack", "Custom"]
    let carbPresets: [String: Int] = [
        "Breakfast": 45,
        "Lunch": 60,
        "Dinner": 65,
        "Snack": 20
    ]
    
    // Reference to SettingsViewModel (so it gets insulin ratio & correction dose)
    @Published var settings: SettingsViewModel
    
    init(settings: SettingsViewModel) {
        self.settings = settings
    }

    var suggestedDose: Double {
        let carbs = selectedMeal == "Custom" ? Double(customCarbs) ?? 0 : Double(carbPresets[selectedMeal] ?? 0)
        let glucose = Double(glucoseLevel) ?? settings.targetGlucose

        let carbDose = carbs / settings.insulinToCarbRatio
        let correctionDose = max(0, (glucose - settings.targetGlucose) / settings.correctionDoseFactor)
        
        return carbDose + correctionDose
    }
}
