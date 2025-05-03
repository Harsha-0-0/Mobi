//
//  PlanNewSessionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 2/5/2025.
//

import SwiftUI

struct PlanNewSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var sessionName: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isStartPickerVisible = false
    @State private var isEndPickerVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Session Name
            VStack(alignment: .leading, spacing: 6) {
                Text("Session Name")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                TextField("Session Name", text: $sessionName)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }

            // Start Date
            VStack(alignment: .leading, spacing: 6) {
                Text("Start Date")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Button(action: {
                    withAnimation {
                        isStartPickerVisible.toggle()
                        isEndPickerVisible = false
                    }
                }) {
                    HStack {
                        Text(FormatterUtil.longDateFormatter.string(from: startDate))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }

                if isStartPickerVisible {
                    DatePicker("Select Start Date", selection: $startDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: startDate) { oldValue, newValue in
                            startDate = newValue
                            withAnimation {
                                isStartPickerVisible = false
                            }
                        }
                        .padding(.top, 5)
                }
            }

            // End Date
            VStack(alignment: .leading, spacing: 6) {
                Text("End Date")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Button(action: {
                    withAnimation {
                        isEndPickerVisible.toggle()
                        isStartPickerVisible = false
                    }
                }) {
                    HStack {
                        Text(FormatterUtil.longDateFormatter.string(from: endDate))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }

                if isEndPickerVisible {
                    DatePicker("Select End Date", selection: $endDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: endDate) { oldValue, newValue in
                            endDate = newValue
                            withAnimation {
                                isEndPickerVisible = false
                            }
                        }
                        .padding(.top, 5)
                }
            }

            // Create Button
            Button(action: {
                let session = Session(name: sessionName, startDate: startDate, endDate: endDate, exercises: [])
                SessionRepository().save(session)
                presentationMode.wrappedValue.dismiss() // Return to PlanView
            }) {
                Text("Create a new session")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.blueButton))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView(selection: .plan)
}
