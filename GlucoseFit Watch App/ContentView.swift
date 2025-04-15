//
//  ContentView.swift
//  GlucoseFit Watch App
//
//  Created by Ian Burall on 4/14/25.
//

import SwiftUI
import SwiftData

struct Main: View {
    @StateObject private var settings = Settings.shared
    
    var body: some View {
        if (settings.isCarbOnlyViewEnabled) {
            HomeView()
        }
        else {
            CarbHomeView()
        }
    }
}

#Preview {
    Main()
}
