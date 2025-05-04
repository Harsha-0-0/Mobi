//
//  ToggleOptionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 4/5/2025.
//
import SwiftUI

struct ToggleOptionView: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
                Text(title)
                    .foregroundColor(.primary)
            }
        }
    }
}
