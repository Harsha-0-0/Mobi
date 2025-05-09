//
//  LogDetailView.swift
//  autumn2025-ios-a3
//
//  Created by Harshi on 05/05/25.
//

import SwiftUI

struct LogDetailView: View {
    var date: Date
    
    @State private var records: [ExerciseRecord] = []
    @State private var selectedRecord: ExerciseRecord?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                //to display no exercise message
                if records.isEmpty {
                    VStack(spacing: 12) {
                        Spacer(minLength: 40)
                        Image(systemName: "clipboard")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No exercises found for this date.")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    HStack {
                        Text("Exercise")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Completion")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 4)
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exerciseName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            // Calculate completed sets
                            let actualCompleted = record.isDone ? record.totalSets :
                            record.setResults.isEmpty ? 0 :
                            record.totalSets - record.setResults.count
                            
                            let completion = Double(actualCompleted) / Double(max(record.totalSets, 1))
                            
                            HStack(spacing: 8) {
                                ProgressView(value: completion)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                    .frame(width: 80)
                                Text("\(actualCompleted)/\(record.totalSets) sets")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    // showing the selector buttons to show feedback of the selected exercise
                    if !records.isEmpty {
                        Divider().padding(.vertical, 10)
                        Text("Select Exercise")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 4)
                        exerciseSelectorView()
                        
                        if let record = selectedRecord {
                            detailsView(for: record)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(date.formatted(date: .long, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadData()
        }
    }
    
    // this is the logic for selector buttons
    @ViewBuilder
    private func exerciseSelectorView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(records, id: \.id) { record in
                    Button(action: {
                        selectedRecord = record
                    }) {
                        Text(record.exerciseName)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedRecord?.id == record.id ?
                                        Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedRecord?.id == record.id ?
                                            Color.blue : Color.gray.opacity(0.4),
                                            lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // according to the selected exercise, we show, pain, mood, and notes
    @ViewBuilder
    private func detailsView(for record: ExerciseRecord) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let feedback = record.overallFeedback {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pain Level")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ProgressView(value: Double(feedback.painRating) / 10.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    
                    Text("\(feedback.painRating)/10")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mood Rating")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ProgressView(value: Double(feedback.moodRating) / 10.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    
                    Text("\(feedback.moodRating)/10")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                if let finalNote = feedback.finalNote, !finalNote.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Final Note")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(finalNote)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(8)
                    }
                }
            } else {
                Text("No feedback available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    // initial log data is loaded here according to the date
    private func loadData() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        records = ExerciseRecordRepository().listByDate(startOfDay)
        selectedRecord = records.first
        
        print("Loaded \(records.count) records for \(startOfDay)")
    }
    
    
}
#Preview {
    NavigationStack {
        LogDetailView(date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 9))!)
    }
}

