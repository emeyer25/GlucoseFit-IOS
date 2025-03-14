//
//  screenshot.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 3/13/25.
//

import SwiftUI

struct screenshot: View {
    public var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.33, green: 0.62, blue: 0.68), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.6, green: 0.89, blue: 0.75), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.02, y: 0.61),
                    endPoint: UnitPoint(x: 1.01, y: 0.61)
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    screenshot()
}
