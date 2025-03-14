import SwiftUI
import SwiftData

struct CalendarView: View {
    
    @State private var selectedDate = Date()
    @Query private var entries: [CalendarEntry]
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        NavigationStack {
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
                    //  Calendar Picker
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    //  Navigate to HomeView for selected date
                    NavigationLink(destination: HomeView(selectedDate: selectedDate)) {
                        Text("View Details for Selected Day")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
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
    CalendarView()
}
