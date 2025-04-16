//
//  AddFoodNavigator.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//
import SwiftUI
import WatchConnectivity

enum Step {
    case selectMeal
    case setProperties
    case confirm
}

struct AddFoodNavigator: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var currentStep = Step.selectMeal
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    @State private var selectedMealName: String = ""
    @State private var selectedMealDate: Date = Date.now
    @State private var foodName: String = ""
    @State private var foodCarbs: Double = 0.0
    @State private var foodCals: Double = 0.0
    
    var close: () -> Void
    
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
                    MealSelector() { name, date in
                        selectedMealName = name
                        selectedMealDate = date
                        withAnimation(.spring) {
                            currentStep = .setProperties
                        }
                    }
                    .transition(.move(edge: .leading))
                }
                else if (currentStep == .setProperties) {
                    FoodDialog() { name, carbs, cals in
                        foodName = name
                        foodCarbs = carbs
                        foodCals = cals
                        withAnimation(.spring) {
                            currentStep = .confirm
                        }
                    }
                    .transition(.move(edge: .leading))
                }
                else if (currentStep == .confirm) {
                    ConfirmDialog(mealName: selectedMealName, mealDate: selectedMealDate, foodName: foodName, foodCarbs: foodCarbs, foodCals: foodCals) {
                        let newFood = FoodItem(name: foodName, carbs: foodCarbs, calories: foodCals)
                        
                        do {
                            WCSession.default.sendMessage([
                                "name": "add",
                                "data": try JSONEncoder().encode(newFood),
                                "extMealName": selectedMealName,
                                "extMealDate": selectedMealDate
                            ], replyHandler: nil)
                        } catch {
                            print("Error encoding food item: \(error)")
                        }
                        close()
                    } cancel: {
                        currentStep = .selectMeal
                    }
                    .transition(.move(edge: .leading))
                }
            }
        }
        .onAppear {
            WatchManager.shared.checkStatus()
        }
    }
    
    
}

#Preview {
    AddFoodNavigator() {
        
    }
        .modelContainer(for: [FoodItem.self, MealLogEntry.self, InsulinLogEntry.self, SavedFoodItem.self])
}
