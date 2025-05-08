//
//  SessionView.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 7/5/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var sessions: [Session] = []
    @State private var exerciseRecords: [ExerciseRecord] = []
    
    var body: some View {
        NavigationView {
            Group {
                if sessions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Text("Ready to start your rehab journey?")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: PlanNewSessionView()) {
                            Text("Add Session")
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
                    VStack(alignment: .leading, spacing: 12) {
                        Spacer()
                        
                        Text("Hi there, ready to start today’s rehab?")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(exerciseRecords) { record in
                                    if let exercise = findExercise(sessionId: record.sessionId, exerciseId: record.exerciseId) {
                                        recordRow(record: record, exercise: exercise)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        sessions = SessionRepository().listAll()
        let today = Calendar.current.startOfDay(for: Date())
        
        var records = ExerciseRecordRepository().listByDate(today)
        
        if records.isEmpty {
            print("****Initializing new records for today")
            records = createInitialRecords(for: today)
            ExerciseRecordRepository().saveAll(records)
        } else {
            print("****Checking for missing exercises...")
            records = checkAndUpdateRecords(for: today, existingRecords: records)
            ExerciseRecordRepository().saveAll(records)
        }
        
        exerciseRecords = records
        print("****Loaded records: \(exerciseRecords)")
    }
    
    func createInitialRecords(for date: Date) -> [ExerciseRecord] {
        return sessions.flatMap { session in
            session.exercises.map { exercise in
                ExerciseRecord(
                    date: date,
                    sessionId: session.id,
                    exerciseId: exercise.id,
                    isDone: false,
                    setResults: [],
                    overallFeedback: nil
                )
            }
        }
    }
    
    func checkAndUpdateRecords(for date: Date, existingRecords: [ExerciseRecord]) -> [ExerciseRecord] {
        var updatedRecords = existingRecords
        
        for session in sessions {
            for exercise in session.exercises {
                let exists = updatedRecords.contains { record in
                    record.sessionId == session.id && record.exerciseId == exercise.id
                }
                
                if !exists {
                    print("****Adding missing record for exercise: \(exercise.name)")
                    let newRecord = ExerciseRecord(
                        date: date,
                        sessionId: session.id,
                        exerciseId: exercise.id,
                        isDone: false,
                        setResults: [],
                        overallFeedback: nil
                    )
                    updatedRecords.append(newRecord)
                }
            }
        }
        
        return updatedRecords
    }
    
    func findExercise(sessionId: UUID, exerciseId: UUID) -> Exercise? {
        return sessions.first(where: { $0.id == sessionId })?
            .exercises.first(where: { $0.id == exerciseId })
    }
    
    func updateRecord(record: ExerciseRecord) {
        ExerciseRecordRepository().update(record)
        if let index = exerciseRecords.firstIndex(where: { $0.id == record.id }) {
            exerciseRecords[index] = record
        }
    }
    
    @ViewBuilder
    func recordRow(record: ExerciseRecord, exercise: Exercise) -> some View {
        GroupBox {
            HStack {
                // Exercise Name
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if record.isDone {
                    // Checkmark for Completed
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                } else {
                    // Start Button
                    NavigationLink(destination:
                        StartExerciseView(record: record, onComplete: { updated in
                            updateRecord(record: updated)
                        })
                    ) {
                        Text("Start")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.blueButton))
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }

}



#Preview {
    ContentView(selection: .home)
}
