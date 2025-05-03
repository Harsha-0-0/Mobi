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
        print("save")
        var sessions = listAll()
        sessions.append(session)
        
        do {
            let data = try JSONEncoder().encode(sessions)
            userDefaults.set(data, forKey: key)
            print("Session saved successfully: \(session)") // Debug statement
        } catch {
            print("Failed to encode sessions: \(error)")
        }
    }
    
    func saveAll(_ sessions: [Session]) {
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func update(_ session: Session) {
        var sessions = listAll()
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveAll(sessions)
        }
    }

    func listAll() -> [Session] {
        guard let data = userDefaults.data(forKey: key),
              let sessions = try? JSONDecoder().decode([Session].self, from: data) else {
            return []
        }
        return sessions
    }
    
    func deleteAll() {
        userDefaults.removeObject(forKey: key)
        print("All sessions deleted successfully.") // Debug statement
    }
}

