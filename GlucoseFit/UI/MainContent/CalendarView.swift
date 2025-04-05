import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var showLogSelection = false
    @State private var showInsulinLog = false
    @State private var showFoodLog = false
    @Query private var entries: [CalendarEntry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    // Dynamic colors
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
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(cardBackgroundColor)
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Button(action: {
                        showLogSelection = true
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
        .sheet(isPresented: $showLogSelection) {
            LogTypeSelectionView(
                selectedDate: selectedDate,
                showInsulinLog: $showInsulinLog,
                showFoodLog: $showFoodLog
            )
            .environment(\.modelContext, modelContext)
            .presentationDetents([.height(200)])
            .presentationCornerRadius(20)
        }
        .fullScreenCover(isPresented: $showFoodLog) {
            NavigationStack {
                HomeView(selectedDate: selectedDate)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                showFoodLog = false
                            }
                        }
                    }
            }
            .environment(\.modelContext, modelContext)
        }
        .fullScreenCover(isPresented: $showInsulinLog) {
            NavigationStack {
                InsulinLogView(selectedDate: selectedDate)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                showInsulinLog = false
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
    @Binding var showInsulinLog: Bool
    @Binding var showFoodLog: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Log Type")
                .font(.title2)
                .bold()
                .padding(.top)
            
            HStack(spacing: 20) {
                Button(action: {
                    dismiss()
                    showFoodLog = true
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
                
                Button(action: {
                    dismiss()
                    showInsulinLog = true
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
