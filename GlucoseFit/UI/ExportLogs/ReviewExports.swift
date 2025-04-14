//
//  ReviewExports.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/11/25.
//
import SwiftUI

struct ReviewExports: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedTabIndex = 0
    
    var startDate: Date
    var endDate: Date
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var confirm: () -> Void
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTabIndex) {
                MealLogs(startDate: startDate, endDate: endDate)
                    .tabItem {
                        Label("Meal Logs", systemImage: "list.bullet")
                    }
                    .tag(0)
                DoseLogs(startDate: startDate, endDate: endDate)
                    .tabItem {
                        Label("Dose Logs", systemImage: "chart.bar")
                    }
                    .tag(1)
            }
            
            
            VStack {
                Spacer()
                Button("Confirm logs") {
                    confirm()
                }
            }
        }
    }
}

#Preview {
    ExportView()
}
