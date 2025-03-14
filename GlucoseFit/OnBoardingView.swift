//
//  OnBoardingView.swift
//  GlucoseFit
//
//  Created by Ian Burall on 3/12/25.
//
import SwiftUI

public struct OnBoardingView: View {
    @State private var step = 1
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
                        step += 1
                    })
                }
                else if step == 2 {
                    InitialConfigView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.7)) // Keeps settings container readable
            .cornerRadius(10)
            .padding(.horizontal)
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
    
    var body: some View {
        VStack {
            Text("Let's get your information set up!")
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

        }
    }
}

#Preview {
    OnBoardingView()
}
