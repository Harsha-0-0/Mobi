//
//  UnfinishedSetSheet.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 7/5/2025.
//

import SwiftUI

struct UnfinishedSetSheet: View {
    var record: ExerciseRecord
    var setNumber: Int
    var onComplete: (ExerciseRecord) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var actualValue: Int = 0
    @State private var note: String = ""
    
    var exercise: Exercise? {
        guard let session = SessionRepository().getById(by: record.sessionId),
              let ex = session.exercises.first(where: { $0.id == record.exerciseId }) else {
            return nil
        }
        return ex
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("It’s okay! Every step counts. Tell us what got in the way.")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How many reps/seconds did you complete?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Stepper("Completed: \(actualValue)", value: $actualValue, in: 0...50)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Any notes on what made it hard to finish?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your notes here", text: $note)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 8)
            }
            .onAppear {
                if let maxReps = exercise?.count {
                    actualValue = maxReps
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    var updatedRecord = record
                    var setsCompleted: Int = 0
                    for result in updatedRecord.setResults {
                        if result.isCompleted {
                            setsCompleted += 1
                        }
                    }
                    let newSetResult = SetResult(
                        setNumber: setNumber,
                        isCompleted: false,
                        actualValue: actualValue,
                        setsCompleted: setsCompleted,
                        note: note.isEmpty ? nil : note
                    )
                    
                    updatedRecord.setResults.append(newSetResult)
                    
                    onComplete(updatedRecord)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    UnfinishedSetSheet(
        record: ExerciseRecord(
            date: Date(),
            sessionId: UUID(),
            exerciseId: UUID(),
            exerciseName: "test",
            isDone: false,
            setResults: [],
            totalSets: 3
        ),
        setNumber: 1
    ) { updatedRecord in
        print(updatedRecord.setResults)
    }
}
