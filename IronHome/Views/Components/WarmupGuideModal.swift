//
//  WarmupGuideModal.swift
//  IronHome
//
//  Warm-up protocol reminder and calculator for beginner home lifters
//

import SwiftUI

public struct WarmupGuideModal: View {
    @Environment(\.presentationMode) var presentationMode
    let exerciseName: String
    let workingWeightKg: Double
    let onAddWarmupSet: () -> Void
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "flame.circle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Warm-Up Protocol")
                                .font(.title3.bold())
                        }
                        
                        Text("Perform 1–2 ramp-up sets before heavy working sets to lubricate synovial joints, prime neuromuscular pathways, and prevent home training injuries.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Suggested Sets Breakdown
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Recommended Ramp-Up for \(exerciseName)")
                            .font(.headline)
                        
                        let warmupSets = ProgressionEngine.generateWarmupSets(workingWeightKg: workingWeightKg)
                        
                        ForEach(Array(warmupSets.enumerated()), id: \.offset) { index, set in
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.18))
                                        .frame(width: 36, height: 36)
                                    Text("W\(index + 1)")
                                        .font(.caption.bold())
                                        .foregroundColor(.orange)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(set.setDesc)
                                        .font(.subheadline.bold())
                                    Text("\(String(format: "%.1f", set.weightKg)) kg × \(set.reps) smooth reps")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("Rest 60s")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(UIColor.tertiarySystemFill))
                                    .clipShape(Capsule())
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    // Golden Rules for Home Gym Safety
                    VStack(alignment: .leading, spacing: 10) {
                        Text("3 Golden Warm-up Rules")
                            .font(.headline)
                        
                        WarmupRuleRow(icon: "1.circle.fill", text: "Never train to failure during warm-up sets; move with crisp speed.")
                        WarmupRuleRow(icon: "2.circle.fill", text: "Take 60 seconds rest after warmups before your first working set.")
                        WarmupRuleRow(icon: "3.circle.fill", text: "Warmup sets do NOT count toward your hypertrophy volume calculation.")
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Add warmup set action
                    Button(action: {
                        onAddWarmupSet()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Insert Warm-up Set to Tracker")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Warm-up Guide")
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

private struct WarmupRuleRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.body)
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
