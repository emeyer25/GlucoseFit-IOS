//
//  SettingsView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import SwiftUI

public struct SettingsView: View {
    @State private var weight: String = ""
    @State private var heightFeet: String = ""
    @State private var heightInches: String = ""
    @State private var insulinToCarbRatio: String = ""
    @State private var correctionDose: String = ""
    
    @State private var activityLevel: String = "Sedentary"
    @State private var goal: String = "Maintain Weight"
    
    let activityLevels = ["Sedentary", "Lightly Active", "Active", "Very Active"]
    let goals = ["Gain 1lb a week", "Lose 1lb a week", "Maintain Weight"]
    
    public var body: some View {
        VStack {
            Text("Settings")
                .font(.custom("Inter", size: 50))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                
                SettingInputField(title: "Weight (lbs)", value: $weight)
                
                VStack(alignment: .leading) {
                    Text("Height")
                        .font(.headline)
                    HStack {
                        TextField("Feet", text: $heightFeet)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        Text("ft")
                        
                        TextField("Inches", text: $heightInches)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        Text("in")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Insulin to Carb Ratio")
                        .font(.headline)
                    HStack {
                        Text("1:")
                        TextField("Enter ratio", text: $insulinToCarbRatio)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Correction Dose")
                        .font(.headline)
                    HStack {
                        Text("1:")
                        TextField("Enter dose", text: $correctionDose)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
                // New Section Header
                Text("Lifestyle Settings")
                    .font(.headline)
                    .padding(.top, 10)
                
                Picker("Activity Level", selection: $activityLevel) {
                    ForEach(activityLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Goal", selection: $goal) {
                    ForEach(goals, id: \.self) { goal in
                        Text(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
            }
            .padding()
            .background(Color.white.opacity(0.7))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
        )
        .border(Color.black)
    }
}

struct SettingInputField: View {
    var title: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title.lowercased())", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    SettingsView()
}
