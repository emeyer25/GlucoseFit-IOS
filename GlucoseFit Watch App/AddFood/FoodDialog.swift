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
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var moveOn: () -> Void
    
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
                moveOn()
            }
        }
        .padding()
    }
}

#Preview {
    AddFoodNavigator()
}
