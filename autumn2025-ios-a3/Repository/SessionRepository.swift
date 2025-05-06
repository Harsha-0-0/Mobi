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

    func getById(by id: UUID) -> Session? {
        return listAll().first(where: { $0.id == id })
    }

    func save(_ session: Session) {
        var sessions = listAll()
        sessions.append(session)
        
        do {
            let data = try JSONEncoder().encode(sessions)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save sessions: \(error)")
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
    
    func getCurrentSession() -> Session? {
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return listAll().first(where: { $0.startDate <= endOfDay && $0.endDate >= startOfDay })
    }


    func getPastSessions() -> [Session] {
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        return listAll().filter { $0.endDate < startOfDay }
    }

    func getUpcomingSessions() -> [Session] {
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return listAll().filter { $0.startDate > endOfDay }
    }

    func deleteById(sessionId: UUID) {
        var sessions = listAll()
        sessions.removeAll { $0.id == sessionId }
        saveAll(sessions)
    }
    
    func deleteAll() {
        userDefaults.removeObject(forKey: key)
    }
    
    func getExerciseBySessionIdAndExerciseId(sessionId: UUID, exerciseId: UUID) -> Exercise? {
        guard let session = getById(by: sessionId) else {
            return nil
        }
        return session.exercises.first(where: { $0.id == exerciseId })
    }
    
    func addExercise(to sessionId: UUID, exercise: Exercise) {
        guard var session = getById(by: sessionId) else {
            return
        }

        session.exercises.append(exercise)
        update(session)
    }
    
    func deleteExercise(sessionId: UUID, exerciseId: UUID) {
        guard var session = getById(by: sessionId) else {
            return
        }
        
        session.exercises.removeAll { $0.id == exerciseId }
        update(session)
    }
    
    func hasOverlappingSession(start: Date, end: Date) -> Bool {
        return listAll().contains { session in
            return start <= session.endDate && end >= session.startDate
        }
    }
}

