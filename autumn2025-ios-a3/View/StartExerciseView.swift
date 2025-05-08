//
//  StartExerciseView.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 5/5/2025.
//

import SwiftUI

struct StartExerciseView: View {
    let record: ExerciseRecord
    var onComplete: (ExerciseRecord) -> Void = { _ in }
    
    @Environment(\.presentationMode) var presentationMode
    @State private var currentSet: Int = 1
    @State private var completed: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var showFeedbackSheet = false
    @State private var showUnfinishedSheet = false
    
    @State private var moodRating: Int = 3
    @State private var painRating: Int = 0
    @State private var note: String = ""
    
    @State private var selectedSetNumber: Int = 1

    var exercise: Exercise {
        guard let session = SessionRepository().getById(by: record.sessionId),
              let ex = session.exercises.first(where: { $0.id == record.exerciseId }) else {
            return Exercise(id: record.exerciseId, name: "Unknown", type: .reps, count: 0, sets: 0, guidanceImageURL: "", instruction: "")
        }
        return ex
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Exercise Name
            Text(exercise.name)
                .font(.title2)
                .bold()
            
            // Instruction
            VStack(alignment: .leading, spacing: 4) {
                Text("Instruction")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(exercise.instruction.isEmpty ? "No instruction" : exercise.instruction)
                    .font(.body)
            }
            
            // Sets
            if currentSet <= exercise.sets {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Set \(currentSet) of \(exercise.sets)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(exercise.count) \(exercise.type == .reps ? "Reps" : "Seconds")")
                        .font(.body)
                }
                
                HStack {
                    Button("Couldn’t Finish") {
                        selectedSetNumber = currentSet
                        showUnfinishedSheet = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    if currentSet < exercise.sets {
                        Button("Next") {
                            nextSetOrFinish()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else {
                        Button("Complete") {
                            showFeedbackSheet = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showExitAlert = true
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .alert("Are you sure you want to leave this session?", isPresented: $showExitAlert) {
            Button("Leave", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Stay", role: .cancel) { }
        }
        .sheet(isPresented: $showFeedbackSheet) {
            FeedbackSheet(
                record: record,
                onComplete: { updatedRecord in
                    onComplete(updatedRecord)
                    showFeedbackSheet = false
                }
            )
        }
        .sheet(isPresented: $showUnfinishedSheet) {
            UnfinishedSetSheet(
                record: record,
                setNumber: selectedSetNumber,
                onComplete: { updatedRecord in
                    onComplete(updatedRecord)
                    showUnfinishedSheet = false
                    nextSetOrFinish()
                }
            )
        }
    }
    
    private func nextSetOrFinish() {
        if currentSet < exercise.sets {
            currentSet += 1
        } else {
            completed = true
        }
    }
}

#Preview {
    ContentView(selection: .plan)
}
