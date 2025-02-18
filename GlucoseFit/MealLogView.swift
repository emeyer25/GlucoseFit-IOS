import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var mealName: String
    @State private var carbs: String = ""
    @State private var calories: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Food to \(mealName)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Carbs (g)", text: $carbs)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Calories", text: $calories)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: saveMealLog) {
                Text("Save")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.02, y: 0.61),
            endPoint: UnitPoint(x: 1.01, y: 0.61)
        )
        .edgesIgnoringSafeArea(.all)
   ) }
    
    private func saveMealLog() {
        guard let carbsValue = Double(carbs), let caloriesValue = Double(calories) else { return }
        
        let newMealLog = MealLogEntry(mealName: mealName, carbs: carbsValue, calories: caloriesValue, date: Date())
        modelContext.insert(newMealLog)
        
        dismiss()
    }
}
                    
                    #Preview {
                        HomeView()
                            .modelContainer(for: MealLogEntry.self) // Provide a preview container
                    }
