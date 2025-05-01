//
//  SessionRepository.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import Foundation

class SessionRepository {
    private let userDefaults = UserDefaults.standard
    private let key = "sessions"

    func save(_ session: Session) {
        var sessions = listAll()
        sessions.append(session)
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func saveAll(_ sessions: [Session]) {
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: key)
        }
    }

    func listAll() -> [Session] {
        guard let data = userDefaults.data(forKey: key),
              let sessions = try? JSONDecoder().decode([Session].self, from: data) else {
            return []
        }
        return sessions
    }
}

