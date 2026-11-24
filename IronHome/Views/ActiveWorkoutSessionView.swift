//
//  ActiveWorkoutSessionView.swift
//  IronHome
//
//  Live workout tracking screen with set logging, previous performance,
//  top-of-rep-range progression detection, and floating rest timer.
//

import SwiftUI

public struct ActiveWorkoutSessionView: View {
    @ObservedObject var store: WorkoutStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var elapsedSeconds: Int = 0
    @State private var timerCancellable: Timer? = nil
    @State private var showingDiscardAlert: Bool = false
    @State private var showingFinishSummary: Bool = false
    @State private var selectedExerciseForDetail: ExerciseDefinition? = nil
    @State private var selectedExerciseForWarmup: (exercise: ExerciseDefinition, index: Int)? = nil
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Top Session Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(store.activeSession?.scheduleTitle ?? "Active Workout")
                                    .font(.title3.bold())
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text("\(store.activeSession?.totalWorkingSets ?? 0) working sets done")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(String(format: "%.0f", store.activeSession?.totalVolumeKg ?? 0)) kg vol")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            // Elapsed duration stopwatch
                            HStack(spacing: 4) {
                                Image(systemName: "stopwatch.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                Text(timeFormatted(elapsedSeconds))
                                    .font(.system(.subheadline, design: .monospaced).bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Exercise Cards
                        if let session = store.activeSession {
                            ForEach(Array(session.exercises.enumerated()), id: \.element.id) { exIndex, exLog in
                                let exDef = findDefinition(for: exLog.exerciseId)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    // Exercise Header
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exLog.exerciseName)
                                                .font(.headline)
                                            
                                            if let def = exDef {
                                                Text(def.targetMuscles)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        // Warmup guide trigger
                                        if let def = exDef, def.warmupRecommended {
                                            Button(action: {
                                                selectedExerciseForWarmup = (def, exIndex)
                                            }) {
                                                Image(systemName: "flame.circle")
                                                    .font(.subheadline)
                                                    .foregroundColor(.orange)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                        
                                        // Form info button
                                        if let def = exDef {
                                            Button(action: {
                                                selectedExerciseForDetail = def
                                            }) {
                                                Image(systemName: "info.circle")
                                                    .font(.subheadline)
                                                    .foregroundColor(.blue)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    
                                    // Target rep range reminder
                                    if let def = exDef {
                                        HStack {
                                            Text("Target: \(def.setsDisplay)")
                                                .font(.caption2.bold())
                                                .foregroundColor(.secondary)
                                            
                                            if def.equipment.contains(.flatBench) {
                                                Text("• Flat Bench")
                                                    .font(.caption2)
                                                    .foregroundColor(.indigo)
                                            }
                                        }
                                    }
                                    
                                    // Sets Column Header
                                    HStack(spacing: 12) {
                                        Text("SET")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 22, alignment: .leading)
                                        
                                        Text("PREV")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 75, alignment: .leading)
                                        
                                        Text("KG")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 80, alignment: .center)
                                        
                                        Text("REPS")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 72, alignment: .center)
                                        
                                        Spacer()
                                        
                                        Text("LOG")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 30, alignment: .trailing)
                                    }
                                    .padding(.horizontal, 10)
                                    
                                    // Set Rows
                                    let prevPerf = ProgressionEngine.getPreviousPerformance(exerciseId: exLog.exerciseId, from: store.history)
                                    let maxTarget = exDef?.maxReps ?? 12
                                    
                                    ForEach(Array(exLog.sets.enumerated()), id: \.element.id) { sIndex, setRecord in
                                        SetRowView(
                                            store: store,
                                            exerciseIndex: exIndex,
                                            setIndex: sIndex,
                                            setRecord: setRecord,
                                            previousPerformance: prevPerf,
                                            maxRepsTarget: maxTarget
                                        )
                                    }
                                    
                                    // Add Set Button
                                    Button(action: {
                                        store.addSet(to: exIndex)
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.caption)
                                            Text("Add Set")
                                                .font(.caption.bold())
                                        }
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    
                                    // Progression Engine Live Feedback
                                    if let def = exDef {
                                        let status = ProgressionEngine.evaluateProgression(for: def, completedSets: exLog.sets)
                                        ProgressionBadgeView(status: status)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal)
                            }
                        }
                        
                        // Bottom Actions: Discard & Finish
                        VStack(spacing: 12) {
                            Button(action: {
                                showingFinishSummary = true
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.seal.fill")
                                    Text("Finish Workout")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.green.opacity(0.35), radius: 6, x: 0, y: 3)
                            }
                            
                            Button(action: {
                                showingDiscardAlert = true
                            }) {
                                Text("Discard Session")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 90) // Extra padding for floating timer
                    }
                }
                
                // Floating Rest Timer
                FloatingRestTimerBar(store: store)
            }
            .navigationTitle("Workout in Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Minimize") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                startStopwatch()
            }
            .onDisappear {
                stopStopwatch()
            }
            .alert(isPresented: $showingDiscardAlert) {
                Alert(
                    title: Text("Discard Workout?"),
                    message: Text("All recorded sets for this session will be lost."),
                    primaryButton: .destructive(Text("Discard")) {
                        store.discardActiveWorkout()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(item: $selectedExerciseForDetail) { ex in
                ExerciseDetailModalView(exercise: ex)
            }
            .sheet(item: Binding(
                get: { selectedExerciseForWarmup != nil ? WarmupModalIdentifiable(item: selectedExerciseForWarmup!) : nil },
                set: { _ in selectedExerciseForWarmup = nil }
            )) { wrapper in
                let currentWorkingWeight = store.activeSession?.exercises[wrapper.item.index].sets.first(where: { !$0.isWarmup })?.weightKg ?? 20.0
                WarmupGuideModal(
                    exerciseName: wrapper.item.exercise.name,
                    workingWeightKg: currentWorkingWeight,
                    onAddWarmupSet: {
                        store.addWarmupSet(to: wrapper.item.index)
                    }
                )
            }
            .sheet(isPresented: $showingFinishSummary) {
                WorkoutFinishSummaryView(store: store, elapsedSeconds: elapsedSeconds) {
                    store.finishActiveWorkout()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func startStopwatch() {
        if let started = store.activeSession?.startedAt {
            elapsedSeconds = max(0, Int(Date().timeIntervalSince(started)))
        }
        timerCancellable = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }
    
    private func stopStopwatch() {
        timerCancellable?.invalidate()
        timerCancellable = nil
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func findDefinition(for id: String) -> ExerciseDefinition? {
        for s in store.schedules {
            if let matched = s.exercises.first(where: { $0.id == id }) {
                return matched
            }
        }
        return nil
    }
}

// Helper identifiable wrapper for warmup sheet
private struct WarmupModalIdentifiable: Identifiable {
    let id = UUID()
    let item: (exercise: ExerciseDefinition, index: Int)
}
