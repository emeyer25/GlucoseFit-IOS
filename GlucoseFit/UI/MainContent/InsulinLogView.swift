import SwiftUI
import SwiftData

struct InsulinLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var settings = Settings.shared
    @Query private var insulinLogs: [InsulinLogEntry]
    @State private var insulinDose: String = ""
    let selectedDate: Date
    
    private var insulinLogsForSelectedDate: [InsulinLogEntry] {
        let calendar = Calendar.current
        return insulinLogs.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // Dynamic colors matching CalendarView
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
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : .gray
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient matching CalendarView
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: backgroundColor, location: 0.00),
                        Gradient.Stop(color: secondaryBackgroundColor, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Current Settings Card
                    VStack(alignment: .leading) {
                        let currentSettings = settings.currentDoseSettings()
                        Text("Current Settings")
                            .font(.headline)
                            .foregroundColor(textColor)
                            .padding(.bottom, 4)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Insulin:Carb")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryTextColor)
                                Text("1:\(currentSettings.insulinToCarbRatio)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(textColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Correction")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryTextColor)
                                Text("1:\(currentSettings.correctionDose)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(textColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Target")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryTextColor)
                                Text("\(currentSettings.targetGlucose) mg/dL")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(textColor)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(cardBackgroundColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Log Insulin Dose Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Log Insulin Dose")
                            .font(.title2)
                            .bold()
                            .foregroundColor(textColor)
                        
                        HStack {
                            TextField("Enter units", text: $insulinDose)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(textColor)
                            
                            Button(action: logInsulin) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(buttonColor)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(cardBackgroundColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Insulin Logs List Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Logs for \(selectedDate, formatter: dateFormatter)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(textColor)
                            
                            Spacer()
                        }
                        
                        if insulinLogsForSelectedDate.isEmpty {
                            Text("No insulin logs for this day")
                                .foregroundColor(secondaryTextColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        } else {
                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(insulinLogsForSelectedDate, id: \.id) { log in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(log.units, specifier: "%.1f") units")
                                                    .font(.headline)
                                                    .foregroundColor(textColor)
                                                Text(log.date, style: .time)
                                                    .font(.subheadline)
                                                    .foregroundColor(secondaryTextColor)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: { deleteInsulinLog(log) }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(cardBackgroundColor)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(cardBackgroundColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            .navigationTitle("Insulin Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Insulin Log")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(textColor)
                }
            }
        }
        .modelContext(modelContext)
    }
    
    private func logInsulin() {
        guard let units = Double(insulinDose) else { return }
        let insulinEntry = InsulinLogEntry(units: units, date: Date())
        modelContext.insert(insulinEntry)
        insulinDose = ""
    }
    
    private func deleteInsulinLog(_ log: InsulinLogEntry) {
        modelContext.delete(log)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    InsulinLogView(selectedDate: Date())
        .preferredColorScheme(.light)
        .modelContainer(for: [MealLogEntry.self, FoodItem.self, SavedFoodItem.self, InsulinLogEntry.self], inMemory: true)
}
