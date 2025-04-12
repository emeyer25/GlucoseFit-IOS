//
//  MealLogs.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/11/25.
//
import SwiftUI
import SwiftData

enum LogCollection: Identifiable {
    case Meal(MealLogger)
    case Food(FoodItem)
    
    var id: UUID {
        switch self {
            case .Meal(let meal): return meal.id
            case .Food(let food): return food.id
        }
    }
    
    var name: String {
        switch self {
            case .Meal(let meal): return meal.name
            case .Food(let food): return food.name
        }
    }
    
    var children: [LogCollection]? {
        switch self {
            case .Meal(let meal): return meal.foods
            case .Food(_): return nil
        }
    }
    
    static private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func display() -> some View {
        let settings = Settings.shared
        return VStack {
            switch self {
                case .Food(let food): VStack {
                    Text(food.name)
                    if (settings.isCarbOnlyViewEnabled) {
                        Text("Calories: \(food.calories)")
                    }
                    Text("Carbs: \(food.carbs)")
                }
                case .Meal(let meal): Text(meal.name)
            }
        }
    }
}

struct MealLogger: Identifiable {
    let id: UUID
    let name: String
    let date: Date
    let foods: [LogCollection]
    
    init(meal: MealLogEntry) {
        self.id = meal.id
        self.date = meal.date
        self.name = meal.mealName
        
        var arr = Array<LogCollection>()
        
        for food in meal.foods {
            arr.append(.Food(food))
        }
        
        self.foods = arr
    }
}

struct MealLogs: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }
    
    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }
    
    private var buttonColor: Color {
        colorScheme == .dark ? Color.blue.opacity(0.8) : Color.blue
    }
    
    var startDate: Date
    var endDate: Date
    
    @Query private var mealLogs: [MealLogEntry]
    
    private var relevantMeals: [MealLogEntry] {
        mealLogs.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
    }
    
    private var menuTree: [LogCollection] {
        var arr = Array<LogCollection>()
        
        for meal in relevantMeals {
            arr.append(.Meal(MealLogger(meal: meal)))
        }
        
        return arr
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: backgroundColor, location: 0),
                    .init(color: secondaryBackgroundColor, location: 1),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Review your meal logs")
                    .font(.title)
                
                
                if mealLogs.isEmpty {
                    Text("No meal logs found.")
                } else {
                    List(menuTree, children: \.children) { item in
                        item.display()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(cardBackgroundColor)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ExportView()
}
