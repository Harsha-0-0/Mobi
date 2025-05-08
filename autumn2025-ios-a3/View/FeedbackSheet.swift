//
//  FeedbackSheet.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 7/5/2025.
//

import SwiftUI

struct FeedbackSheet: View {
    var record: ExerciseRecord
    var onComplete: (ExerciseRecord) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var moodRating: Int = 3
    @State private var painRating: Int = 0
    @State private var note: String = ""

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 16) {
                    Text("How do you feel after this session?")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood (1: Frustrated - 5: Encouraging)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Stepper("Mood: \(moodRating)", value: $moodRating, in: 1...5)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pain (1: None - 10: Painful)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Stepper("Pain: \(painRating)", value: $painRating, in: 0...10)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Any notes?")
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
            .navigationTitle("Record")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Submit") {
                    var updatedRecord = record
                    updatedRecord.isDone = true
                    updatedRecord.overallFeedback = ExerciseFeedback(
                        moodRating: moodRating,
                        painRating: painRating,
                        finalNote: note.isEmpty ? nil : note
                    )
                    
                    onComplete(updatedRecord)
                    dismiss()
                }
            )
        }
    }
}
