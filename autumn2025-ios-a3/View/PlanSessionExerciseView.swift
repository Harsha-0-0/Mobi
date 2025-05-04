//
//  PlanSessionExerciseView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 4/5/2025.
//

import SwiftUI

struct PlanSessionExerciseView: View {
    let sessionId: UUID
    let exerciseId: UUID

    @Environment(\.presentationMode) var presentationMode

    @State private var exerciseName = ""
    @State private var isRepetitionBased = true
    @State private var sets = 1
    @State private var reps = 10
    @State private var timeInSeconds = 30
    @State private var videoURL = ""
    @State private var instructions = ""

    // For detecting unsaved changes
    @State private var originalExercise: Exercise?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Exercise Name")
                .font(.headline)

            TextField("Enter exercise name…", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Exercise Parameters")
                .font(.headline)

            HStack(spacing: 20) {
                ToggleOptionView(title: "Repetition based", isSelected: isRepetitionBased) {
                    isRepetitionBased = true
                }
                ToggleOptionView(title: "Time based", isSelected: !isRepetitionBased) {
                    isRepetitionBased = false
                }
            }

            StepperView(label: "Sets", value: $sets)

            if isRepetitionBased {
                StepperView(label: "Reps", value: $reps)
            } else {
                StepperView(label: "Time (sec)", value: $timeInSeconds)
            }

            Divider()

            Text("Guidance")
                .font(.headline)

            TextField("Image / Video URL…", text: $videoURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("More Instructions…", text: $instructions)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()
        }
        .padding()
        .navigationBarItems(trailing:
            Button(action: saveChanges) {
                Text("Save")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(isSaveEnabled ? .white : .gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(isSaveEnabled ? Color.blue : Color.gray.opacity(0.5)))
            }
            .disabled(!isSaveEnabled)
        )
        .onAppear {
            loadExercise()
        }
    }

    private func loadExercise() {
        if let exercise = SessionRepository().getExerciseBySessionIdAndExerciseId(sessionId: sessionId, exerciseId: exerciseId) {
            originalExercise = exercise
            exerciseName = exercise.name
            isRepetitionBased = (exercise.type == .reps)
            sets = exercise.sets
            reps = exercise.count
            timeInSeconds = exercise.count
            videoURL = exercise.guidanceImageURL
            instructions = exercise.instruction
        }
    }

    private func saveChanges() {
        guard var session = SessionRepository().getById(by: sessionId),
              let index = session.exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }

        let updatedExercise = Exercise(
            id: exerciseId,
            name: exerciseName,
            type: isRepetitionBased ? .reps : .time,
            count: isRepetitionBased ? reps : timeInSeconds,
            sets: sets,
            guidanceImageURL: videoURL,
            instruction: instructions
        )

        session.exercises[index] = updatedExercise
        SessionRepository().update(session)
        presentationMode.wrappedValue.dismiss()
    }

    private var isSaveEnabled: Bool {
        guard let original = originalExercise else { return false }

        let currentType: ExerciseType = isRepetitionBased ? .reps : .time
        let currentCount = isRepetitionBased ? reps : timeInSeconds

        return exerciseName != original.name ||
               currentType != original.type ||
               currentCount != original.count ||
               sets != original.sets ||
               videoURL != original.guidanceImageURL ||
               instructions != original.instruction
    }
}

#Preview {
    PlanSessionExerciseView(sessionId: UUID(), exerciseId: UUID())
}
