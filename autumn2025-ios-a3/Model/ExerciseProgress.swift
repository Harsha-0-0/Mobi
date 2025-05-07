//
//  ExerciseProgress.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 5/5/2025.
//

import Foundation

struct ExerciseProgress: Identifiable {
    var id: UUID { exercise.id }
    let sessionId: UUID
    var exercise: Exercise
    var isDone: Bool = false
}
