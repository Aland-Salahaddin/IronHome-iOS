//
//  ExerciseLibraryView.swift
//  IronHome
//
//  Searchable encyclopedia of all dumbbell, barbell, and flat bench movements
//

import SwiftUI

public struct ExerciseLibraryView: View {
    @ObservedObject var store: WorkoutStore
    @State private var searchText: String = ""
    @State private var selectedEquipmentFilter: EquipmentType? = nil
    @State private var selectedExerciseForDetail: ExerciseDefinition? = nil
    
    private var allExercises: [ExerciseDefinition] {
        var list: [ExerciseDefinition] = []
        for s in store.schedules {
            for ex in s.exercises {
                if !list.contains(where: { $0.id == ex.id }) {
                    list.append(ex)
                }
            }
        }
        return list
    }
    
    private var filteredExercises: [ExerciseDefinition] {
        return allExercises.filter { ex in
            let matchesSearch = searchText.isEmpty ||
                ex.name.localizedCaseInsensitiveContains(searchText) ||
                ex.targetMuscles.localizedCaseInsensitiveContains(searchText)
            
            let matchesEquipment = selectedEquipmentFilter == nil ||
                ex.equipment.contains(selectedEquipmentFilter!)
            
            return matchesSearch && matchesEquipment
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Equipment Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterPill(title: "All Equipment", isSelected: selectedEquipmentFilter == nil) {
                            selectedEquipmentFilter = nil
                        }
                        
                        FilterPill(title: "Flat Bench", isSelected: selectedEquipmentFilter == .flatBench) {
                            selectedEquipmentFilter = .flatBench
                        }
                        
                        FilterPill(title: "Dumbbells", isSelected: selectedEquipmentFilter == .dumbbell) {
                            selectedEquipmentFilter = .dumbbell
                        }
                        
                        FilterPill(title: "Barbell", isSelected: selectedEquipmentFilter == .barbell) {
                            selectedEquipmentFilter = .barbell
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Exercise List
                List {
                    ForEach(filteredExercises) { ex in
                        Button(action: {
                            selectedExerciseForDetail = ex
                        }) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(ex.name)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(ex.repRangeDisplay)
                                        .font(.caption2.bold())
                                        .foregroundColor(.blue)
                                }
                                
                                Text(ex.targetMuscles)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                HStack(spacing: 6) {
                                    ForEach(ex.equipment, id: \.self) { eq in
                                        Text(eq.rawValue)
                                            .font(.system(size: 9, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(UIColor.secondarySystemFill))
                                            .foregroundColor(.secondary)
                                            .clipShape(Capsule())
                                    }
                                    
                                    if ex.warmupRecommended {
                                        Text("Warm-up Rec.")
                                            .font(.system(size: 9, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.orange.opacity(0.18))
                                            .foregroundColor(.orange)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Exercise Guide")
            .searchable(text: $searchText, prompt: "Search exercises or muscle groups")
            .sheet(item: $selectedExerciseForDetail) { ex in
                ExerciseDetailModalView(exercise: ex)
            }
        }
    }
}

private struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
