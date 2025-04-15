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
    
    var mealsForToday : [MealLogEntry] {
        meals.filter { meal in
            meal.date == Date.now
        }
    }
    
    var body: some View {
        
    }
}
