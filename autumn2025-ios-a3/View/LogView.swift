//
//  LogView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI

struct LogView: View {
    @State private var date = Date()
    @State private var navigate = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                DatePicker(
                    "Pick a date",
                    selection: $date,
                    displayedComponents: .date)
                
                .datePickerStyle(.graphical)
                .scaleEffect(1.1)
                .frame(maxWidth: .infinity, maxHeight: 450)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                
                NavigationLink(destination: LogDetailView(date: date)) {
                    Text("View Log Details")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.blueButton))
                    
                }
                Spacer()
                    .navigationTitle("Log")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
            }
            .padding()
        }
    }
}


#Preview {
    ContentView(selection: .log)
}
