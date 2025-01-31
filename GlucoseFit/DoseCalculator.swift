//
//  DoseCalculator.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import Foundation

struct DoseCalculator {
    let insulinToCarbRatio: Double
    let correctionDoseFactor: Double
    let targetGlucose: Double
    
    func calculateDose(carbs: Double, glucose: Double) -> Double {
        let carbDose = carbs / insulinToCarbRatio
        let correctionDose = max(0, (glucose - targetGlucose) / correctionDoseFactor)
        return carbDose + correctionDose
    }
}
