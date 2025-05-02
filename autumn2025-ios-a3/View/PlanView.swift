//
//  SessionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI
import SwiftUI

struct PlanView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This is Plan view.")
                .font(.title2)
                .padding(.top)

            GroupBox(label:
                Label("Session", systemImage: "doc.plaintext")
                    .font(.headline)
            ) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text("Exercise")
                    .font(.footnote)
                    .padding(8)
                }
                .frame(height: 80)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView(selection: TabSelection.plan)
}
