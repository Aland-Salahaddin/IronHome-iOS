//
//  RestTimerView.swift
//  IronHome
//
//  Dedicated Rest Timer with animated countdown, 60–120s presets,
//  and scientific rest guidance for hypertrophy.
//

import SwiftUI

public struct RestTimerView: View {
    @ObservedObject var store: WorkoutStore
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    // Circular Timer Display
                    ZStack {
                        let total = max(1, store.restDurationTotal)
                        let remaining = store.restTimeRemaining
                        let progress = Double(remaining) / Double(total)
                        
                        // Background track
                        Circle()
                            .stroke(Color(UIColor.secondarySystemFill), lineWidth: 16)
                            .frame(width: 250, height: 250)
                        
                        // Progress track
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 16, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 250, height: 250)
                            .animation(.linear(duration: 0.9), value: store.restTimeRemaining)
                        
                        // Time digits
                        VStack(spacing: 4) {
                            let mins = remaining / 60
                            let secs = remaining % 60
                            Text(String(format: "%02d:%02d", mins, secs))
                                .font(.system(size: 52, weight: .bold, design: .rounded))
                            
                            Text(store.isRestTimerRunning ? "RESTING" : (remaining == 0 ? "READY" : "PAUSED"))
                                .font(.caption.bold())
                                .foregroundColor(store.isRestTimerRunning ? .blue : (remaining == 0 ? .green : .orange))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    (store.isRestTimerRunning ? Color.blue : (remaining == 0 ? Color.green : Color.orange))
                                        .opacity(0.12)
                                )
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 20)
                    
                    // Quick Interval Presets (60s, 90s, 120s)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recommended Rest Presets")
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            TimerPresetButton(
                                seconds: 60,
                                label: "60s",
                                subtitle: "Arms / Delts",
                                isSelected: store.restDurationTotal == 60,
                                action: { store.startRestTimer(seconds: 60) }
                            )
                            
                            TimerPresetButton(
                                seconds: 90,
                                label: "90s",
                                subtitle: "Standard",
                                isSelected: store.restDurationTotal == 90,
                                action: { store.startRestTimer(seconds: 90) }
                            )
                            
                            TimerPresetButton(
                                seconds: 120,
                                label: "120s",
                                subtitle: "Heavy Lifts",
                                isSelected: store.restDurationTotal == 120,
                                action: { store.startRestTimer(seconds: 120) }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Primary Playback Controls
                    HStack(spacing: 20) {
                        // Reset
                        Button(action: {
                            store.stopRestTimer()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3.bold())
                                .foregroundColor(.secondary)
                                .frame(width: 54, height: 54)
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                        
                        // Play / Pause Toggle
                        Button(action: {
                            if store.isRestTimerRunning {
                                store.pauseRestTimer()
                            } else {
                                if store.restTimeRemaining == 0 {
                                    store.startRestTimer(seconds: store.restDurationTotal)
                                } else {
                                    store.resumeRestTimer()
                                }
                            }
                        }) {
                            Image(systemName: store.isRestTimerRunning ? "pause.fill" : "play.fill")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: Color.blue.opacity(0.35), radius: 8, x: 0, y: 4)
                        }
                        
                        // +15 Seconds Bump
                        Button(action: {
                            store.addRestTime(seconds: 15)
                        }) {
                            Text("+15s")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                                .frame(width: 54, height: 54)
                                .background(Color.blue.opacity(0.12))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Scientific Hypertrophy Rest Guidance
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.purple)
                            Text("Hypertrophy Rest Science")
                                .font(.headline)
                        }
                        
                        RestGuidanceRow(
                            liftType: "Heavy Compounds (Squat, Bench, Rows):",
                            recommended: "90–120 seconds",
                            reason: "Restores phosphocreatine (ATP-PCr) and allows spinal erectors and central nervous system to generate full mechanical tension on subsequent sets."
                        )
                        
                        Divider()
                        
                        RestGuidanceRow(
                            liftType: "Isolation Movements (Curls, Extensions, Raises):",
                            recommended: "60–90 seconds",
                            reason: "Generates optimal metabolic stress and cellular swelling while muscles recover sufficiently for high rep targets."
                        )
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Rest Timer")
        }
    }
}

private struct TimerPresetButton: View {
    let seconds: Int
    let label: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .primary)
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .white.opacity(0.85) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct RestGuidanceRow: View {
    let liftType: String
    let recommended: String
    let reason: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(liftType)
                    .font(.caption.bold())
                Spacer()
                Text(recommended)
                    .font(.caption.bold())
                    .foregroundColor(.blue)
            }
            Text(reason)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
