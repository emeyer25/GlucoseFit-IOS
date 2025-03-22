//
//  DoseCalculatorViewModel.swift
//  GlucoseFit
//

import Foundation

class DoseCalculatorViewModel: ObservableObject {
    @Published var carbs: String = ""
    @Published var glucoseLevel: String = ""
    @Published var suggestedDose: Double = 0.0

    private let doseCalculator = DoseCalculator() // Uses Settings.shared automatically

    func calculateDose() {
        guard let carbsValue = Double(carbs),
              let glucoseValue = Double(glucoseLevel) else {
            suggestedDose = 0.0
            return
        }

        suggestedDose = doseCalculator.calculateDose(carbs: carbsValue, glucose: glucoseValue)
    }
}

