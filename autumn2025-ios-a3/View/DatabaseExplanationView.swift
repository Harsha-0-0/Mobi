//
//  DatabaseExplanationView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI

struct DatabaseExplanationView: View {
    private let sessionRepository = SessionRepository()
    @State private var sessionList: [Session] = []

    var body: some View {
        VStack {
            Button("Add Mock Session") {
                let mockSession = createSampleSession()
                sessionRepository.save(mockSession)
                sessionList = sessionRepository.listAll()
            }

            List(sessionList, id: \.id) { session in
                VStack(alignment: .leading) {
                    Text(session.name)
                        .font(.headline)
                    Text("Start: \(session.startDate.formatted())")
                    Text("End: \(session.endDate.formatted())")
                    Text("Exercises: \(session.exercises.count)")
                }
            }
        }
        .padding()
        .onAppear {
            sessionList = sessionRepository.listAll()
        }
    }

    private func createSampleSession() -> Session {
        let exercise1 = Exercise(
            name: "Push Ups",
            description: "Push upppp",
            type: .reps,
            count: 15,
            sets: 3,
            guidanceImageURL: "gg.com/pushup.png",
            instruction: "Keep your back straight"
        )

        let exercise2 = Exercise(
            name: "Plank",
            description: "Plankkkk",
            type: .time,
            count: 60,
            sets: 2,
            guidanceImageURL: "gg.com/plank.png",
            instruction: "Hold for the full time"
        )

        return Session(
            name: "Summer Workout",
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            exercises: [exercise1, exercise2]
        )
    }
}

#Preview {
    DatabaseExplanationView()
}
