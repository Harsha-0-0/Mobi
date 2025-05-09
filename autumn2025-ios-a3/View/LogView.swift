//
//  LogView.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 1/5/2025.
//

import SwiftUI
//this is the log page with a calendar to view exercise logs for each day.
struct LogView: View {
    @State private var date = Date()
    @State private var exercisesByDate: [Date: [ExerciseRecord]] = [:]
    @State private var completionByDate: [Date: Double] = [:]
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                DatePicker(
                    "Pick a date",
                    selection: $date,
                    displayedComponents: .date)
                .datePickerStyle(.graphical)
                .scaleEffect(1.1)
                .frame(maxWidth: .infinity, maxHeight: 450)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
                )
                // Display completion progress for selected date
                if let completion = completionByDate[Calendar.current.startOfDay(for: date)] {
                    HStack {
                        Text("Completion Rate:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ProgressView(value: completion)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .frame(maxWidth: .infinity)
                        
                        Text("\(Int(completion * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                } else {
                    Text("No log data available for this date.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                //show the details for selected day in calendar
                NavigationLink(destination: LogDetailView(date: date)) {
                    Text("View Log Details")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.blueButton))
                    
                }
                Spacer()
                    .navigationTitle("Log")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        loadExerciseRecords()
                    }
            }
            .padding()
        }
    }
    private func loadExerciseRecords() {
        // Load all exercise records
        let allRecords = ExerciseRecordRepository().listAll()
        
        // Group records by date and calculate completion rate for each date
        var recordsByDate: [Date: [ExerciseRecord]] = [:]
        var completionRates: [Date: Double] = [:]
        
        for record in allRecords {
            // Get start of day for the record date
            let calendar = Calendar.current
            let dateKey = calendar.startOfDay(for: record.date)
            
            // Add to groupings
            if recordsByDate[dateKey] == nil {
                recordsByDate[dateKey] = []
            }
            recordsByDate[dateKey]?.append(record)
        }
        
        // Calculate completion rate for each date
        for (date, records) in recordsByDate {
            let totalRecords = records.count
            if totalRecords > 0 {
                let completedRecords = records.filter { $0.isDone }.count
                completionRates[date] = Double(completedRecords) / Double(totalRecords)
            }
        }
        
        self.exercisesByDate = recordsByDate
        self.completionByDate = completionRates
        
        // checking
        print("Loaded \(allRecords.count) exercise records across \(recordsByDate.count) days")
    }
}



#Preview {
    ContentView(selection: .log)
}
