//
//  FloatingRestTimerBar.swift
//  IronHome
//
//  Floating rest timer overlay shown during active workout sessions
//

import SwiftUI

public struct FloatingRestTimerBar: View {
    @ObservedObject var store: WorkoutStore
    @State private var showingFullTimerSheet: Bool = false
    
    public var body: some View {
        if store.restTimeRemaining > 0 || store.isRestTimerRunning {
            HStack(spacing: 14) {
                // Circular mini progress
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 3)
                        .frame(width: 38, height: 38)
                    
                    let progress = Double(store.restTimeRemaining) / Double(max(1, store.restDurationTotal))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: "timer")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("REST TIMER")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.8))
                    
                    let mins = store.restTimeRemaining / 60
                    let secs = store.restTimeRemaining % 60
                    Text(String(format: "%02d:%02d", mins, secs))
                        .font(.system(.title3, design: .monospaced).bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // +15s Quick bump
                Button(action: {
                    store.addRestTime(seconds: 15)
                }) {
                    Text("+15s")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                // Pause / Play toggle
                Button(action: {
                    if store.isRestTimerRunning {
                        store.pauseRestTimer()
                    } else {
                        store.resumeRestTimer()
                    }
                }) {
                    Image(systemName: store.isRestTimerRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                // Dismiss / Skip
                Button(action: {
                    store.stopRestTimer()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.95), Color.indigo.opacity(0.95)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: store.restTimeRemaining)
        }
    }
}
