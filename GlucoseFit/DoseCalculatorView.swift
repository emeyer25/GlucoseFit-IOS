//
//  DoseCalculatorView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import SwiftUI

public struct DoseCalculatorView: View {
    @StateObject private var viewModel = DoseCalculatorViewModel()

    public var body: some View {
        VStack {
            Text("Dose Calculator")
                .font(.custom("Inter", size: 40))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 20) {
                
                // Meal selection picker
                Text("Select Meal")
                    .font(.headline)
                Picker("Meal", selection: $viewModel.selectedMeal) {
                    ForEach(viewModel.mealOptions, id: \.self) { meal in
                        Text(meal)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                // Carbs input
                if viewModel.selectedMeal == "Custom" {
                    Text("Enter Carbohydrates (g)")
                        .font(.headline)
                    TextField("Carbs", text: $viewModel.customCarbs)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                } else {
                    Text("Carbohydrates: \(viewModel.carbPresets[viewModel.selectedMeal] ?? 0)g")
                        .font(.headline)
                }

                // Glucose input
                Text("Enter Glucose Level (mg/dL)")
                    .font(.headline)
                TextField("Glucose Level", text: $viewModel.glucoseLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                // Suggested Dose Display
                Text("Suggested Insulin Dose")
                    .font(.headline)
                    .padding(.top, 10)

                Text("\(viewModel.suggestedDose, specifier: "%.1f") units")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                
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

#Preview {
    DoseCalculatorView()
}
