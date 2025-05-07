//
//  ExerciseRecordRepository.swift
//  autumn2025-ios-a3
//
//  Created by Hazel Chen on 6/5/2025.
//

import Foundation

class ExerciseRecordRepository {
    private let userDefaults = UserDefaults.standard
    private let key = "exerciseRecords"

    func listAll() -> [ExerciseRecord] {
        guard let data = userDefaults.data(forKey: key),
              let records = try? JSONDecoder().decode([ExerciseRecord].self, from: data) else {
            return []
        }
        return records
    }

    func listByDate(_ date: Date) -> [ExerciseRecord] {
        let calendar = Calendar.current
        return listAll().filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }

    func save(_ record: ExerciseRecord) {
        var records = listAll()
        records.append(record)
        saveAll(records)
    }

    func saveAll(_ records: [ExerciseRecord]) {
        if let data = try? JSONEncoder().encode(records) {
            userDefaults.set(data, forKey: key)
        }
    }

    func update(_ updatedRecord: ExerciseRecord) {
        var records = listAll()
        if let index = records.firstIndex(where: { $0.id == updatedRecord.id }) {
            records[index] = updatedRecord
            saveAll(records)
        }
    }

    func deleteAll() {
        userDefaults.removeObject(forKey: key)
    }
}
