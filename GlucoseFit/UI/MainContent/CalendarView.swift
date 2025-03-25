import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate = Date()
    @Query private var entries: [CalendarEntry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    // Dynamic colors based on color scheme
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

    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic Background Gradient
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
                    // Calendar Picker with dark mode support
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(cardBackgroundColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .colorScheme(colorScheme) // Ensures date picker adapts

                    // Navigation Button
                    NavigationLink(destination: HomeView(selectedDate: selectedDate)) {
                        Text("View Details for Selected Day")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .navigationTitle("Calendar")
                .padding(.top, 20)
            }
        }
        .modelContext(modelContext)
    }
}

#Preview {
    Group {
        
        CalendarView()
            .preferredColorScheme(.dark)
    }
    .modelContainer(for: [CalendarEntry.self])
}
