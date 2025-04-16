//
//  HomeView.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//
import SwiftUI
import SwiftData

enum CurrentView {
    case home
    case add
    case select
    case log
}

struct HomeView: View {
    @StateObject private var settings = Settings.shared
    @Query private var mealLogs: [MealLogEntry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    
    var loggedCalories: Double {
        mealLogs.filter { Calendar.current.isDate($0.date, inSameDayAs: Date.now) }
            .reduce(0) { total, meal in
                total + meal.foods.reduce(0) { $0 + $1.calories }
            }
    }

    var remainingCalories: Double {
        let totalCalories = Double(settings.manualCalories) ?? 0
        return totalCalories - loggedCalories
    }

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

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : .black
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    @State private var showMethodSelector = false
    @State private var showAddFood = false
    @State private var showImportFood = false
    @State private var showLog = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: backgroundColor, location: 0.00),
                        Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(Date.now, formatter: dateFormatter)
                        .font(Font.custom("Inter", size: 24))
                        .bold()
                        .foregroundColor(textColor)
                    
                    Text("Calories")
                        .font(Font.custom("Inter", size: 40))
                        .bold()
                        .foregroundColor(textColor)
                    
                    let totalCalories = Double(settings.manualCalories) ?? 0
                    
                    Text("\(Int(totalCalories)) - \(Int(loggedCalories))")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(secondaryTextColor)
                    
                    Text("\(Int(remainingCalories))")
                        .font(Font.custom("Inter", size: 40))
                        .bold()
                        .foregroundColor(textColor)
                    
                    HStack {
                        Button("Log Meal") {
                            showMethodSelector = true
                        }
                        Button("Log Dose") {
                            
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showMethodSelector) {
            VStack {
                Text("Select a log method")
                    .foregroundColor(textColor)
                HStack {
                    Button("Add New") {
                        showAddFood = true
                        showMethodSelector = false
                    }
                    Button("Import") {
                        
                    }
                }
            }
            .padding()
            .background(cardBackgroundColor)
        }
        .fullScreenCover(isPresented: $showAddFood) {
            NavigationStack {
                AddFoodNavigator() {
                    showAddFood = false
                }
            }
        }
        .fullScreenCover(isPresented: $showImportFood) {
            
        }
        .fullScreenCover(isPresented: $showLog) {
            
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.light)
}
