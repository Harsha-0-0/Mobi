//
//  Session.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import Foundation

struct Session: Codable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date
    var exercises: [Exercise]

    init(name: String, startDate: Date, endDate: Date, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.exercises = exercises
    }
    
    var isActive: Bool {
        let today = Date()
        return startDate <= today && today <= endDate
    }
    
}
