//
//  OnBoardingView.swift
//  GlucoseFit
//
//  Created by Ian Burall on 3/12/25.
//
import SwiftUI

public struct OnBoardingView: View {
    @State private var step = 1
    public var complete: () -> ()
    public var body: some View {
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
            VStack {
                if step == 1 {
                    WelcomeView(moveOn: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            step += 1
                        }
                    })
                }
                else if step == 2 {
                    InitialConfigView(moveOn: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            step += 1
                        }
                    })
                }
                else if step == 3 {
                    NextConfigView(moveOn: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            step += 1
                        }
                    })
                }
                else if step == 4 {
                    CompletionView(moveOn : {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            complete()
                        }
                    })
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.7)) // Keeps settings container readable
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct WelcomeView: View {
    var moveOn : () -> ()
    @StateObject private var settings = Settings.shared
    
    @State public var done = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome to GlucoseFit!")
                .padding()
                .font(.title)
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
    var moveOn : () -> ()
    @State private var alert = false
    
    var body: some View {
        VStack {
            Text("Let's get you set up!")
                .padding()
                .font(.title)
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
                
                Text("Gender")
                    .font(.headline)
                // Gender Picker
                Picker("Gender", selection: $settings.gender) {
                    ForEach(Settings.genderOptions, id: \.self) { gender in
                        Text(gender)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Text("Activity Level")
                    .font(.headline)
                // Activity Level Picker
                Picker("Activity Level", selection: $settings.activityLevel) {
                    ForEach(Settings.activityLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Text("Goal")
                    .font(.headline)
                // Goal Picker
                Picker("Goal", selection: $settings.goal) {
                    ForEach(Settings.goals, id: \.self) { goal in
                        Text(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Button("Next") {
                    if $settings.weight.wrappedValue.isEmpty || $settings.heightFeet.wrappedValue.isEmpty || $settings.heightInches.wrappedValue.isEmpty ||
                        $settings.age.wrappedValue.isEmpty {
                        alert = true
                    }
                    else {
                        moveOn()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Misssing Settings"), message: Text("Make sure all fields are filled out"), dismissButton: .default(Text("Ok")))
                }
                
            }
        }
    }
}

struct NextConfigView: View {
    var moveOn : () -> ()
    @StateObject private var settings = Settings.shared
    @State private var alert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Now, let's get your dose ratios set up!")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
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
            
            Button("Next") {
                if $settings.correctionDose.wrappedValue.isEmpty || $settings.insulinToCarbRatio.wrappedValue.isEmpty || $settings.targetGlucose.wrappedValue.isEmpty {
                    alert = true
                }
                else {
                    moveOn()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $alert) {
                Alert(title: Text("Misssing Settings"), message: Text("Make sure all fields are filled out"), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct CompletionView: View {
    var moveOn: () -> ()
    var body: some View {
        VStack {
            Text("You're all set!")
                .font(.title)
                .frame(alignment: .center)
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
}
