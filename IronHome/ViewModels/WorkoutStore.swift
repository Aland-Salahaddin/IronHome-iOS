//
//  WorkoutStore.swift
//  IronHome
//
//  Central state management for workout tracking, active sessions,
//  rest timer engine, and local persistence.
//

import Foundation
import Combine
import SwiftUI
#if canImport(AudioToolbox)
import AudioToolbox
#endif

public final class WorkoutStore: ObservableObject {
    // MARK: - Published State
    @Published public var schedules: [WorkoutDaySchedule] = WorkoutRoutine.standardSchedule
    @Published public var history: [WorkoutSessionLog] = []
    @Published public var activeSession: WorkoutSessionLog? = nil
    
    // Rest Timer Engine
    @Published public var restTimeRemaining: Int = 0
    @Published public var restDurationTotal: Int = 90
    @Published public var isRestTimerRunning: Bool = false
    @Published public var lastTimerCompletedAt: Date? = nil
    
    // User Settings
    @AppStorage("autoStartRestTimer") public var autoStartRestTimer: Bool = true
    @AppStorage("defaultRestSeconds") public var defaultRestSeconds: Int = 90
    @AppStorage("showWarmupAlerts") public var showWarmupAlerts: Bool = true
    @AppStorage("preferredWeightUnit") public var preferredWeightUnit: String = "kg"
    
    private var timerCancellable: AnyCancellable?
    private let historyStorageKey = "IronHome_WorkoutHistory_v1"
    
    public init() {
        loadHistory()
        if history.isEmpty {
            seedInitialDemoLog()
        }
    }
    
    // MARK: - Active Session Management
    
    public var isSessionActive: Bool {
        return activeSession != nil
    }
    
    public func startWorkout(for schedule: WorkoutDaySchedule) {
        var exerciseLogs: [ExerciseSessionLog] = []
        
        for exercise in schedule.exercises {
            var sets: [WorkoutSetRecord] = []
            
            // Check previous session for starting weight suggestions
            let previousWeight = ProgressionEngine.getPreviousPerformance(exerciseId: exercise.id, from: history)?.weightKg ?? 15.0
            
            // Generate default sets
            let count = exercise.defaultSets
            let targetReps = exercise.targetDurationSeconds ?? exercise.minReps
            
            for setNum in 1...count {
                sets.append(
                    WorkoutSetRecord(
                        setNumber: setNum,
                        weightKg: previousWeight,
                        reps: targetReps,
                        isCompleted: false,
                        isWarmup: false
                    )
                )
            }
            
            exerciseLogs.append(
                ExerciseSessionLog(
                    exerciseId: exercise.id,
                    exerciseName: exercise.name,
                    sets: sets,
                    userNotes: ""
                )
            )
        }
        
        activeSession = WorkoutSessionLog(
            scheduleId: schedule.id,
            scheduleTitle: schedule.title,
            startedAt: Date(),
            exercises: exerciseLogs,
            isCompleted: false
        )
    }
    
    public func finishActiveWorkout(rating: Int = 5) {
        guard var session = activeSession else { return }
        session.endedAt = Date()
        session.durationSeconds = max(60, Int(session.endedAt!.timeIntervalSince(session.startedAt)))
        session.isCompleted = true
        session.sessionRating = rating
        
        // Remove empty or uncompleted sets if needed, or preserve as logged
        history.insert(session, at: 0)
        saveHistory()
        activeSession = nil
        stopRestTimer()
    }
    
    public func discardActiveWorkout() {
        activeSession = nil
        stopRestTimer()
    }
    
    // MARK: - Set Updates
    
    public func toggleSetCompleted(exerciseIndex: Int, setIndex: Int) {
        guard activeSession != nil,
              exerciseIndex < activeSession!.exercises.count,
              setIndex < activeSession!.exercises[exerciseIndex].sets.count else { return }
        
        activeSession!.exercises[exerciseIndex].sets[setIndex].isCompleted.toggle()
        let isNowCompleted = activeSession!.exercises[exerciseIndex].sets[setIndex].isCompleted
        
        if isNowCompleted {
            activeSession!.exercises[exerciseIndex].sets[setIndex].completedAt = Date()
            triggerHapticFeedback(.success)
            
            // Auto start rest timer
            if autoStartRestTimer {
                startRestTimer(seconds: defaultRestSeconds)
            }
        }
    }
    
    public func updateSetWeight(exerciseIndex: Int, setIndex: Int, weight: Double) {
        guard activeSession != nil,
              exerciseIndex < activeSession!.exercises.count,
              setIndex < activeSession!.exercises[exerciseIndex].sets.count else { return }
        activeSession!.exercises[exerciseIndex].sets[setIndex].weightKg = max(0, weight)
    }
    
    public func updateSetReps(exerciseIndex: Int, setIndex: Int, reps: Int) {
        guard activeSession != nil,
              exerciseIndex < activeSession!.exercises.count,
              setIndex < activeSession!.exercises[exerciseIndex].sets.count else { return }
        activeSession!.exercises[exerciseIndex].sets[setIndex].reps = max(1, reps)
    }
    
    public func addSet(to exerciseIndex: Int) {
        guard activeSession != nil, exerciseIndex < activeSession!.exercises.count else { return }
        let currentSets = activeSession!.exercises[exerciseIndex].sets
        let nextSetNum = currentSets.count + 1
        let lastWeight = currentSets.last?.weightKg ?? 15.0
        let lastReps = currentSets.last?.reps ?? 10
        
        let newSet = WorkoutSetRecord(
            setNumber: nextSetNum,
            weightKg: lastWeight,
            reps: lastReps,
            isCompleted: false,
            isWarmup: false
        )
        activeSession!.exercises[exerciseIndex].sets.append(newSet)
    }
    
