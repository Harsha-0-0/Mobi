//
//  SessionView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI

struct PlanView: View {
    @State private var currentSessions: [Session] = []
    @State private var upcomingSessions: [Session] = []
    @State private var pastSessions: [Session] = []

    var body: some View {
        NavigationView {
            Group {
                if currentSessions.isEmpty && upcomingSessions.isEmpty && pastSessions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        Text("No sessions")
                            .font(.headline)
                            .foregroundColor(.gray)

                        NavigationLink(destination: PlanNewSessionView()) {
                            Text("Create a new session")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 100)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.blueButton))
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            sessionSection(title: "Current Session", sessions: currentSessions)
                            sessionSection(title: "Upcoming Sessions", sessions: upcomingSessions)
                            sessionSection(title: "Past Sessions", sessions: pastSessions)

                            NavigationLink(destination: PlanNewSessionView()) {
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
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Exercise Plan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                let repo = SessionRepository()
                if let current = repo.getCurrentSession() {
                    currentSessions = [current]
                } else {
                    currentSessions = []
                }
                upcomingSessions = repo.getUpcomingSessions()
                pastSessions = repo.getPastSessions()
            }
        }
    }

    @ViewBuilder
    private func sessionSection(title: String, sessions: [Session]) -> some View {
        Text(title)
            .font(.title3)
            .bold()
            .padding(.top)

        if sessions.isEmpty {
            Text("No \(title.lowercased())")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading)
        } else {
            ForEach(sessions, id: \.id) { session in
                GroupBox(label:
                    Label(session.name, systemImage: "doc.plaintext")
                        .font(.headline)
                        .foregroundColor(.black)
                ) {
                    VStack(alignment: .leading, spacing: 8) {
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

                            VStack(alignment: .trailing, spacing: 6) {
                                NavigationLink(destination: PlanSessionView(sessionId: session.id)) {
                                    Text("View & Edit")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .frame(width: 110)
                                        .background(Capsule().fill(Color.blueButton))
                                        .lineLimit(1)
                                }

                                Button(action: {
                                    SessionRepository().deleteById(sessionId: session.id)
                                    let repo = SessionRepository()
                                    if let current = repo.getCurrentSession() {
                                        currentSessions = [current]
                                    } else {
                                        currentSessions = []
                                    }
                                    upcomingSessions = repo.getUpcomingSessions()
                                    pastSessions = repo.getPastSessions()
                                }) {
                                    Text("Delete")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .frame(width: 110)
                                        .background(Capsule().fill(Color.red))
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .padding(8)
                }
            }
        }
    }
}

#Preview {
    ContentView(selection: .plan)
}
