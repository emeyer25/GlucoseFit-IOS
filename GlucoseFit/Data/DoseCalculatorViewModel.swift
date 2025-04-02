//
//  DoseCalculatorViewModel.swift
//  GlucoseFit
//

import Foundation

class DoseCalculatorViewModel: ObservableObject {
    @Published var carbs: String = ""
    @Published var glucoseLevel: String = ""
    @Published var suggestedDose: Double = 0
    @Published var correctionDose: Double = 0
    
    func calculateDose(using settings: TimeBasedDoseSetting) {
        guard let carbsValue = Double(carbs),
              let glucoseValue = Double(glucoseLevel),
              let insulinToCarbRatio = Double(settings.insulinToCarbRatio),
              let correctionFactor = Double(settings.correctionDose),
              let targetGlucose = Double(settings.targetGlucose) else {
            suggestedDose = 0
            correctionDose = 0
            return
        }
        
        // Calculate meal dose
        let mealDose = carbsValue / insulinToCarbRatio
        
        // Calculate correction dose
        let glucoseDifference = glucoseValue - targetGlucose
        correctionDose = glucoseDifference > 0 ? glucoseDifference / correctionFactor : 0
        
        // Total suggested dose
        suggestedDose = mealDose + correctionDose
        
        // Round to nearest 0.5 units
        suggestedDose = round(suggestedDose * 2) / 2
        correctionDose = round(correctionDose * 2) / 2
    }
}

