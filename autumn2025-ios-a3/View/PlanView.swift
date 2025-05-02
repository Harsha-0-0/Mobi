//
//  SessionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI

struct PlanView: View {
    private let sessions: [Session] = SessionRepository().listAll()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(sessions, id: \.id) { session in
                    GroupBox(label:
                        Label(session.name, systemImage: "doc.plaintext")
                            .font(.headline)
                            .foregroundColor(.black)
                    ) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(session.exercises.count) exercise\(session.exercises.count > 1 ? "s" : "")")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("\(FormatterUtil.longDateFormatter.string(from: session.startDate)) - \(FormatterUtil.longDateFormatter.string(from: session.endDate))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: PlanSessionView(sessionId: session.id)) {
                                Text("View & Edit")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.blue))
                                    .frame(minWidth: 0, maxWidth: 120)
                                    .lineLimit(1)
                            }
                        }
                        .padding(8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Exercise Plan")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView(selection: .plan)
}
