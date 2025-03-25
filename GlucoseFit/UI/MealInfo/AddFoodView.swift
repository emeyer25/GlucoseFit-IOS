import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    @State private var foodName: String = ""
    @State private var carbs: String = ""
    @State private var calories: String = ""

    var onAdd: (FoodItem) -> Void
    var onSave: (FoodItem) -> Void

    // MARK: - Dynamic Colors
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }

    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }

    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: backgroundColor, location: 0.0),
                    Gradient.Stop(color: secondaryBackgroundColor, location: 1.0),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Add Food")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(textColor)
                    .padding()

                Group {
                    TextField("Food Name", text: $foodName)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                    TextField("Calories", text: $calories)
                        .keyboardType(.decimalPad)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .colorScheme(colorScheme)
                .foregroundColor(textColor)

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
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(12)
            .padding()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func addFood() {
        guard let carbsValue = Double(carbs),
              let caloriesValue = Double(calories),
              !foodName.isEmpty else { return }

        let newFood = FoodItem(name: foodName, carbs: carbsValue, calories: caloriesValue)
        modelContext.insert(newFood)
        onAdd(newFood)
        dismiss()
    }

    private func saveFood() {
        guard let carbsValue = Double(carbs),
              let caloriesValue = Double(calories),
              !foodName.isEmpty else { return }

        addFood()
        let savedItem = FoodItem(name: foodName, carbs: carbsValue, calories: caloriesValue)
        onSave(savedItem)
    }
}
