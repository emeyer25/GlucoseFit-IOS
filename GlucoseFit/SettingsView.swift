//
//  SettngsVew.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import SwiftUI

public struct SettingsView: View {
    public var body: some View {
        VStack {
            VStack {
                Text("Settings")
                    .font(Font.custom("Inter", size: 50))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            
            .frame(maxWidth: .infinity, maxHeight: 144)

            Spacer()

            // Meal Sections
            mealSection(title: "Weight", calories: "500", carbs: "50g")
            Spacer()
            mealSection(title: "Height", calories: "700", carbs: "70g")
            Spacer()
            mealSection(title: "Activity Level", calories: "600", carbs: "60g")
            Spacer()
            mealSection(title: "Goal", calories: "200", carbs: "20g")
            Spacer()
            mealSection(title: "Insulin to Carb Ratio", calories: "200", carbs: "20g")
            Spacer()
            mealSection(title: "Correction Dose", calories: "200", carbs: "20g")
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
                ).border(Color.black)
        
        }
    }

private func mealSection(title: String, calories: String, carbs: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text(title)
            .font(Font.custom("Inter", size: 30))
            .foregroundColor(.black)

        VStack(alignment: .leading, spacing: 5) {
            Text("Cals: \(calories)")
                .font(Font.custom("Inter", size: 30))
                .foregroundColor(.gray)

            Text("Carbs: \(carbs)")
                .font(Font.custom("Inter", size: 30))
    
                .foregroundColor(.gray)
        }
    }
}



#Preview {
    SettingsView()
}
