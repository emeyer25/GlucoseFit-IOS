import SwiftUI

public struct SettingsView: View {
    @StateObject private var settings = Settings.shared
    @Environment(\.colorScheme) private var colorScheme

    // Local state for managing the add time setting sheet.
    @State private var showingAddTimeSetting = false
    @State private var newSetting = TimeBasedDoseSetting(
        startTime: Date(),
        insulinToCarbRatio: "",
        correctionDose: "",
        targetGlucose: "100"
    )

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.18, green: 0.23, blue: 0.28)
            : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.25, green: 0.3, blue: 0.35)
            : Color(red: 0.6, green: 0.89, blue: 0.75)
    }

    private var cardBackgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.25, green: 0.25, blue: 0.3)
            : Color.white.opacity(0.7)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    struct SettingInputField: View {
        var title: String
        @Binding var value: String
        @Environment(\.colorScheme) private var colorScheme

        var textColor: Color { colorScheme == .dark ? .white : .black }

        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(textColor)
                TextField("Enter \(title)", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .foregroundColor(textColor)
            }
        }
    }

    public var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: backgroundColor, location: 0.00),
                        Gradient.Stop(color: secondaryBackgroundColor, location: 1.00)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Settings")
                            .font(.title)
                            .bold()
                            .foregroundColor(textColor)
                            .padding()
                        // General Settings Section
                        VStack(alignment: .leading, spacing: 15) {
                            Toggle("Enable Carb-Only View", isOn: $settings.isCarbOnlyViewEnabled)
                                .font(.headline)
                                .foregroundColor(textColor)
                                .padding(.vertical, 10)
                                .tint(.blue)

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
                                    Text("ft")
                                        .foregroundColor(textColor)
                                    TextField("Inches", text: $settings.heightInches)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .frame(width: 65)
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
                        }
                        .padding()

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Time-Based Insulin Dose Settings")
                                .font(.headline)
                                .foregroundColor(textColor)

                            ForEach(settings.timeBasedDoseSettings.indices, id: \.self) { index in
                                TimeBasedDoseSettingView(
                                    setting: $settings.timeBasedDoseSettings[index],
                                    onDelete: { settings.removeTimeBasedSetting(at: index) }
                                )
                                .padding(.vertical, 5)
                            }

                            Button(action: {
                                newSetting = TimeBasedDoseSetting(
                                    startTime: Date(),
                                    insulinToCarbRatio: settings.insulinToCarbRatio,
                                    correctionDose: settings.correctionDose,
                                    targetGlucose: settings.targetGlucose
                                )
                                showingAddTimeSetting = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Time Setting")
                                }
                                .foregroundColor(.blue)
                            }
                            .padding(.top, 5)
                        }
                        .padding()

                        // Calories Section
                        VStack {
                            Text("Recommended Daily Calories")
                                .font(.headline)
                                .foregroundColor(textColor)
                            Text("\(String(format: "%.0f", settings.recommendedCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.blue)
                        }
                        .padding()

                        SettingInputField(title: "Set Custom Calories", value: $settings.manualCalories)
                            

                        VStack {
                            Text("Final Daily Calories")
                                .font(.headline)
                                .foregroundColor(textColor)
                            Text("\(String(format: "%.0f", settings.finalCalories)) kcal")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)
                        }
                        .padding()
                    }
                    .background(cardBackgroundColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil, from: nil, for: nil)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTimeSetting) {
                NavigationView {
                    AddTimeBasedDoseSettingView(
                        setting: $newSetting,
                        isPresented: $showingAddTimeSetting,
                        onSave: {
                            settings.addTimeBasedSetting(newSetting)
                        }
                    )
                }
            }
        }
    }
}

struct TimeBasedDoseSettingsView: View {
    @Binding var setting: TimeBasedDoseSetting
    var onDelete: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Time: \(setting.timeString)")
                Text("Ratio: 1: \(setting.insulinToCarbRatio)")
                Text("Correction: 1: \(setting.correctionDose)")
                Text("Target: \(setting.targetGlucose)")
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.1)))
    }
}

struct AddTimeBasedDoseSettingsView: View {
    @Binding var setting: TimeBasedDoseSetting
    @Binding var isPresented: Bool
    var onSave: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            DatePicker("Start Time", selection: $setting.startTime, displayedComponents: .hourAndMinute)
            Section(header: Text("Insulin Settings")) {
                HStack {
                    Text("1:")
                    TextField("Insulin to Carb Ratio", text: $setting.insulinToCarbRatio)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("1:")
                    TextField("Correction Dose", text: $setting.correctionDose)
                        .keyboardType(.decimalPad)
                }
                TextField("Target Glucose", text: $setting.targetGlucose)
                    .keyboardType(.numberPad)
            }
            Button("Save") {
                onSave()
                isPresented = false
            }
        }
        .navigationBarTitle("Add Time Setting", displayMode: .inline)
    }
}

#Preview {
    SettingsView().preferredColorScheme(.dark)
}
