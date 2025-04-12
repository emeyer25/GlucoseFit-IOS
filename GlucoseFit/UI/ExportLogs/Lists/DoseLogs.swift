//
//  DoseLogs.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/11/25.
//
import SwiftUI
import SwiftData

struct DoseLogs: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Query private var doseLogs: [InsulinLogEntry]
    
    var startDate: Date
    var endDate: Date
    
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
    
    
    private var relevantDoses: [InsulinLogEntry] {
        doseLogs.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
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
                Text("Review your dose logs")
                    .font(.title)
                
                if doseLogs.isEmpty {
                    Text("No dose logs found.")
                } else {
                    List(doseLogs) { entry in
                        HStack {
                            Text("At \(entry.date, formatter: dateFormatter), took \(entry.units) units")
                        }
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
