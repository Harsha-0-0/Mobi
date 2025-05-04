//
//  PlanNewExerciseView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 4/5/2025.
//

import SwiftUI

struct PlanSessionNewExerciseView: View {
    let sessionId: UUID

    @Environment(\.presentationMode) var presentationMode

    @State private var exerciseName = ""
    @State private var isRepetitionBased = true
    @State private var sets = 1
    @State private var reps = 10
    @State private var timeInSeconds = 30
    @State private var videoURL = ""
    @State private var instructions = ""

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
            Button(action: {
                let type: ExerciseType = isRepetitionBased ? .reps : .time
                let count = isRepetitionBased ? reps : timeInSeconds

                let exercise = Exercise(
                    name: exerciseName,
                    type: type,
                    count: count,
                    sets: sets,
                    guidanceImageURL: videoURL,
                    instruction: instructions
                )

                SessionRepository().addExercise(to: sessionId, exercise: exercise)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.blue))
            }
        )
    }
}

#Preview {
    ContentView(selection: .plan)
}
