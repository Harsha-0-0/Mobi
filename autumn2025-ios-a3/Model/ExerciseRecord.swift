//
//  ExerciseRecord.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 6/5/2025.
//

import Foundation

struct ExerciseRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var sessionId: UUID
    var exerciseId: UUID
    var isDone: Bool
    var setResults: [SetResult]
    var overallFeedback: ExerciseFeedback?
}

struct SetResult: Identifiable, Codable {
    var id = UUID()
    var setNumber: Int
    var isCompleted: Bool
    var actualValue: Int
    var note: String?
}

struct ExerciseFeedback: Codable {
    var moodRating: Int
    var painRating: Int
    var finalNote: String?
}
