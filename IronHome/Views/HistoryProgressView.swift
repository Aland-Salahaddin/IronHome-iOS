//
//  HistoryProgressView.swift
//  IronHome
//
//  Historical log of completed workouts, volume analytics, and progression tracking
//

import SwiftUI

public struct HistoryProgressView: View {
    @ObservedObject var store: WorkoutStore
    @State private var selectedSession: WorkoutSessionLog? = nil
    
    private var totalTonnageKg: Double {
        store.history.reduce(0.0) { $0 + $1.totalVolumeKg }
    }
    
    private var totalWorkingSets: Int {
        store.history.reduce(0) { $0 + $1.totalWorkingSets }
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Career Stats Overview
                    HStack(spacing: 12) {
                        CareerStatBox(
                            icon: "trophy.fill",
                            value: "\(store.history.count)",
                            label: "Workouts",
                            color: .orange
                        )
                        
                        CareerStatBox(
                            icon: "scalemass.fill",
                            value: "\(String(format: "%.0f", totalTonnageKg)) kg",
                            label: "Total Volume",
                            color: .blue
                        )
                        
                        CareerStatBox(
                            icon: "repeat.circle.fill",
                            value: "\(totalWorkingSets)",
                            label: "Sets Logged",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Session List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Past Sessions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if store.history.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "dumbbell")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary.opacity(0.5))
                                Text("No workouts logged yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Complete Day 1 Upper A to start building your strength history!")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .padding(.horizontal)
                        } else {
                            ForEach(store.history) { session in
                                Button(action: {
                                    selectedSession = session
                                }) {
                                    SessionHistoryCard(session: session)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("History & Progress")
            .sheet(item: $selectedSession) { session in
                SessionDetailModalView(session: session)
            }
        }
    }
}

private struct CareerStatBox: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.subheadline, design: .rounded).bold())
            
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct SessionHistoryCard: View {
    let session: WorkoutSessionLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.scheduleTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(formattedDate(session.startedAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...session.sessionRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 16) {
                Label("\(max(1, session.durationSeconds / 60)) min", systemImage: "clock")
                Label("\(session.totalWorkingSets) sets", systemImage: "checkmark.seal")
                Label("\(String(format: "%.0f", session.totalVolumeKg)) kg", systemImage: "scalemass")
            }
            .font(.caption.bold())
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private struct SessionDetailModalView: View {
    @Environment(\.presentationMode) var presentationMode
    let session: WorkoutSessionLog
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text(session.scheduleTitle)
                            .font(.title2.bold())
                        
                        Text(session.startedAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Exercises Breakdown
                    ForEach(session.exercises) { ex in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(ex.exerciseName)
                                .font(.headline)
                            
                            ForEach(ex.completedWorkingSets) { s in
                                HStack {
                                    Text("Set \(s.setNumber)")
                                        .font(.caption.bold())
                                        .frame(width: 50, alignment: .leading)
                                    
                                    Text("\(String(format: "%.1f", s.weightKg)) kg")
                                        .font(.subheadline)
                                        .frame(width: 70, alignment: .leading)
                                    
                                    Text("× \(s.reps) reps")
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.0f", s.weightKg * Double(s.reps))) kg vol")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            
                            if !ex.userNotes.isEmpty {
                                Text("Notes: \(ex.userNotes)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
