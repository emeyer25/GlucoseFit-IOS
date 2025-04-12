import SwiftUI

public struct SettingsView: View {
    @StateObject private var settings = Settings.shared
    @Environment(\.colorScheme) private var colorScheme

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

                        VStack(alignment: .leading, spacing: 15) {
                            Toggle("Enable Carb-Only View", isOn: $settings.isCarbOnlyViewEnabled)
                                .font(.headline)
                                .foregroundColor(textColor)
                                .padding(.vertical, 10)
                                .tint(.blue)
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

                        VStack {
                            SettingInputField(title: "Set Goal Calories", value: $settings.manualCalories)
                        }
                        .padding()
                        
                        NavigationLink(destination: ExportView()) {
                            HStack {
                                Text("Export your logs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                        }
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
