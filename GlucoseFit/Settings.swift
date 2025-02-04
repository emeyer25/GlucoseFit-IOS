//
//  Settings.swift
//  GlucoseFit
//

import Foundation

class Settings: ObservableObject {
    static let shared = Settings() // Singleton instance for app-wide settings

    // General Settings
    @Published var weight: String {
        didSet { UserDefaults.standard.set(weight, forKey: "weight") }
    }

    @Published var heightFeet: String {
        didSet { UserDefaults.standard.set(heightFeet, forKey: "heightFeet") }
    }

    @Published var heightInches: String {
        didSet { UserDefaults.standard.set(heightInches, forKey: "heightInches") }
    }

    @Published var age: String {
        didSet { UserDefaults.standard.set(age, forKey: "age") }
    }

    @Published var gender: String {
        didSet { UserDefaults.standard.set(gender, forKey: "gender") }
    }

    @Published var activityLevel: String {
        didSet { UserDefaults.standard.set(activityLevel, forKey: "activityLevel") }
    }

    @Published var goal: String {
        didSet { UserDefaults.standard.set(goal, forKey: "goal") }
    }

    @Published var manualCalories: String {
        didSet { UserDefaults.standard.set(manualCalories, forKey: "manualCalories") }
    }

    // Insulin Settings
    @Published var insulinToCarbRatio: String {
        didSet { UserDefaults.standard.set(insulinToCarbRatio, forKey: "insulinToCarbRatio") }
    }

    @Published var correctionDose: String {
        didSet { UserDefaults.standard.set(correctionDose, forKey: "correctionDose") }
    }

    // Target Glucose Level for correction dose calculation
    @Published var targetGlucose: String {
        didSet { UserDefaults.standard.set(targetGlucose, forKey: "targetGlucose") }
    }

    // Holds the final calorie estimate (forces UI update)
    @Published var finalCalories: Double = 0.0 {
        didSet {
            objectWillChange.send() // Ensure UI updates when this value changes
        }
    }

    init() {
        // Load saved settings from UserDefaults
        self.weight = UserDefaults.standard.string(forKey: "weight") ?? ""
        self.heightFeet = UserDefaults.standard.string(forKey: "heightFeet") ?? ""
        self.heightInches = UserDefaults.standard.string(forKey: "heightInches") ?? ""
        self.age = UserDefaults.standard.string(forKey: "age") ?? ""
        self.gender = UserDefaults.standard.string(forKey: "gender") ?? "Male"
        self.activityLevel = UserDefaults.standard.string(forKey: "activityLevel") ?? "Sedentary"
        self.goal = UserDefaults.standard.string(forKey: "goal") ?? "Maintain Weight"
        self.manualCalories = UserDefaults.standard.string(forKey: "manualCalories") ?? ""
        self.insulinToCarbRatio = UserDefaults.standard.string(forKey: "insulinToCarbRatio") ?? ""
        self.correctionDose = UserDefaults.standard.string(forKey: "correctionDose") ?? ""
        self.targetGlucose = UserDefaults.standard.string(forKey: "targetGlucose") ?? "100" // Default target glucose

        // Update finalCalories initially
        self.finalCalories = recommendedCalories
    }

    // ✅ Calculate Recommended Calories using Mifflin-St Jeor Equation
    var recommendedCalories: Double {
        guard let weightLbs = Double(weight), weightLbs > 0,
              let heightFt = Double(heightFeet), heightFt >= 0,
              let heightIn = Double(heightInches), heightIn >= 0,
              let ageYears = Double(age), ageYears > 0 else {
            return 0.0 // Return 0 if any required field is missing
        }

        let weightKg = weightLbs * 0.453592
        let heightCm = ((heightFt * 12) + heightIn) * 2.54

        let bmr: Double = (gender == "Male")
            ? (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) + 5
            : (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) - 161

        let activityMultipliers: [String: Double] = [
            "Sedentary": 1.2,
            "Lightly Active": 1.375,
            "Active": 1.55,
            "Very Active": 1.725
        ]
        
        let tdee = bmr * (activityMultipliers[activityLevel] ?? 1.2)
        
        let adjustedCalories: Double
        switch goal {
        case "Gain 1lb a week":
            adjustedCalories = tdee + 500
        case "Lose 1lb a week":
            adjustedCalories = tdee - 500
        default:
            adjustedCalories = tdee
        }

        // ✅ Ensure UI updates
        DispatchQueue.main.async {
            self.finalCalories = adjustedCalories
        }

        return adjustedCalories
    }

    // ✅ Get final calorie intake (user can override recommendation)
    var computedFinalCalories: Double {
        return Double(manualCalories) ?? finalCalories
    }
}
