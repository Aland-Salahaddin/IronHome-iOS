//
//  WorkoutFinishSummaryView.swift
//  IronHome
//
//  Workout completion celebration and performance recap
//

import SwiftUI

public struct WorkoutFinishSummaryView: View {
    @ObservedObject var store: WorkoutStore
    let elapsedSeconds: Int
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int = 5
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Trophy & Celebration Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.yellow)
                        }
                        
                        Text("Workout Complete!")
                            .font(.title.bold())
                        
                        Text(store.activeSession?.scheduleTitle ?? "Session Finished")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    // Stats Grid
                    HStack(spacing: 12) {
                        StatCard(
                            icon: "clock.fill",
                            value: "\(max(1, elapsedSeconds / 60)) min",
                            label: "Duration",
                            color: .blue
                        )
                        
                        StatCard(
                            icon: "scalemass.fill",
                            value: "\(String(format: "%.0f", store.activeSession?.totalVolumeKg ?? 0)) kg",
                            label: "Total Volume",
                            color: .purple
                        )
                        
                        StatCard(
                            icon: "checkmark.seal.fill",
                            value: "\(store.activeSession?.totalWorkingSets ?? 0)",
                            label: "Sets Done",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Progression Highlights
                    if let session = store.activeSession {
                        let progressionExercises = session.exercises.filter { ex in
                            ex.sets.filter({ $0.isCompleted && !$0.isWarmup }).count >= 3 &&
                            ex.sets.filter({ $0.isCompleted && !$0.isWarmup }).allSatisfy({ $0.reps >= 10 })
                        }
                        
                        if !progressionExercises.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.green)
                                    Text("Overload Milestones Ready")
                                        .font(.headline)
                                }
                                
                                ForEach(progressionExercises, id: \.id) { ex in
                                    HStack {
                                        Image(systemName: "arrow.up.right.circle.fill")
                                            .foregroundColor(.green)
                                        Text(ex.exerciseName)
                                            .font(.subheadline.bold())
                                        Spacer()
                                        Text("+1.0 to +2.5 kg next time")
                                            .font(.caption2.bold())
                                            .foregroundColor(.green)
                                    }
                                    .padding(10)
                                    .background(Color.green.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                    }
                    
                    // Rating / Effort
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Session Effort / Recovery Feeling")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    rating = star
                                }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(star <= rating ? .orange : Color(UIColor.systemGray4))
                                }
                            }
                            
                            Spacer()
                            
                            Text(ratingTitle(for: rating))
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Save & Commit Button
                    Button(action: {
                        onSave()
                    }) {
                        Text("Save & Log Workout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.blue.opacity(0.35), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func ratingTitle(for stars: Int) -> String {
        switch stars {
        case 1: return "Exhausted / Low Energy"
        case 2: return "Tough Session"
        case 3: return "Good Effort"
        case 4: return "Strong & Controlled"
        case 5: return "Peak Performance!"
        default: return ""
        }
    }
}

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.subheadline, design: .rounded).bold())
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
