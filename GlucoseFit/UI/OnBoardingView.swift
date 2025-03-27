import SwiftUI

public struct OnBoardingView: View {
    @State private var step = 0
    @Environment(\.colorScheme) private var colorScheme
    public var complete: () -> ()

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
                    MedicalDisclaimer(moveOn: { withAnimation {step += 1 } } )
                case 1:
                    WelcomeView(moveOn: { withAnimation { step += 1 } })
                case 2:
                    InitialConfigView(moveOn: { withAnimation { step += 1 } })
                case 3:
                    NextConfigView(moveOn: { withAnimation { step += 1 } })
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

struct MedicalDisclaimer: View {
    var moveOn: () -> ()
    @Environment(\.colorScheme) private var color
    
    var textColor: Color { color == .dark ? .white : .black }
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State var activateAcknowledge: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("!! Read Before Continuing !!")
                .font(.title)
            Text("GlucoseFit is intended for informational and educational purposes only. It does not provide medical advice, diagnosis, or treatment. The insulin dose calculator is a tool to help support decision-making, but it should not be used as a substitute for guidance from your healthcare provider.\n\nAlways consult with your doctor or diabetes care team before making any changes to your insulin regimen or treatment plan. Never disregard professional medical advice or delay seeking it because of information provided by this app.\n\nBy using GlucoseFit, you acknowledge that you understand and agree to these terms.")
            
            Button("I Understand and Agree") {
                moveOn()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(activateAcknowledge ? Color.blue : Color.gray)
            .cornerRadius(10)
            .foregroundColor(.white)
            .disabled(!activateAcknowledge)
            .onReceive(timer, perform: { what in
                withAnimation {
                    activateAcknowledge = true
                }
            })
        }
    }
}

struct WelcomeView: View {
    var moveOn: () -> ()
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
    }
}

struct InitialConfigView: View {
    @StateObject private var settings = Settings.shared
    var moveOn: () -> ()
    @State private var alert = false
    @Environment(\.colorScheme) private var colorScheme

    var textColor: Color { colorScheme == .dark ? .white : .black }

    var body: some View {
        VStack {
            Text("Let's get you set up!")
                .padding()
                .font(.title)
                .foregroundColor(textColor)

            VStack(alignment: .leading, spacing: 15) {
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
                            .frame(width: 60)
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

                Text("Activity Level")
                    .font(.headline)
                    .foregroundColor(textColor)
                Picker("Activity Level", selection: $settings.activityLevel) {
                    ForEach(Settings.activityLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Text("Goal")
                    .font(.headline)
                    .foregroundColor(textColor)
                Picker("Goal", selection: $settings.goal) {
                    ForEach(Settings.goals, id: \.self) { goal in
                        Text(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Button("Next") {
                    if settings.weight.isEmpty || settings.heightFeet.isEmpty || settings.heightInches.isEmpty || settings.age.isEmpty {
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
                    Alert(title: Text("Missing Settings"), message: Text("Make sure all fields are filled out"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct NextConfigView: View {
    var moveOn: () -> ()
    @StateObject private var settings = Settings.shared
    @State private var alert = false
    @Environment(\.colorScheme) private var colorScheme

    var textColor: Color { colorScheme == .dark ? .white : .black }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Now, let's get your dose ratios set up!")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
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
            }

            Button("Next") {
                if settings.correctionDose.isEmpty || settings.insulinToCarbRatio.isEmpty || settings.targetGlucose.isEmpty {
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
                Alert(title: Text("Missing Settings"), message: Text("Make sure all fields are filled out"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct CompletionView: View {
    var moveOn: () -> ()
    @Environment(\.colorScheme) private var colorScheme
    var textColor: Color { colorScheme == .dark ? .white : .black }

    var body: some View {
        VStack {
            Text("You're all set!")
                .font(.title)
                .frame(alignment: .center)
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
    }
}

#Preview {
    OnBoardingView(complete: {
        print("done")
    })
    .preferredColorScheme(.dark)

}
