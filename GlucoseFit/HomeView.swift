//
//  HomeView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/31/25.
//

import SwiftUI

public struct HomeView: View {
    public var body: some View {
        VStack {
            Spacer()

            // Main Calories Section
            VStack {
                Text("Calories")
                    .font(Font.custom("Inter", size: 50))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text("2000") // Example calorie count
                    .font(Font.custom("Inter", size: 38))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: 144)

            Spacer()

            // Meal Sections
            mealSection(title: "Breakfast", calories: "500", carbs: "50g")
            Spacer()
            mealSection(title: "Lunch", calories: "700", carbs: "70g")
            Spacer()
            mealSection(title: "Dinner", calories: "600", carbs: "60g")
            Spacer()
            mealSection(title: "Snack", calories: "200", carbs: "20g")
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
        ).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}

// Helper function to create each meal section
private func mealSection(title: String, calories: String, carbs: String) -> some View {
    VStack(alignment: .leading, spacing: 10) { // Align contents to the left
        Text(title)
            .font(Font.custom("Inter", size: 48))
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
    HomeView()
}
