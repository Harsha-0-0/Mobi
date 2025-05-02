//
//  ContentView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 30/4/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: TabSelection = .home  // Default to .home
    
    init(selection: TabSelection = .home) {
        _selection = State(initialValue: selection)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: TabSelection.home) {
                HomeView()
            }

            Tab("Log", systemImage: "book", value: TabSelection.log) {
                LogView()
            }

            Tab("Plan", systemImage: "calendar", value: TabSelection.plan) {
                PlanView()
            }
        }
    }
}

#Preview {
    ContentView()
}

