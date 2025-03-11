//
//  DoseCalculatorView.swift
//  GlucoseFit
//

import SwiftUI

public struct DoseCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = DoseCalculatorViewModel()
    

    public var body: some View {
        VStack {
            Text("Insulin Dose Calculator")
                .font(.title)
                .bold()
                .padding()

            VStack(alignment: .leading, spacing: 15) {
                // Carbs Input
                Text("Carbohydrates (g)")
                    .font(.headline)
                TextField("Enter carbs", text: $viewModel.carbs)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                // Glucose Input
                Text("Glucose Level (mg/dL)")
                    .font(.headline)
                TextField("Enter glucose", text: $viewModel.glucoseLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                // Calculate Button
                Button("Calculate Dose") {
                    viewModel.calculateDose()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Display Suggested Dose
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
    }
}

#Preview {
    DoseCalculatorView()
}
