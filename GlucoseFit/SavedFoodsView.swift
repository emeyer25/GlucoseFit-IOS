import SwiftUI
import SwiftData

struct SavedFoodsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var savedFoods: [SavedFoodItem]

    @State private var searchText = ""

    var onSelect: (FoodItem) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredSavedFoods, id: \.name) { savedFood in
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
                            onSelect(foodCopy)
                            dismiss()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                .onDelete(perform: deleteFood)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search saved foods")
            .navigationTitle("Saved Foods")
            .toolbar {
                EditButton()
            }
        }
    }

    private var filteredSavedFoods: [SavedFoodItem] {
        if searchText.isEmpty {
            return savedFoods
        } else {
            return savedFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let food = savedFoods[index]
            modelContext.delete(food)
        }
    }
}
