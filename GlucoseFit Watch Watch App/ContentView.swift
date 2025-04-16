//
//  ContentView.swift
//  GlucoseFit Watch App
//
//  Created by Ian Burall on 4/14/25.
//

import SwiftUI
import SwiftData

struct Main: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var settings = Settings.shared
    
    var body: some View {
        if (settings.isCarbOnlyViewEnabled) {
            CarbHomeView()
                .onAppear {
                    WatchManager.shared.activateSession()
                    WatchManager.shared.setModelContext(modelContext)
                }
        }
        else {
            HomeView()
                .onAppear {
                    WatchManager.shared.activateSession()
                    WatchManager.shared.setModelContext(modelContext)
                }
        }
    }
}

#Preview {
    Main()
}
