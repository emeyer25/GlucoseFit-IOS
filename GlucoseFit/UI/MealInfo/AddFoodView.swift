import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext 

    @State private var foodName: String = ""
    @State private var carbs: String = ""
    @State private var calories: String = ""

    var onAdd: (FoodItem) -> Void
    var onSave: (FoodItem) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Food")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Food Name", text: $foodName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Carbs (g)", text: $carbs)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Calories", text: $calories)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: addFood) {
                Text("Add")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Button("Save") {
                saveFood()
            }
            .font(.title2)
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.yellow)
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func addFood() {
        guard let carbsValue = Double(carbs), let caloriesValue = Double(calories), !foodName.isEmpty else { return }

        let newFood = FoodItem(name: foodName, carbs: carbsValue, calories: caloriesValue)

        modelContext.insert(newFood)
        
        onAdd(newFood)

        dismiss()
    }
    
    private func saveFood() {
        guard let carbsValue = Double(carbs), let caloriesValue = Double(calories), !foodName.isEmpty else { return }
        
        addFood()
        
        let savedItem = FoodItem(name: foodName, carbs: carbsValue, calories: caloriesValue)
        
        onSave(savedItem)
    }
}
