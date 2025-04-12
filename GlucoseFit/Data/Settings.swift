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

    // Manual Calorie Goal
    @Published var manualCalories: String {
        didSet {
            UserDefaults.standard.set(manualCalories, forKey: "manualCalories")
        }
    }

    init() {
        self.insulinToCarbRatio = UserDefaults.standard.string(forKey: "insulinToCarbRatio") ?? ""
        self.correctionDose = UserDefaults.standard.string(forKey: "correctionDose") ?? ""
        self.targetGlucose = UserDefaults.standard.string(forKey: "targetGlucose") ?? "100"
        self.isCarbOnlyViewEnabled = UserDefaults.standard.bool(forKey: "isCarbOnlyViewEnabled")
        self.manualCalories = UserDefaults.standard.string(forKey: "manualCalories") ?? ""
        
        // Initialize time-based dose settings
        if let data = UserDefaults.standard.data(forKey: "timeBasedDoseSettings"),
           let decoded = try? JSONDecoder().decode([TimeBasedDoseSetting].self, from: data) {
            self.timeBasedDoseSettings = decoded.sorted { $0.startTime < $1.startTime }
        } else {
            self.timeBasedDoseSettings = []
        }
    }

    func currentDoseSettings(time: Date = Date()) -> TimeBasedDoseSetting {
        let calendar = Calendar.current
        let currentTime = calendar.dateComponents([.hour, .minute], from: time)
        
        let activeSettings = timeBasedDoseSettings.filter { setting in
            let settingTime = calendar.dateComponents([.hour, .minute], from: setting.startTime)
            return (settingTime.hour! < currentTime.hour!) ||
                   (settingTime.hour! == currentTime.hour! && settingTime.minute! <= currentTime.minute!)
        }
        
        if let latestSetting = activeSettings.last {
            return latestSetting
        }
        
        return timeBasedDoseSettings.last ?? TimeBasedDoseSetting(
            startTime: calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!,
            insulinToCarbRatio: "7",
            correctionDose: "50",
            targetGlucose: "100"
        )
    }
    
    func addTimeBasedSetting(_ setting: TimeBasedDoseSetting) {
        timeBasedDoseSettings.append(setting)
        timeBasedDoseSettings.sort { $0.startTime < $1.startTime }
    }
    
    func removeTimeBasedSetting(at index: Int) {
        timeBasedDoseSettings.remove(at: index)
    }
}
