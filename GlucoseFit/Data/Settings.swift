import Foundation

struct TimeBasedDoseSetting: Codable, Hashable {
    var startTime: Date
    var insulinToCarbRatio: String
    var correctionDose: String
    var targetGlucose: String
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
}

class Settings: ObservableObject {
    static let shared = Settings()

    // General Settings
    @Published var weight: String {
        didSet {
            UserDefaults.standard.set(weight, forKey: "weight")
            updateFinalCalories()
        }
    }

    @Published var heightFeet: String {
        didSet {
            UserDefaults.standard.set(heightFeet, forKey: "heightFeet")
            updateFinalCalories()
        }
    }

    @Published var heightInches: String {
        didSet {
            UserDefaults.standard.set(heightInches, forKey: "heightInches")
            updateFinalCalories()
        }
    }

    @Published var age: String {
        didSet {
            UserDefaults.standard.set(age, forKey: "age")
            updateFinalCalories()
        }
    }

    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
            updateFinalCalories()
        }
    }
    
    public static var genderOptions = ["Male", "Female"]

    @Published var activityLevel: String {
        didSet {
            UserDefaults.standard.set(activityLevel, forKey: "activityLevel")
            updateFinalCalories()
        }
    }
    
    public static var activityLevels = ["Sedentary", "Lightly Active", "Active", "Very Active"]

    @Published var goal: String {
        didSet {
            UserDefaults.standard.set(goal, forKey: "goal")
            updateFinalCalories()
        }
    }
    
    public static var goals = ["Gain 1lb a week", "Lose 1lb a week", "Maintain Weight"]

    @Published var manualCalories: String {
        didSet {
            UserDefaults.standard.set(manualCalories, forKey: "manualCalories")
            updateFinalCalories()
        }
    }

    // Insulin Settings
    @Published var timeBasedDoseSettings: [TimeBasedDoseSetting] {
        didSet {
            if let encoded = try? JSONEncoder().encode(timeBasedDoseSettings) {
                UserDefaults.standard.set(encoded, forKey: "timeBasedDoseSettings")
            }
        }
    }
    
    // Legacy insulin settings (for backward compatibility)
    @Published var insulinToCarbRatio: String {
        didSet { UserDefaults.standard.set(insulinToCarbRatio, forKey: "insulinToCarbRatio") }
    }

    @Published var correctionDose: String {
        didSet { UserDefaults.standard.set(correctionDose, forKey: "correctionDose") }
    }

    @Published var targetGlucose: String {
        didSet { UserDefaults.standard.set(targetGlucose, forKey: "targetGlucose") }
    }

    // Carb-Only View Setting
    @Published var isCarbOnlyViewEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isCarbOnlyViewEnabled, forKey: "isCarbOnlyViewEnabled")
        }
    }

    @Published var finalCalories: Double = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }

    init() {
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
        self.targetGlucose = UserDefaults.standard.string(forKey: "targetGlucose") ?? "100"
        self.isCarbOnlyViewEnabled = UserDefaults.standard.bool(forKey: "isCarbOnlyViewEnabled")
        
        // Initialize time-based dose settings
        if let data = UserDefaults.standard.data(forKey: "timeBasedDoseSettings"),
           let decoded = try? JSONDecoder().decode([TimeBasedDoseSetting].self, from: data) {
            self.timeBasedDoseSettings = decoded.sorted { $0.startTime < $1.startTime }
        } else {
            // Default settings if none exist
            let calendar = Calendar.current
           
            
            self.timeBasedDoseSettings = [
            ]
            
           
        }

        self.finalCalories = computedFinalCalories
    }

    private func updateFinalCalories() {
        self.finalCalories = computedFinalCalories
    }

    // Calculate Recommended Calories using Mifflin-St Jeor Equation
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

        return adjustedCalories
    }

    var computedFinalCalories: Double {
        if let customCalories = Double(manualCalories), customCalories > 0 {
            return customCalories
        } else {
            return recommendedCalories
        }
    }
    
    // Get current dose settings based on time
    func currentDoseSettings(for time: Date = Date()) -> TimeBasedDoseSetting {
        let calendar = Calendar.current
        let currentTime = calendar.dateComponents([.hour, .minute], from: time)
        
        // Filter settings that are before or equal to current time, then get the latest one
        let activeSettings = timeBasedDoseSettings.filter { setting in
            let settingTime = calendar.dateComponents([.hour, .minute], from: setting.startTime)
            return (settingTime.hour! < currentTime.hour!) ||
                   (settingTime.hour! == currentTime.hour! && settingTime.minute! <= currentTime.minute!)
        }
        
        // If we have active settings, return the latest one
        if let latestSetting = activeSettings.last {
            return latestSetting
        }
        
        // If no active settings (current time is before all settings), return the last setting of the day
        return timeBasedDoseSettings.last ?? TimeBasedDoseSetting(
            startTime: calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!,
            insulinToCarbRatio: "7",
            correctionDose: "50",
            targetGlucose: "100"
        )
    }
    
    // Add a new time-based setting
    func addTimeBasedSetting(_ setting: TimeBasedDoseSetting) {
        timeBasedDoseSettings.append(setting)
        timeBasedDoseSettings.sort { $0.startTime < $1.startTime }
    }
    
    // Remove a time-based setting
    func removeTimeBasedSetting(at index: Int) {
        timeBasedDoseSettings.remove(at: index)
    }
}
