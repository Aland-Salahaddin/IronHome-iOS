//
//  WorkoutDetailView.swift
//  IronHome
//
//  Pre-workout overview detailing exercises, targets, equipment, and warm-up checklist
//

import SwiftUI

public struct WorkoutDetailView: View {
    @ObservedObject var store: WorkoutStore
    let schedule: WorkoutDaySchedule
    @State private var showingActiveSession: Bool = false
    @State private var selectedExerciseForDetail: ExerciseDefinition? = nil
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(schedule.dayName.uppercased())
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(schedule.isRestDay ? Color.teal.opacity(0.18) : Color.blue.opacity(0.18))
                            .foregroundColor(schedule.isRestDay ? .teal : .blue)
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        if !schedule.isRestDay {
                            Label("~\(schedule.estimatedMinutes) min", systemImage: "clock")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(schedule.title)
                        .font(.title2.bold())
                    
                    Text(schedule.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Rest Day Recovery Guidance
                if schedule.isRestDay {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "bed.double.circle.fill")
                                .font(.title)
                                .foregroundColor(.teal)
                            Text("Rest & Regeneration Protocol")
                                .font(.headline)
                        }
                        
                        Text(schedule.recoveryGuidance ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(Color.teal.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    // Equipment Needed Checklist
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Equipment Required")
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 10) {
                            EquipmentChip(icon: "bed.double.fill", name: "Flat Bench")
                            EquipmentChip(icon: "dumbbell.fill", name: "Dumbbells")
                            EquipmentChip(icon: "scalemass.fill", name: "Barbell")
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // Exercise List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Routine Exercises (\(schedule.exercises.count))")
                            .font(.headline)
                        
                        ForEach(Array(schedule.exercises.enumerated()), id: \.element.id) { index, exercise in
                            Button(action: {
                                selectedExerciseForDetail = exercise
                            }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.15))
                                            .frame(width: 32, height: 32)
                                        Text("\(index + 1)")
                                            .font(.caption.bold())
                                            .foregroundColor(.blue)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(exercise.name)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(exercise.targetMuscles)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(exercise.setsDisplay)
                                            .font(.caption.bold())
                                            .foregroundColor(.blue)
                                        
                                        Image(systemName: "info.circle")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    // Start Workout Action Button
                    Button(action: {
                        store.startWorkout(for: schedule)
                        showingActiveSession = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start \(schedule.dayName) Workout")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color.blue.opacity(0.35), radius: 6, x: 0, y: 3)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        .navigationTitle(schedule.dayName)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingActiveSession) {
            ActiveWorkoutSessionView(store: store)
        }
        .sheet(item: $selectedExerciseForDetail) { exercise in
            ExerciseDetailModalView(exercise: exercise)
        }
    }
}

private struct EquipmentChip: View {
    let icon: String
    let name: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(name)
                .font(.caption.bold())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(UIColor.secondarySystemBackground))
        .foregroundColor(.primary)
        .clipShape(Capsule())
    }
}
