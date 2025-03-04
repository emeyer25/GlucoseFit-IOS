//
//  SavedFoodsView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 2/20/25.
//

import SwiftUI
import SwiftData


struct SavedFoodsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var savedFoods: [SavedFoodItem] // ✅ Now fetching only explicitly saved foods

    var onSelect: (FoodItem) -> Void

    var body: some View {
        List {
            ForEach(savedFoods, id: \.name) { savedFood in
                HStack {
                    VStack(alignment: .leading) {
                        Text(savedFood.name)
                            .font(.headline)
                        Text("\(savedFood.carbs, specifier: "%.1f")g carbs, \(savedFood.calories, specifier: "%.1f") cal")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        let foodCopy = FoodItem(name: savedFood.name, carbs: savedFood.carbs, calories: savedFood.calories)
                        onSelect(foodCopy) // ✅ Pass a copy, so it is not auto-saved
                        dismiss()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .onDelete(perform: deleteFood)
        }
        .navigationTitle("Saved Foods")
        .toolbar {
            EditButton()
        }
    }

    private func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let food = savedFoods[index]
            modelContext.delete(food) // ✅ Now properly deleting only SavedFoodItem
        }
    }
}
