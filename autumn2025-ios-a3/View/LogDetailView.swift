//
//  LogDetailView.swift
//  autumn2025-ios-a3
//
//  Created by Harshi on 05/05/25.
//

import SwiftUI

enum ExType {
    case reps
    case duration
}

struct HardcodedExercise: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let type: ExType
}

struct LogDetailView: View {
    var date: Date
    
    @State private var selectedExercise: HardcodedExercise?
    //hardcoding exercise to check the view
    let allExercises: [HardcodedExercise] = [
        HardcodedExercise(name: "Jump", count: 20, type: .duration),
        HardcodedExercise(name: "Sit Ups", count: 25, type: .reps),
        HardcodedExercise(name: "Squats", count: 15, type: .reps)
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                //to display no exercise message or show the log details
                if !allExercises.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Exercise")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Completion Rate")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        // showing the hardcoded exercise here - will replace later with data from the start session
                        ForEach(allExercises, id: \.id) { exercise in
                            HStack {
                                Text(exercise.name)
                                Spacer()
                                ProgressView(value: Double(exercise.count), total: exercise.type == .reps ? 30 : 60)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                    .frame(width: 120)
                                Text(exercise.type == .reps ? "\(exercise.count)/30 reps" : "\(exercise.count)/60 sec")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Showing the selected Exercise Details (Painful, difficulty, note)
                        if let exercise = selectedExercise {
                            Divider()
                            
                            // Exercise Selector - using hardcoded exercises
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(allExercises, id: \.id) { ex in
                                        Button(action: {
                                            selectedExercise = ex
                                        }) {
                                            Text(ex.name)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(selectedExercise?.id == ex.id ? Color.blue.opacity(0.2) : Color.clear)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(selectedExercise?.id == ex.id ? Color.blue : Color.gray.opacity(0.4), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                            //adding some values to check the exercise selector function - according to the selected exercise, we change the information
                            let (painful, difficulty, note): (Double, Double, String) = {
                                switch exercise.name.lowercased() {
                                case "jump":
                                    return (0.1, 0.2, "When doing this, the first 15 seconds are fine, but it gets a bit hard toward the end.")
                                case "sit ups":
                                    return (0.4, 0.8, "When doing this, my knee hurts.")
                                case "squats":
                                    return (0.2, 0.5, "Legs feel sore after a few sets.")
                                default:
                                    return (0.0, 0.0, "No specific notes.")
                                }
                            }()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Painful")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ProgressView(value: painful)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                Text("\(Int(painful * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Difficulty")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ProgressView(value: difficulty)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                Text("\(Int(difficulty * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Note")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(note)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                    }
                } else {
                    Text("No exercises found for this date.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationTitle(date.formatted(date: .long, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedExercise = allExercises.first//showing the first exercise by default
            
        }
    }
}
#Preview {
    NavigationStack {
        LogDetailView(date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 12))!)
    }
}

