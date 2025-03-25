import SwiftUI

public struct SettingsView: View {
    @StateObject private var settings = Settings.shared
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }

    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var accentColor: Color {
        colorScheme == .dark ? .blue.opacity(0.8) : .blue
    }

    private var successColor: Color {
        colorScheme == .dark ? .green.opacity(0.8) : .green
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: backgroundColor, location: 0.00),
                    Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    Text("Settings")
                        .font(.custom("Inter", size: 34))
                        .foregroundColor(textColor)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        Toggle("Enable Carb-Only View", isOn: $settings.isCarbOnlyViewEnabled)
                            .font(.headline)
                            .foregroundColor(textColor)
                            .padding(.vertical, 10)
                            .tint(accentColor)

                        SettingInputField(title: "Weight (lbs)", value: $settings.weight)

                        VStack(alignment: .leading) {
                            Text("Height")
                                .font(.headline)
                                .foregroundColor(textColor)
                            HStack {
                                TextField("Feet", text: $settings.heightFeet)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                    .colorScheme(colorScheme)
                                Text("ft")
                                    .foregroundColor(textColor)

                                TextField("Inches", text: $settings.heightInches)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                    .colorScheme(colorScheme)
                                Text("in")
                                    .foregroundColor(textColor)
                            }
                        }

                        SettingInputField(title: "Age", value: $settings.age)

                        Text("Gender")
                            .font(.headline)
                            .foregroundColor(textColor)
                        Picker("Gender", selection: $settings.gender) {
                            ForEach(Settings.genderOptions, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(textColor)

                        Text("Activity Level")
                            .font(.headline)
                            .foregroundColor(textColor)
                        Picker("Activity Level", selection: $settings.activityLevel) {
                            ForEach(Settings.activityLevels, id: \.self) { level in
                                Text(level)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(textColor)

                        Text("Goal")
                            .font(.headline)
                            .foregroundColor(textColor)
                        Picker("Goal", selection: $settings.goal) {
                            ForEach(Settings.goals, id: \.self) { goal in
                                Text(goal)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(textColor)

                        VStack(alignment: .leading) {
                            Text("Insulin to Carb Ratio")
                                .font(.headline)
                                .foregroundColor(textColor)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                    .foregroundColor(textColor)
                                TextField("", text: $settings.insulinToCarbRatio)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80)
                                    .colorScheme(colorScheme)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Correction Dose")
                                .font(.headline)
                                .foregroundColor(textColor)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                    .foregroundColor(textColor)
                                TextField("", text: $settings.correctionDose)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80)
                                    .colorScheme(colorScheme)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Target Glucose (mg/dL)")
                                .font(.headline)
                                .foregroundColor(textColor)
                            TextField("Enter Target Glucose", text: $settings.targetGlucose)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 120)
                                .colorScheme(colorScheme)
                        }

                        VStack {
                            Text("Recommended Daily Calories")
                                .font(.headline)
                                .foregroundColor(textColor)
                            Text("\(String(format: "%.0f", settings.recommendedCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(accentColor)
                        }

                        SettingInputField(title: "Set Custom Calories", value: $settings.manualCalories)

                        VStack {
                            Text("Final Daily Calories")
                                .font(.headline)
                                .foregroundColor(textColor)
                            Text("\(String(format: "%.0f", settings.finalCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(successColor)
                        }
                    }
                    .padding()
                    .background(cardBackgroundColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }

                    Spacer()
                }
            }
        }
    }
}

// Reusable Input Field with dark mode support
struct SettingInputField: View {
    var title: String
    @Binding var value: String
    @Environment(\.colorScheme) var colorScheme

    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
            TextField("Enter \(title)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .colorScheme(colorScheme)
                .foregroundColor(textColor)
        }
    }
}

#Preview {
    Group {
        SettingsView().preferredColorScheme(.dark)
    }
}
