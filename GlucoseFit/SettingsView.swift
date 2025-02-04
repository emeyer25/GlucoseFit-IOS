//
//  SettingsView.swift
//  GlucoseFit
//

import SwiftUI

public struct SettingsView: View {
    @StateObject private var settings = Settings.shared

    let genderOptions = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Lightly Active", "Active", "Very Active"]
    let goals = ["Gain 1lb a week", "Lose 1lb a week", "Maintain Weight"]

    public var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all) // Extend background to cover full screen

            ScrollView {
                VStack {
                    Text("Settings")
                        .font(.custom("Inter", size: 34)) // Reduced font size
                        .foregroundColor(.black)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 15) { // Reduced spacing
                        // Weight Input
                        SettingInputField(title: "Weight (lbs)", value: $settings.weight)

                        // Height Input
                        VStack(alignment: .leading) {
                            Text("Height")
                                .font(.headline)
                            HStack {
                                TextField("Feet", text: $settings.heightFeet)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                Text("ft")

                                TextField("Inches", text: $settings.heightInches)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                Text("in")
                            }
                        }

                        SettingInputField(title: "Age", value: $settings.age)

                        // Gender Picker
                        Picker("Gender", selection: $settings.gender) {
                            ForEach(genderOptions, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        // Activity Level Picker
                        Picker("Activity Level", selection: $settings.activityLevel) {
                            ForEach(activityLevels, id: \.self) { level in
                                Text(level)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        // Goal Picker
                        Picker("Goal", selection: $settings.goal) {
                            ForEach(goals, id: \.self) { goal in
                                Text(goal)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        // Insulin-to-Carb Ratio (1: [Box])
                        VStack(alignment: .leading) {
                            Text("Insulin to Carb Ratio")
                                .font(.headline)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                TextField("", text: $settings.insulinToCarbRatio)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80) // Adjust width to align properly
                            }
                        }

                        // Correction Dose (1: [Box])
                        VStack(alignment: .leading) {
                            Text("Correction Dose")
                                .font(.headline)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                TextField("", text: $settings.correctionDose)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80) // Adjust width to align properly
                            }
                        }

                        // Target Glucose Input
                        VStack(alignment: .leading) {
                            Text("Target Glucose (mg/dL)")
                                .font(.headline)
                            TextField("Enter Target Glucose", text: $settings.targetGlucose)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 120)
                        }

                        // Display Recommended Calories
                        VStack {
                            Text("Recommended Daily Calories")
                                .font(.headline)
                            Text("\(String(format: "%.0f", settings.recommendedCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.blue)
                        }

                        // Manual Calorie Input
                        SettingInputField(title: "Set Custom Calories", value: $settings.manualCalories)

                        // Display Final Calories
                        VStack {
                            Text("Final Daily Calories")
                                .font(.headline)
                            Text("\(String(format: "%.0f", settings.finalCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7)) // Keeps settings container readable
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 20) // Added top padding
            }
        }
    }
}

// Reusable Input Field
struct SettingInputField: View {
    var title: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    SettingsView()
}
