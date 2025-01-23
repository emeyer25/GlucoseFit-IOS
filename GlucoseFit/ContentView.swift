//
//  ContentView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 1/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack {
            
            Text("Calories ")
                .font(Font.custom("Inter", size: 60)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 1080, height: 144, alignment: .center)
            Spacer()
            
            Text("Breakfast")
              .font(Font.custom("Inter", size: 78))
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(width: 1080, height: 144, alignment: .center)
            Spacer()
        }.background(
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
            Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.02, y: 0.61),
            endPoint: UnitPoint(x: 1.01, y: 0.61)
            ))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

