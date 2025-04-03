import SwiftUI

struct SettingsMenuView: View {
    @ObservedObject var settings: Settings
    var onClose: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    private var secondaryTextColor: Color {
        .gray
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .padding(8)
                        .foregroundColor(textColor)
                }
            }
            .padding(.bottom, 8)
            
            let currentSettings = settings.currentDoseSettings()
            Text("Current Settings")
                .font(.headline)
                .foregroundColor(textColor)

            HStack {
                VStack(alignment: .leading) {
                    Text("Insulin:Carb")
                        .font(.subheadline)
                        .foregroundColor(secondaryTextColor)
                    Text("1:\(currentSettings.insulinToCarbRatio)")
                        .font(.headline)
                        .foregroundColor(textColor)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Correction")
                        .font(.subheadline)
                        .foregroundColor(secondaryTextColor)
                    Text("1:\(currentSettings.correctionDose)")
                        .font(.headline)
                        .foregroundColor(textColor)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Target")
                        .font(.subheadline)
                        .foregroundColor(secondaryTextColor)
                    Text("\(currentSettings.targetGlucose) mg/dL")
                        .font(.headline)
                        .foregroundColor(textColor)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}
