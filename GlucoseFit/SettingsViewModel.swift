//
//  SettingsViewModel.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var insulinToCarbRatio: Double = 10 // Example: 1 unit per 10g carbs
    @Published var correctionDoseFactor: Double = 50 // Example: 1 unit per 50mg/dL above target
    @Published var targetGlucose: Double = 100 // Example target glucose level
    
    @Published var weight: String = ""
    @Published var heightFeet: String = ""
    @Published var heightInches: String = ""
    
    // Function to update values (e.g., when user saves settings)
    func updateSettings(insulinRatio: Double, correctionFactor: Double, target: Double) {
        self.insulinToCarbRatio = insulinRatio
        self.correctionDoseFactor = correctionFactor
        self.targetGlucose = target
    }
}
