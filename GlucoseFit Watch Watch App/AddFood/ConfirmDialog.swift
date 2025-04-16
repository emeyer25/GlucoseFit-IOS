//
//  ConfirmDialog.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/15/25.
//
import SwiftUI

struct ConfirmDialog: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var mealName: String
    var mealDate: Date
    var foodName: String
    var foodCarbs: Double
    var foodCals: Double
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var moveOn: () -> Void
    var cancel: () -> Void
    
    var body: some View {
        VStack {
            Text("Is this correct?")
                .font(.headline)
                .foregroundColor(textColor)
            HStack {
                VStack {
                    Text("Add to:")
                        .font(.body)
                        .foregroundColor(textColor)
                    Text(mealName)
                        .font(.body)
                        .foregroundColor(textColor)
                    Text("\(mealDate, formatter: dateFormatter)")
                        .font(.body)
                        .foregroundColor(textColor)
                }
                Divider()
                VStack {
                    Text("Food")
                        .font(.body)
                        .foregroundColor(textColor)
                    Text("\(Int(foodCarbs))g carbs")
                        .font(.body)
                        .foregroundColor(textColor)
                    Text("\(Int(foodCals)) calories")
                        .font(.body)
                        .foregroundColor(textColor)
                }
            }
            HStack {
                Button("Yes") {
                    moveOn()
                }
                Button("No") {
                    cancel()
                }
            }
        }
    }
}

#Preview {
    AddFoodNavigator() {
        
    }
}
