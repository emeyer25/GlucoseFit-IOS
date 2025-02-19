import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate = Date()
    @Query private var entries: [CalendarEntry]
    
    @State private var navigateToMealLog = false
    
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
                    
                    //  Navigate to MealLogView
                    Button(action: {
                        navigateToMealLog = true
                    }) {
                        Text("View Meal Log")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .background(
                        NavigationLink(destination: MealLogView(selectedDate: selectedDate), isActive: $navigateToMealLog) {
                            EmptyView()
                        }
                    )
                }
                .navigationTitle("Calendar")
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    CalendarView()
}
