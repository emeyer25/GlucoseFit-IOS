//
//  CalendarView.swift
//  GlucoseFit
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate = Date() // Stores selected date
    @Query private var entries: [CalendarEntry] // Fetches stored logs

    var filteredEntries: [CalendarEntry] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        ZStack {
            // 🔹 Background Gradient
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.02, y: 0.61),
                endPoint: UnitPoint(x: 1.01, y: 0.61)
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 📅 Calendar Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color.white.opacity(0.7)) // Adds contrast for readability
                    .cornerRadius(10)
                    .padding(.horizontal)

                .background(Color.white.opacity(0.7)) // Improves readability
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Calendar")
            .padding(.top, 20) // Space from the top
        }
    }
}
#Preview {
    CalendarView()
}
