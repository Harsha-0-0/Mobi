//
//  StepperView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 4/5/2025.
//

import SwiftUI

struct StepperView: View {
    var label: String
    @Binding var value: Int

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)

            Button(action: {
                if value > 1 { value -= 1 }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
            }

            Text("\(value)")
                .frame(minWidth: 40)

            Button(action: {
                value += 1
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
            }
        }
    }
}
