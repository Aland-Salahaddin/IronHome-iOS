//
//  ScheduleView.swift
//  IronHome
//
//  Weekly 4-Day Upper/Lower Split + Day 5 Accessory Routine Dashboard
//

import SwiftUI

public struct ScheduleView: View {
    @ObservedObject var store: WorkoutStore
    @State private var showingActiveSessionSheet: Bool = false
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 18) {
                    // Top Hero Banner
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label("HOME HYPERTROPHY", systemImage: "bolt.shield.fill")
                                .font(.caption.bold())
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("4-Day Split + Acc.")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.white.opacity(0.18))
                                .clipShape(Capsule())
                        }
                        
                        Text("Beginner Muscle & Strength")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Dumbbells • Barbell • Flat Bench Only")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Active Workout Banner if in progress
                        if store.isSessionActive {
                            Button(action: {
                                showingActiveSessionSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "figure.strengthtraining.traditional")
                                    Text("Resume Current Workout")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Image(systemName: "arrow.right.circle.fill")
                                }
                                .padding(12)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color(red: 0.1, green: 0.2, blue: 0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal)
                    
                    // Week Days List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Training Schedule")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(store.schedules) { schedule in
                            NavigationLink(destination: WorkoutDetailView(store: store, schedule: schedule)) {
                                WorkoutDayCard(schedule: schedule)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }
            .navigationTitle("IronHome")
            .fullScreenCover(isPresented: $showingActiveSessionSheet) {
                ActiveWorkoutSessionView(store: store)
            }
        }
    }
}

private struct WorkoutDayCard: View {
    let schedule: WorkoutDaySchedule
    
    var body: some View {
        HStack(spacing: 14) {
            // Day badge
            VStack(spacing: 2) {
                Text(schedule.dayName.replacingOccurrences(of: "Day ", with: "D"))
                    .font(.system(.title3, design: .rounded).bold())
                    .foregroundColor(schedule.isRestDay ? .teal : .blue)
                
                Text(schedule.isRestDay ? "REST" : "LIFT")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(schedule.isRestDay ? .teal : .blue)
            }
            .frame(width: 48, height: 48)
            .background((schedule.isRestDay ? Color.teal : Color.blue).opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(schedule.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    if !schedule.isRestDay {
                        Text("\(schedule.exercises.count) exercises")
                            .font(.caption2.bold())
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(schedule.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
