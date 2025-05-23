import SwiftUI

// MARK: - OnBoardingView

public struct OnBoardingView: View {
    @State private var step = 0
    @Environment(\.colorScheme) private var colorScheme
    public var complete: () -> Void
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }
    
    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: backgroundColor, location: 0),
                    .init(color: secondaryBackgroundColor, location: 1),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                switch step {
                case 0:
                    MedicalDisclaimer(moveOn: { withAnimation { step += 1 } })
                case 1:
                    WelcomeView(moveOn: { withAnimation { step += 1 } })
                case 2:
                    InitialConfigView(moveOn: { withAnimation { step += 1 } })
                case 3:
                    TimeBasedConfigView(moveOn: { withAnimation { step += 1 } })
                case 4:
                    CompletionView(moveOn: { withAnimation { complete() } })
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

// MARK: - Medical Disclaimer

struct MedicalDisclaimer: View {
    var moveOn: () -> Void
    @Environment(\.colorScheme) private var color
    
    var textColor: Color { color == .dark ? .white : .black }
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var activateAcknowledge: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Read Before Continuing")
                .font(.title)
                .foregroundColor(textColor)
            Text("GlucoseFit is intended for informational and educational purposes only. It does not provide medical advice, diagnosis, or treatment. Always consult with your doctor or diabetes care team before making any changes to your insulin regimen, diet, or treatment plan. Never disregard professional medical advice or delay seeking it because of information provided by this app. By using GlucoseFit, you acknowledge that you understand and agree to these terms.")
                .foregroundColor(textColor)
            
            Button("I Understand and Agree") {
                moveOn()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(activateAcknowledge ? Color.blue : Color.gray)
            .cornerRadius(10)
            .foregroundColor(.white)
            .disabled(!activateAcknowledge)
            .onReceive(timer) { _ in
                withAnimation { activateAcknowledge = true }
            }
        }
        .padding()
    }
}

// MARK: - Welcome View

struct WelcomeView: View {
    var moveOn: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var textColor: Color { colorScheme == .dark ? .white : .black }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome to GlucoseFit!")
                .padding()
                .font(.title)
                .foregroundColor(textColor)
            
            Button("Get Started") {
                moveOn()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// MARK: - Initial Config View (Only Manual Calories)

struct InitialConfigView: View {
    @StateObject private var settings = Settings.shared
    var moveOn: () -> Void
    @State private var alert = false
    @Environment(\.colorScheme) private var colorScheme
    
    var textColor: Color { colorScheme == .dark ? .white : .black }
    
    var body: some View {
        VStack {
            Text("Let's set your goal calories")
                .padding()
                .font(.title)
                .foregroundColor(textColor)
            
            VStack(alignment: .leading, spacing: 15) {
                SettingInputField(title: "Goal Calories", value: $settings.manualCalories)
                
                Button("Next") {
                    if settings.manualCalories.isEmpty {
                        alert = true
                    } else {
                        moveOn()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text("Missing Field"),
                        message: Text("Please enter your goal calories to continue."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .padding()
    }
}

// MARK: - Time-Based Config View

struct TimeBasedConfigView: View {
    var moveOn: () -> Void
    @StateObject private var settings = Settings.shared
    @State private var alert = false
    @State private var showingAddTimeSetting = false
    @State private var newSetting = TimeBasedDoseSetting(
        startTime: Date(),
        insulinToCarbRatio: "",
        correctionDose: "",
        targetGlucose: "100"
    )
    @Environment(\.colorScheme) private var colorScheme
    
    var textColor: Color { colorScheme == .dark ? .white : .black }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Set Time-Based Insulin Settings")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .foregroundColor(textColor)
            
            Text("You can set different insulin ratios for different times of day")
                .font(.subheadline)
                .foregroundColor(textColor)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                ForEach(settings.timeBasedDoseSettings.indices, id: \.self) { index in
                    TimeBasedDoseSettingView(
                        setting: $settings.timeBasedDoseSettings[index],
                        onDelete: {
                            settings.removeTimeBasedSetting(at: index)
                        }
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
                    .foregroundColor(Color.blue)
                }
                .padding(.top, 5)
            }
            
            Button("Continue") {
                if settings.timeBasedDoseSettings.isEmpty {
                    alert = true
                } else {
                    moveOn()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $alert) {
                Alert(title: Text("No Time Settings"), message: Text("Please add at least one time-based setting"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
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

// MARK: - Completion View

struct CompletionView: View {
    var moveOn: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    var textColor: Color { colorScheme == .dark ? .white : .black }
    
    var body: some View {
        VStack {
            Text("You're all set!")
                .font(.title)
                .foregroundColor(textColor)
            Button("Let's go!") {
                moveOn()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// MARK: - Reusable Input Field

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

// MARK: - Time-Based Dose Setting Views

struct TimeBasedDoseSettingView: View {
    @Binding var setting: TimeBasedDoseSetting
    var onDelete: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
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

struct AddTimeBasedDoseSettingView: View {
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

// MARK: - Preview

#Preview {
    OnBoardingView(complete: {
        print("Onboarding complete")
    })
    .preferredColorScheme(.dark)
}
