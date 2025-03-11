//
//  SplashScreenView.swift
//  GlucoseFit
//
//  Created by Eric Meyer on 3/6/25.
import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            // Background Gradient
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
                Image("Image") // Your app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)

                ProgressView() // Loading spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding(.top, 20)
            }
        }
    }
}
#Preview {
    SplashScreenView()
}
