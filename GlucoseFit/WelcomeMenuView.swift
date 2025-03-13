import SwiftUI

struct WelcomeMenuView: View {
    @AppStorage("hasCompletedSetup") private var hasCompletedSetup = false
    @StateObject private var settings = Settings.shared
    @Environment(\.dismiss) private var dismiss

    let genderOptions = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Lightly Active", "Active", "Very Active"]
    let goals = ["Gain 1lb a week", "Lose 1lb a week", "Maintain Weight"]

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    Text("Welcome!")
                        .font(.custom("Inter", size: 34))
                        .foregroundColor(.black)
                        .padding(.bottom, 10)

                    Text("Let's get started by setting up your profile.")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 15) {
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

                        // Insulin-to-Carb Ratio
                        VStack(alignment: .leading) {
                            Text("Insulin to Carb Ratio")
                                .font(.headline)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                TextField("", text: $settings.insulinToCarbRatio)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80)
                            }
                        }

                        // Correction Dose
                        VStack(alignment: .leading) {
                            Text("Correction Dose")
                                .font(.headline)
                            HStack {
                                Text("1:")
                                    .font(.headline)
                                TextField("", text: $settings.correctionDose)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80)
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
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: completeSetup) {
                        Text("Save and Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 20)
            }
        }
    }

    private func completeSetup() {
        hasCompletedSetup = true
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = UIHostingController(rootView: ContentView())
            window.makeKeyAndVisible()
        }
    }
}

#Preview {
    WelcomeMenuView()
}
