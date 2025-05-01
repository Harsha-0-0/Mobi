//
//  Session.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import Foundation

struct Session: Codable {
    let id: UUID
    let name: String
    let startDate: Date
    let endDate: Date
    let exercises: [Exercise]

    init(name: String, startDate: Date, endDate: Date, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.exercises = exercises
    }
}
