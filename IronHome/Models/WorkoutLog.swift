//
//  WorkoutLog.swift
//  IronHome
//
//  Logging structures for sets, exercises, and completed workout sessions
//

import Foundation

public struct WorkoutSetRecord: Identifiable, Codable, Equatable {
    public var id: UUID
    public var setNumber: Int
    public var weightKg: Double
    public var reps: Int
    public var isCompleted: Bool
    public var isWarmup: Bool
    public var completedAt: Date?
    
    public init(
        id: UUID = UUID(),
        setNumber: Int,
        weightKg: Double = 0.0,
        reps: Int = 10,
        isCompleted: Bool = false,
        isWarmup: Bool = false,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.setNumber = setNumber
        self.weightKg = weightKg
        self.reps = reps
        self.isCompleted = isCompleted
        self.isWarmup = isWarmup
        self.completedAt = completedAt
    }
}

public struct ExerciseSessionLog: Identifiable, Codable, Equatable {
    public var id: UUID
    public var exerciseId: String
    public var exerciseName: String
    public var sets: [WorkoutSetRecord]
    public var userNotes: String
    
    public init(
        id: UUID = UUID(),
        exerciseId: String,
        exerciseName: String,
        sets: [WorkoutSetRecord] = [],
        userNotes: String = ""
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.sets = sets
        self.userNotes = userNotes
    }
    
    public var completedWorkingSets: [WorkoutSetRecord] {
        return sets.filter { $0.isCompleted && !$0.isWarmup }
    }
    
    public var maxWeightKg: Double {
        return completedWorkingSets.map { $0.weightKg }.max() ?? 0.0
    }
    
    public var totalReps: Int {
        return completedWorkingSets.reduce(0) { $0 + $1.reps }
    }
    
    public var totalVolumeKg: Double {
        return completedWorkingSets.reduce(0.0) { $0 + ($1.weightKg * Double($1.reps)) }
    }
}

public struct WorkoutSessionLog: Identifiable, Codable, Equatable {
    public var id: UUID
    public var scheduleId: String
    public var scheduleTitle: String
    public var startedAt: Date
    public var endedAt: Date?
    public var durationSeconds: Int
    public var exercises: [ExerciseSessionLog]
    public var isCompleted: Bool
    public var sessionRating: Int // 1 to 5 stars
    
    public init(
        id: UUID = UUID(),
        scheduleId: String,
        scheduleTitle: String,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        durationSeconds: Int = 0,
        exercises: [ExerciseSessionLog] = [],
        isCompleted: Bool = false,
        sessionRating: Int = 5
    ) {
        self.id = id
        self.scheduleId = scheduleId
        self.scheduleTitle = scheduleTitle
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.durationSeconds = durationSeconds
        self.exercises = exercises
        self.isCompleted = isCompleted
        self.sessionRating = sessionRating
    }
    
    public var totalWorkingSets: Int {
        return exercises.reduce(0) { $0 + $1.completedWorkingSets.count }
    }
    
    public var totalVolumeKg: Double {
        return exercises.reduce(0.0) { $0 + $1.totalVolumeKg }
    }
}
