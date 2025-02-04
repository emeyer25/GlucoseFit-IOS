//
//  DoseCalculator.swift
//  GlucoseFit
//

import Foundation

struct DoseCalculator {
    // Reference global settings
    let settings = Settings.shared

    func calculateDose(carbs: Double, glucose: Double) -> Double {
        guard let insulinToCarbRatio = Double(settings.insulinToCarbRatio),
              let correctionDoseFactor = Double(settings.correctionDose),
              let targetGlucose = Double(settings.targetGlucose) else {
            return 0.0 // Return 0 if settings are not valid numbers
        }

        let carbDose = carbs / insulinToCarbRatio
        let correctionDose = max(0, (glucose - targetGlucose) / correctionDoseFactor)

        return carbDose + correctionDose
    }
}

