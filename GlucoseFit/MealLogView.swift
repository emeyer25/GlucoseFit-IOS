//
//  MealLogView.swift
//  GlucoseFit
//

import SwiftUI
import SwiftData

struct MealLogView: View {
    var mealName: String
    @State private var newFoodName: String = ""
    @State private var newFoodCalories: String = ""
    @State private var newFoodCarbs: String = ""
    
    @Environment(\.modelContext) private var modelContext
    @Query private var mealLogs: [MealLogEntry]
    
    @State private var editingEntry: MealLogEntry?
    
    var filteredLogs: [MealLogEntry] {
        mealLogs.filter { $0.mealType == mealName }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("\(mealName) Log")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                List {
                    if filteredLogs.isEmpty {
                        Text("No food items logged for \(mealName).")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredLogs, id: \.id) { entry in
                            VStack(alignment: .leading) {
                                Text(entry.foodName)
                                    .font(.headline)
                                    .onTapGesture {
                                        startEditing(entry) // ✅ Tap to edit entry
                                    }
                                Text("Calories: \(Int(entry.calories)) | Carbs: \(Int(entry.carbs))g")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteFoodItem)
                    }
                }
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                VStack {
                    Text(editingEntry == nil ? "Add a Food Item" : "Edit Food Item")
                        .font(.headline)
                    
                    TextField("Food Name", text: $newFoodName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    HStack {
                        TextField("Calories", text: $newFoodCalories)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("Carbs (g)", text: $newFoodCarbs)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)
                    
                    Button(action: saveFoodItem) {
                        Text(editingEntry == nil ? "Add Food" : "Update Food")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(editingEntry == nil ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    // ✅ Function to Start Editing a Food Entry
    private func startEditing(_ entry: MealLogEntry) {
        editingEntry = entry
        newFoodName = entry.foodName
        newFoodCalories = String(Int(entry.calories))
        newFoodCarbs = String(Int(entry.carbs))
    }
    
    // ✅ Function to Save/Add Food Item
    private func saveFoodItem() {
        guard let calories = Double(newFoodCalories),
              let carbs = Double(newFoodCarbs),
              !newFoodName.isEmpty else { return }
        
        if let entry = editingEntry {
            entry.updateEntry(foodName: newFoodName, calories: calories, carbs: carbs)
        } else {
            MealLogEntry.addEntry(foodName: newFoodName, calories: calories, carbs: carbs, mealType: mealName, context: modelContext)
        }
        
        // Reset Fields
        editingEntry = nil
        newFoodName = ""
        newFoodCalories = ""
        newFoodCarbs = ""
    }
    
    // ✅ Function to Delete Food Items
    private func deleteFoodItem(at offsets: IndexSet) {
        for index in offsets {
            let entryToDelete = filteredLogs[index]
            MealLogEntry.deleteEntry(entry: entryToDelete, context: modelContext)
        }
    }
}

