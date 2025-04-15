//
//  AddFoodNavigator.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//
import SwiftUI

enum Step {
    case selectMeal
    case setProperties
    case confirm
    case finish
}

struct AddFoodNavigator: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentStep = Step.setProperties
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: backgroundColor, location: 0.00),
                    Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                if (currentStep == .selectMeal) {
                    MealSelector()
                        .transition(.move(edge: .leading))
                }
                else if (currentStep == .setProperties) {
                    FoodDialog() {
                        withAnimation(.spring) {
                            currentStep = .confirm
                        }
                    }
                    .transition(.move(edge: .leading))
                }
                else if (currentStep == .confirm) {
                    Text("")
                        .transition(.move(edge: .leading))
                }
                else {
                    Text("")
                }
            }
        }
    }
}

#Preview {
    AddFoodNavigator()
}
