//
//  PlanSessionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 2/5/2025.
//

import SwiftUI

struct PlanSessionView: View {
    let sessionId: UUID
    
    var body: some View {
        VStack {
            Text("Session ID: \(sessionId.uuidString)")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Session Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PlanSessionView(sessionId: UUID())
}
