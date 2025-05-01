//
//  Exercise.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import Foundation

enum ExerciseType: Codable {
    case reps
    case time
}

struct Exercise: Codable {
    let id: UUID
    let name: String
    let type: ExerciseType
    let count: Int
    let sets: Int
    let guidanceImageURL: String
    let instruction: String

    init(name: String, description: String, type: ExerciseType, count:Int, sets: Int, guidanceImageURL: String, instruction: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.count = count
        self.sets = sets
        self.guidanceImageURL = guidanceImageURL
        self.instruction = instruction
    }
}
