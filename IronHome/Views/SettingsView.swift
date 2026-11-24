//
//  SettingsView.swift
//  IronHome
//
//  App configuration, rest timer defaults, and Sideloadly installation guide
//

import SwiftUI

public struct SettingsView: View {
    @ObservedObject var store: WorkoutStore
    @State private var showingResetAlert: Bool = false
    
    public var body: some View {
        NavigationView {
            Form {
                // Section: Rest Timer Engine
                Section(header: Text("Rest Timer Preferences")) {
                    Toggle("Auto-Start Timer on Set Done", isOn: $store.autoStartRestTimer)
                    
                    Picker("Default Rest Duration", selection: $store.defaultRestSeconds) {
                        Text("60 seconds (Quick / Isolation)").tag(60)
                        Text("90 seconds (Standard Hypertrophy)").tag(90)
                        Text("120 seconds (Heavy Compounds)").tag(120)
                    }
                    
                    Toggle("Show Warm-up Reminders", isOn: $store.showWarmupAlerts)
                }
                
                // Section: Equipment & Units
                Section(header: Text("Equipment & Units")) {
                    HStack {
                        Text("Weight Unit")
                        Spacer()
                        Text("Kilograms (kg)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Available Equipment")
                        Spacer()
                        Text("Dumbbells, Barbell, Flat Bench")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Section: Sideloadly & iOS Certificate Info
                Section(header: Text("Sideloadly & Apple ID Lifespan")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("7-Day Free Developer Certificate", systemImage: "clock.badge.exclamationmark")
                            .font(.subheadline.bold())
                            .foregroundColor(.orange)
                        
                        Text("When sideloading `.ipa` files using a free Apple ID in Sideloadly, iOS provisioning profiles expire after 7 days. Your logged workout data is safely preserved on device when re-signing with Sideloadly!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                    }
                    .padding(.vertical, 4)
                }
                
                // Section: Data Management
                Section(header: Text("Data Management")) {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Text("Clear Workout History")
                    }
                }
                
                // Section: App About
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Build 1)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Routine")
                        Spacer()
                        Text("4-Day Upper/Lower + Day 5 Accessory")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Clear All History?"),
                    message: Text("This will remove all logged workouts from this device."),
                    primaryButton: .destructive(Text("Clear All")) {
                        store.clearAllHistory()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
