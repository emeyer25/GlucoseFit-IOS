//
//  FoodDialog.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//

import SwiftUI

struct FoodDialog: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var name = ""
    @State private var carbs = ""
    @State private var calories = ""
    @State private var emptyAlert = false
    @State private var numberAlert = false
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var moveOn: (String, Double, Double) -> Void
    
    var body: some View {
        VStack {
            Text("Add a food item")
                .font(.headline)
                .foregroundColor(textColor)
            TextField("Name", text: $name)
            HStack {
                TextField("Carbs", text: $carbs)
                TextField("Calories", text: $calories)
            }
            Button("Next") {
                confirm()
            }
        }
        .padding()
        .alert("Missing Fields", isPresented: $emptyAlert) {
            Button("Ok") {
                emptyAlert = false
            }
        } message: {
            Text("Ensure all fields are filled out")
        }
        .alert("Improper formatting", isPresented: $numberAlert) {
            Button("Ok") {
                emptyAlert = false
            }
        } message: {
            Text("Ensure carbs and calories are numbers")
        }
    }
    
    private func confirm() {
        if (carbs.isEmpty || calories.isEmpty || name.isEmpty) {
            emptyAlert = true
            return
        }
        guard let carbsValue = Double(carbs), let caloriesValue = Double(calories) else {
            numberAlert = true
            return
        }
        moveOn(name, carbsValue, caloriesValue)
    }
}

#Preview {
    AddFoodNavigator() {
        
    }
}
