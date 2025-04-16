//
//  MealSelector.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//
import SwiftUI
import SwiftData

struct MealSelector: View {
    @Environment(\.colorScheme) private var colorScheme
    @Query private var meals: [MealLogEntry]
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var mealsForToday : [MealLogEntry] {
        meals.filter { meal in
            meal.date == Date.now
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var moveOn: (String, Date) -> Void
    
    var body: some View {
        @State var mealSelection = 0
        
        ZStack {
            TabView {
                MealSection(name: "Breakfast", date: Date.now) {
                    moveOn("Breakfast", Date.now)
                }
                .tabItem {
                    Text("")
                }
                .tag(0)
                
                MealSection(name: "Lunch", date: Date.now) {
                    moveOn("Lunch", Date.now)
                }
                .tabItem {
                    Text("")
                }
                .tag(1)
                

                MealSection(name: "Dinner", date: Date.now) {
                    moveOn("Dinner", Date.now)
                }
                .tabItem {
                    Text("")
                }
                .tag(2)
                
                MealSection(name: "Snack", date: Date.now) {
                    moveOn("Snack", Date.now)
                }
                .tabItem {
                    Text("")
                }
                .tag(3)
            }
            .tabViewStyle(.page)
        }
    }
}

struct MealSection: View {
    @Query private var meals: [MealLogEntry]
    private var mealsForToday: [MealLogEntry] {
        meals.filter { $0.date == Date.now }
    }
    var name: String
    var date: Date
    var select: () -> Void
    var carbs: Int {
        Int(mealsForToday
        .filter { $0.mealName == name }
        .reduce(0) { $0 + $1.foods.reduce(0) { $0 + $1.carbs } })
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text(name)
                .font(.title2)
            Text("\(date, formatter: dateFormatter)")
                .font(.title3)
            Text("\(carbs)g carbs")
            Button("Select") {
                select()
            }
        }
    }
}

#Preview {
    AddFoodNavigator() {
        
    }
}
