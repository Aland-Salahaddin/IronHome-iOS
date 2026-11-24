//
//  ExerciseDetailModalView.swift
//  IronHome
//
//  Modal view showing comprehensive form breakdown, target anatomy,
//  safety cues, and flat-bench positioning.
//

import SwiftUI

public struct ExerciseDetailModalView: View {
    @Environment(\.presentationMode) var presentationMode
    let exercise: ExerciseDefinition
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    // Header card
                    VStack(alignment: .leading, spacing: 10) {
                        Text(exercise.name)
                            .font(.title2.bold())
                        
                        // Equipment badges
                        HStack(spacing: 8) {
                            ForEach(exercise.equipment, id: \.self) { eq in
                                Label(eq.rawValue, systemImage: iconForEquipment(eq))
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.12))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                            
                            Text(exercise.repRangeDisplay)
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Flat Bench Role (if applicable)
                    if let benchRole = exercise.flatBenchRole {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "bed.double.fill")
                                    .foregroundColor(.indigo)
                                Text("Flat Bench Setup & Role")
                                    .font(.headline)
                            }
                            
                            Text(benchRole)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    // Target Muscles & Hypertrophy Benefits
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(.red)
                            Text("Target Muscles & Benefits")
                                .font(.headline)
                        }
                        
                        Text(exercise.targetMuscles)
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                        
                        Text(exercise.benefits)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Step-by-Step Form & Technique
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("Beginner Form Checklist")
                                .font(.headline)
                        }
                        
                        ForEach(Array(exercise.formNotes.enumerated()), id: \.offset) { index, note in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1)")
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                
                                Text(note)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Safety & Injury Prevention Notes
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Home Gym Safety Precautions")
                                .font(.headline)
                        }
                        
                        ForEach(exercise.safetyNotes, id: \.self) { safety in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "shield.lefthalf.filled")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                    .padding(.top, 2)
                                
                                Text(safety)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding()
            }
            .navigationTitle("Exercise Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func iconForEquipment(_ eq: EquipmentType) -> String {
        switch eq {
        case .dumbbell: return "dumbbell.fill"
        case .barbell: return "scalemass.fill"
        case .flatBench: return "bed.double.fill"
        case .bodyweight: return "figure.walk"
        }
    }
}
