import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var foodName: String = ""
    @State private var carbs: String = ""
    @State private var calories: String = ""
    
    var onAdd: (FoodItem) -> Void
    
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
            
            Spacer()
        }
        .padding()
    }
    
    private func addFood() {
        guard let carbsValue = Double(carbs), let caloriesValue = Double(calories), !foodName.isEmpty else { return }
        
        let newFood = FoodItem(name: foodName, carbs: carbsValue, calories: caloriesValue)
        onAdd(newFood)
        
        dismiss()
    }
}
