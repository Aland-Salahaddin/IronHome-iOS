//
//  MainTabView.swift
//  IronHome
//
//  Root navigation coordinator and tab bar container
//

import SwiftUI

public struct MainTabView: View {
    @StateObject private var store = WorkoutStore()
    @State private var selectedTab: Int = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView(store: store)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(0)
            
            RestTimerView(store: store)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(1)
            
            ExerciseLibraryView(store: store)
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell.fill")
                }
                .tag(2)
            
            HistoryProgressView(store: store)
                .tabItem {
                    Label("History", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            SettingsView(store: store)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}
