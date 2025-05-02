//
//  ContentView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 30/4/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: FooterTab = .home
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .log:
                        LogView()
                    case .plan:
                        PlanView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                FooterView(activeTab: selectedTab) { newTab in
                    if newTab != selectedTab {
                        selectedTab = newTab
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
