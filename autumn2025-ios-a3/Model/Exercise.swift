//
//  Exercise.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import Foundation

struct Exercise: Codable {
    let id: UUID
    var name: String
    var type: ExerciseType
    var count: Int
    var sets: Int
    var guidanceImageURL: String
    var instruction: String

    init(name: String, type: ExerciseType, count:Int, sets: Int, guidanceImageURL: String, instruction: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.count = count
        self.sets = sets
        self.guidanceImageURL = guidanceImageURL
        self.instruction = instruction
    }
    
    init(id: UUID, name: String, type: ExerciseType, count: Int, sets: Int, guidanceImageURL: String, instruction: String) {
        self.id = id
        self.name = name
        self.type = type
        self.count = count
        self.sets = sets
        self.guidanceImageURL = guidanceImageURL
        self.instruction = instruction
    }
}
