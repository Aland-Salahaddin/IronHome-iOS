//
//  ProgressionEngine.swift
//  IronHome
//
//  Intelligent Double-Progression Engine for Home Lifters
//  Detects top-of-rep-range milestones and suggests safe progressive overload increments
//

import Foundation

public enum ProgressionStatus: Equatable {
    case readyToIncrease(suggestedIncrementKg: Double, message: String)
    case inTargetZone(message: String)
    case buildFoundation(message: String)
    case notEnoughData
}

public struct ProgressionEngine {
    
    /// Evaluates completed sets against the exercise's target rep range
    public static func evaluateProgression(
        for exercise: ExerciseDefinition,
        completedSets: [WorkoutSetRecord]
    ) -> ProgressionStatus {
        let workingSets = completedSets.filter { $0.isCompleted && !$0.isWarmup }
        guard !workingSets.isEmpty else { return .notEnoughData }
        
        // If it's a plank/timed hold
        if exercise.targetDurationSeconds != nil {
            let allHitTarget = workingSets.allSatisfy { $0.reps >= exercise.maxReps }
            if allHitTarget {
                return .readyToIncrease(
                    suggestedIncrementKg: 0,
                    message: "Target endurance reached! Try adding +5–10 seconds or elevating feet on the flat bench next time."
                )
            } else {
                return .inTargetZone(message: "Maintain solid hollow-body form until you comfortably hold 45 seconds.")
            }
        }
        
        let targetMax = exercise.maxReps
        let targetMin = exercise.minReps
        
        // Check if all completed working sets reached or exceeded the maximum rep target
        let allSetsHitMax = workingSets.count >= exercise.defaultSets && workingSets.allSatisfy { $0.reps >= targetMax }
        
        if allSetsHitMax {
            let isBarbell = exercise.equipment.contains(.barbell)
            let increment = isBarbell ? 2.5 : 2.0
            let incrementDesc = isBarbell ? "+2.5 kg (+1.25 kg each collar)" : "+1 to +2 kg per dumbbell"
            
            return .readyToIncrease(
                suggestedIncrementKg: increment,
                message: "🎉 Hit \(targetMax) reps on all sets! Ready to progress: increase by \(incrementDesc) next session."
            )
        }
        
        // Check if user is struggling below minimum
        let belowMinCount = workingSets.filter { $0.reps < targetMin }.count
        if belowMinCount > 0 {
            return .buildFoundation(
                message: "Weight may be slightly heavy. Keep this weight and aim for \(targetMin)+ clean reps with strict tempo before adding weight."
            )
        }
        
        // User is progressing well within the rep range (e.g. 9–11 reps)
        let averageReps = Double(workingSets.reduce(0) { $0 + $1.reps }) / Double(workingSets.count)
        return .inTargetZone(
            message: "Solid progression! Averaging \(String(format: "%.1f", averageReps)) reps. Push for +1 rep per set toward \(targetMax) reps before bumping weight."
        )
    }
    
    /// Retrieves the most recent performance (weight & reps) for an exercise from session history
    public static func getPreviousPerformance(
        exerciseId: String,
        from history: [WorkoutSessionLog]
    ) -> (weightKg: Double, reps: String, date: Date)? {
        for session in history.sorted(by: { $0.startedAt > $1.startedAt }) {
            if let matchedEx = session.exercises.first(where: { $0.exerciseId == exerciseId }) {
                let validSets = matchedEx.completedWorkingSets
                if let topSet = validSets.max(by: { $0.weightKg < $1.weightKg }) {
                    let repSummary = validSets.map { "\($0.reps)" }.joined(separator: ", ")
                    return (topSet.weightKg, repSummary, session.startedAt)
                }
            }
        }
        return nil
    }
    
    /// Calculates estimated 1RM using Epley formula: weight * (1 + reps / 30)
    public static func calculateEstimated1RM(weightKg: Double, reps: Int) -> Double {
        guard reps > 0 && weightKg > 0 else { return 0 }
        if reps == 1 { return weightKg }
        return weightKg * (1.0 + Double(reps) / 30.0)
    }
    
    /// Generates recommended warm-up sets based on intended working weight
    public static func generateWarmupSets(workingWeightKg: Double) -> [(setDesc: String, weightKg: Double, reps: Int)] {
        guard workingWeightKg >= 15.0 else {
            return [
                ("Warm-up Set 1", 0.0, 10),
                ("Warm-up Set 2", workingWeightKg * 0.5, 6)
            ]
        }
        let set1Weight = max(0, (workingWeightKg * 0.5 / 2.5).rounded() * 2.5)
        let set2Weight = max(0, (workingWeightKg * 0.75 / 2.5).rounded() * 2.5)
        
        return [
            ("Warm-up Set 1 (50%)", set1Weight, 8),
            ("Warm-up Set 2 (75%)", set2Weight, 4)
        ]
    }
}
