//
//  IOSMain.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/14/25.
//
import SwiftUI

struct Main: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("setupComplete") private var setupCompleted = false
    @State private var animateOnComplete = false
    
    var body: some View {
        ZStack {
            if (!setupCompleted) {
                OnBoardingView(complete: {
                    withAnimation(.easeInOut(duration: 2)) {
                        animateOnComplete = true
                        setupCompleted = true
                    }
                })
                .offset(animateOnComplete ? CGSize(width: 0, height: UIScreen.main.bounds.maxY) : CGSize(width: 0, height: 0))
            }
            else {
                ContentView()
            }
        }
        .onAppear {
            WatchManager.shared.activateSession()
            WatchManager.shared.setModelContext(modelContext)
        }
    }
}

#Preview {
    Main()
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self], inMemory: true)
}
