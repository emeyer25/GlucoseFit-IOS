import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var activeSheet: ActiveSheet?
    @State private var isShowingHomeView = false
    @State private var isShowingInsulinLog = false
    @Query private var entries: [CalendarEntry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    enum ActiveSheet: Identifiable {
        case logSelection
        
        var id: Int {
            hashValue
        }
    }
    
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
                        .colorScheme(colorScheme)

                    // Button to show log selection
                    Button(action: {
                        activeSheet = .logSelection
                    }) {
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
        .sheet(item: $activeSheet) { item in
            switch item {
            case .logSelection:
                LogTypeSelectionView(
                    selectedDate: selectedDate,
                    isShowingHomeView: $isShowingHomeView,
                    isShowingInsulinLog: $isShowingInsulinLog
                )
                .presentationDetents([.height(200)])
                .presentationCornerRadius(20)
                .environment(\.modelContext, modelContext)
            }
        }
        .fullScreenCover(isPresented: $isShowingHomeView) {
            NavigationStack {
                HomeView(selectedDate: selectedDate)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                isShowingHomeView = false
                            }
                        }
                    }
            }
            .environment(\.modelContext, modelContext)
        }
        .fullScreenCover(isPresented: $isShowingInsulinLog) {
            NavigationStack {
                InsulinLogView(selectedDate: selectedDate)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                isShowingInsulinLog = false
                            }
                        }
                    }
            }
            .environment(\.modelContext, modelContext)
        }
    }
}

struct LogTypeSelectionView: View {
    let selectedDate: Date
    @Binding var isShowingHomeView: Bool
    @Binding var isShowingInsulinLog: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Log Type")
                .font(.title2)
                .bold()
                .padding(.top)
            
            HStack(spacing: 20) {
                // Food Log Button
                Button(action: {
                    dismiss()
                    isShowingHomeView = true
                }) {
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                        Text("Food Log")
                            .font(.headline)
                    }
                    .frame(width: 120, height: 100)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
                
                // Insulin Log Button
                Button(action: {
                    dismiss()
                    isShowingInsulinLog = true
                }) {
                    VStack {
                        Image(systemName: "syringe")
                            .font(.largeTitle)
                        Text("Insulin Log")
                            .font(.headline)
                    }
                    .frame(width: 120, height: 100)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding(.bottom)
        }
    }
}

#Preview {
    CalendarView()
        .preferredColorScheme(.dark)
        .modelContainer(for: [CalendarEntry.self, MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self])
}