    public func addWarmupSet(to exerciseIndex: Int) {
        guard activeSession != nil, exerciseIndex < activeSession!.exercises.count else { return }
        let currentSets = activeSession!.exercises[exerciseIndex].sets
        let firstWorkingWeight = currentSets.first(where: { !$0.isWarmup })?.weightKg ?? 20.0
        let warmupWeight = max(0, (firstWorkingWeight * 0.5 / 2.5).rounded() * 2.5)
        
        let warmupSet = WorkoutSetRecord(
            setNumber: 0,
            weightKg: warmupWeight,
            reps: 8,
            isCompleted: false,
            isWarmup: true
        )
        activeSession!.exercises[exerciseIndex].sets.insert(warmupSet, at: 0)
    }
    
    public func removeSet(exerciseIndex: Int, setIndex: Int) {
        guard activeSession != nil,
              exerciseIndex < activeSession!.exercises.count,
              setIndex < activeSession!.exercises[exerciseIndex].sets.count else { return }
        activeSession!.exercises[exerciseIndex].sets.remove(at: setIndex)
        // Renumber sets
        var counter = 1
        for i in 0..<activeSession!.exercises[exerciseIndex].sets.count {
            if !activeSession!.exercises[exerciseIndex].sets[i].isWarmup {
                activeSession!.exercises[exerciseIndex].sets[i].setNumber = counter
                counter += 1
            }
        }
    }
    
    // MARK: - Rest Timer
    
    public func startRestTimer(seconds: Int) {
        restDurationTotal = seconds
        restTimeRemaining = seconds
        isRestTimerRunning = true
        
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.restTimeRemaining > 1 {
                    self.restTimeRemaining -= 1
                } else {
                    self.restTimeRemaining = 0
                    self.isRestTimerRunning = false
                    self.timerCancellable?.cancel()
                    self.notifyTimerFinished()
                }
            }
    }
    
    public func pauseRestTimer() {
        isRestTimerRunning = false
        timerCancellable?.cancel()
    }
    
    public func resumeRestTimer() {
        guard restTimeRemaining > 0 else { return }
        startRestTimer(seconds: restTimeRemaining)
    }
    
    public func stopRestTimer() {
        isRestTimerRunning = false
        restTimeRemaining = 0
        timerCancellable?.cancel()
    }
    
    public func addRestTime(seconds: Int) {
        restTimeRemaining += seconds
        restDurationTotal += seconds
        if !isRestTimerRunning {
            resumeRestTimer()
        }
    }
    
    private func notifyTimerFinished() {
        lastTimerCompletedAt = Date()
        triggerHapticFeedback(.warning)
        #if canImport(AudioToolbox)
        AudioServicesPlaySystemSound(1005) // Standard SMS / Bell chime
        #endif
    }
    
    public func triggerHapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
        #endif
    }
    
    // MARK: - Data Persistence
    
    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: historyStorageKey)
        } catch {
            print("Failed to save history: \(error)")
        }
    }
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyStorageKey) else { return }
        do {
            history = try JSONDecoder().decode([WorkoutSessionLog].self, from: data)
        } catch {
            print("Failed to decode history: \(error)")
        }
    }
    
    public func clearAllHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: historyStorageKey)
    }
    
    private func seedInitialDemoLog() {
        // Helpful first-time baseline so beginners can see how history and previous performance indicators work
        let demoSession = WorkoutSessionLog(
            id: UUID(),
            scheduleId: "day-1-upper-a",
            scheduleTitle: "Upper A (Upper Body)",
            startedAt: Date().addingTimeInterval(-86400 * 3),
            endedAt: Date().addingTimeInterval(-86400 * 3 + 3400),
            durationSeconds: 3400,
            exercises: [
                ExerciseSessionLog(
                    exerciseId: "ex_flat_db_bench",
                    exerciseName: "Flat Dumbbell Bench Press",
                    sets: [
                        WorkoutSetRecord(setNumber: 1, weightKg: 14.0, reps: 12, isCompleted: true),
                        WorkoutSetRecord(setNumber: 2, weightKg: 14.0, reps: 12, isCompleted: true),
                        WorkoutSetRecord(setNumber: 3, weightKg: 14.0, reps: 12, isCompleted: true)
                    ],
                    userNotes: "Felt strong on the flat bench! Hit all 12 reps."
                ),
                ExerciseSessionLog(
                    exerciseId: "ex_bb_bent_row",
                    exerciseName: "Barbell Bent-Over Row",
                    sets: [
                        WorkoutSetRecord(setNumber: 1, weightKg: 35.0, reps: 10, isCompleted: true),
                        WorkoutSetRecord(setNumber: 2, weightKg: 35.0, reps: 10, isCompleted: true),
                        WorkoutSetRecord(setNumber: 3, weightKg: 35.0, reps: 9, isCompleted: true)
                    ],
                    userNotes: "Focused on squeezing shoulder blades at the top."
                ),
                ExerciseSessionLog(
                    exerciseId: "ex_seated_db_ohp",
                    exerciseName: "Seated Dumbbell Overhead Press",
                    sets: [
                        WorkoutSetRecord(setNumber: 1, weightKg: 10.0, reps: 12, isCompleted: true),
                        WorkoutSetRecord(setNumber: 2, weightKg: 10.0, reps: 11, isCompleted: true),
                        WorkoutSetRecord(setNumber: 3, weightKg: 10.0, reps: 10, isCompleted: true)
                    ]
                )
            ],
            isCompleted: true,
            sessionRating: 5
        )
        history = [demoSession]
        saveHistory()
    }
}
