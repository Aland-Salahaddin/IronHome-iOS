//
//  SetRowView.swift
//  IronHome
//
//  Individual row for logging weight, reps, and completion state
//

import SwiftUI

public struct SetRowView: View {
    @ObservedObject var store: WorkoutStore
    let exerciseIndex: Int
    let setIndex: Int
    let setRecord: WorkoutSetRecord
    let previousPerformance: (weightKg: Double, reps: String, date: Date)?
    let maxRepsTarget: Int
    
    public var body: some View {
        HStack(spacing: 12) {
            // Set indicator or Warmup badge
            HStack(spacing: 4) {
                if setRecord.isWarmup {
                    Text("W")
                        .font(.caption2.bold())
                        .foregroundColor(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.18))
                        .clipShape(Capsule())
                } else {
                    Text("\(setRecord.setNumber)")
                        .font(.subheadline.bold())
                        .foregroundColor(setRecord.isCompleted ? .secondary : .primary)
                        .frame(width: 22)
                }
            }
            
            // Previous performance reference
            VStack(alignment: .leading, spacing: 2) {
                if let prev = previousPerformance {
                    Text("\(String(format: "%.1f", prev.weightKg))kg × \(prev.reps)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text("—")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.6))
                }
            }
            .frame(width: 75, alignment: .leading)
            
            // Weight adjustment
            HStack(spacing: 4) {
                Button(action: {
                    let newWeight = max(0, setRecord.weightKg - 1.0)
                    store.updateSetWeight(exerciseIndex: exerciseIndex, setIndex: setIndex, weight: newWeight)
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 28)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.borderless)
                
                Text("\(String(format: "%.1f", setRecord.weightKg))")
                    .font(.system(.subheadline, design: .rounded).bold())
                    .frame(width: 44, alignment: .center)
                
                Button(action: {
                    let newWeight = setRecord.weightKg + 1.0
                    store.updateSetWeight(exerciseIndex: exerciseIndex, setIndex: setIndex, weight: newWeight)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 28)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.borderless)
            }
            
            // Reps adjustment
            HStack(spacing: 4) {
                Button(action: {
                    let newReps = max(1, setRecord.reps - 1)
                    store.updateSetReps(exerciseIndex: exerciseIndex, setIndex: setIndex, reps: newReps)
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 28)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.borderless)
                
                HStack(spacing: 2) {
                    Text("\(setRecord.reps)")
                        .font(.system(.subheadline, design: .rounded).bold())
                    
                    if setRecord.reps >= maxRepsTarget && !setRecord.isWarmup {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }
                }
                .frame(width: 36, alignment: .center)
                
                Button(action: {
                    let newReps = setRecord.reps + 1
                    store.updateSetReps(exerciseIndex: exerciseIndex, setIndex: setIndex, reps: newReps)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 28)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.borderless)
            }
            
            Spacer()
            
            // Complete checkmark button
            Button(action: {
                store.toggleSetCompleted(exerciseIndex: exerciseIndex, setIndex: setIndex)
            }) {
                Image(systemName: setRecord.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(setRecord.isCompleted ? .green : Color(UIColor.systemGray4))
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(setRecord.isCompleted ? Color.green.opacity(0.08) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
