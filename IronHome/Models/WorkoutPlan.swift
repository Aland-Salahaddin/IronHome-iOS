//
//  WorkoutPlan.swift
//  IronHome
//
//  Complete 4-Day Upper/Lower Split + Optional Day 5 Accessory Routine
//  Tailored for Home Training with Dumbbells, Barbell, and Flat Bench
//

import Foundation

public enum EquipmentType: String, Codable, CaseIterable {
    case dumbbell = "Dumbbell"
    case barbell = "Barbell"
    case flatBench = "Flat Bench"
    case bodyweight = "Bodyweight"
}

public struct ExerciseDefinition: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let equipment: [EquipmentType]
    public let defaultSets: Int
    public let minReps: Int
    public let maxReps: Int
    public let targetDurationSeconds: Int? // For timed exercises like Plank
    public let targetMuscles: String
    public let benefits: String
    public let formNotes: [String]
    public let safetyNotes: [String]
    public let flatBenchRole: String?
    public let warmupRecommended: Bool
    
    public var repRangeDisplay: String {
        if let duration = targetDurationSeconds {
            return "\(duration)s hold"
        }
        return "\(minReps)–\(maxReps) reps"
    }
    
    public var setsDisplay: String {
        return "\(defaultSets) sets × \(repRangeDisplay)"
    }
}

public struct WorkoutDaySchedule: Identifiable, Codable, Equatable {
    public let id: String
    public let dayNumber: Int
    public let dayName: String
    public let title: String
    public let subtitle: String
    public let isRestDay: Bool
    public let estimatedMinutes: Int
    public let exercises: [ExerciseDefinition]
    public let recoveryGuidance: String?
}

public struct WorkoutRoutine {
    public static let standardSchedule: [WorkoutDaySchedule] = [
        // MARK: - DAY 1: Upper A
        WorkoutDaySchedule(
            id: "day-1-upper-a",
            dayNumber: 1,
            dayName: "Day 1",
            title: "Upper A (Upper Body)",
            subtitle: "Chest, Back, Shoulders & Arms",
            isRestDay: false,
            estimatedMinutes: 60,
            exercises: [
                ExerciseDefinition(
                    id: "ex_flat_db_bench",
                    name: "Flat Dumbbell Bench Press",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 8,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Chest (Pectoralis Major), Anterior Deltoids, Triceps",
                    benefits: "Promotes bilateral chest hypertrophy, natural joint path for shoulders, and balanced arm strength with solid back support on the flat bench.",
                    formNotes: [
                        "Lie back with feet flat on the floor, pinning your shoulder blades down and back into the bench.",
                        "Hold dumbbells at chest level with wrists stacked directly over elbows.",
                        "Press up in a slight arc until arms are extended without forcefully locking out your elbows.",
                        "Lower under control over 2–3 seconds until you feel a comfortable stretch in your pecs."
                    ],
                    safetyNotes: [
                        "Never let dumbbells drift too far backward over your head.",
                        "Keep your lower back naturally arched, but don't hyperextend.",
                        "Rest the dumbbells on your knees when sitting up."
                    ],
                    flatBenchRole: "Provides stable torso support, enabling full pectoral recruitment while keeping the spine neutralized.",
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_bb_bent_row",
                    name: "Barbell Bent-Over Row",
                    equipment: [.barbell],
                    defaultSets: 3,
                    minReps: 8,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Upper & Mid Back (Lats, Rhomboids, Traps), Rear Deltoids, Biceps",
                    benefits: "Develops back width and thickness, strengthens scapular retractors, and builds posterior spinal endurance.",
                    formNotes: [
                        "Hinge at hips with a soft bend in knees until your torso is roughly 45° to the floor.",
                        "Keep spine neutral and neck aligned with your back.",
                        "Pull the bar toward your lower ribcage/navel, driving your elbows behind you.",
                        "Squeeze shoulder blades together at the top, then lower with control."
                    ],
                    safetyNotes: [
                        "Brace your core tightly to protect your lower back.",
                        "Do not jerk or bounce the torso to move the barbell."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_seated_db_ohp",
                    name: "Seated Dumbbell Overhead Press",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Shoulders (Anterior & Lateral Deltoids), Triceps, Upper Core",
                    benefits: "Builds overhead pressing strength, shoulder cap volume, and core stability in a seated flat-bench position.",
                    formNotes: [
                        "Sit upright on the flat bench with feet pressed firmly into the floor for a sturdy tripod base.",
                        "Bring dumbbells to shoulder height, palms facing forward or slightly angled (semi-neutral).",
                        "Press the weights overhead smoothly, keeping your ribs tucked down.",
                        "Lower back to ear level under deliberate control."
                    ],
                    safetyNotes: [
                        "Avoid leaning back excessively; keep your glutes and core braced.",
                        "Press in line with your mid-foot, not flared out too wide."
                    ],
                    flatBenchRole: "Provides a stable seat; demands upright core engagement since there is no back support.",
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_db_bicep_curl",
                    name: "Dumbbell Bicep Curl",
                    equipment: [.dumbbell],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 15,
                    targetDurationSeconds: nil,
                    targetMuscles: "Biceps Brachii, Brachialis, Forearm Flexors",
                    benefits: "Direct biceps hypertrophy, enhanced elbow flexion strength, and grip endurance.",
                    formNotes: [
                        "Stand tall or sit on the bench with arms hanging at sides, palms facing inward or forward.",
                        "Curl the dumbbells upward, supinating your wrists so palms face your shoulders at peak contraction.",
                        "Keep elbows pinned to your sides—do not swing them forward.",
                        "Lower slowly for 2–3 seconds on the eccentric phase."
                    ],
                    safetyNotes: [
                        "Avoid swinging your hips or arching your lower back to hoist the weight."
                    ],
                    flatBenchRole: "Can be performed seated or standing.",
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_db_tricep_overhead_ext",
                    name: "Dumbbell Tricep Overhead Extension",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 15,
                    targetDurationSeconds: nil,
                    targetMuscles: "Triceps (Long Head emphasis), Anconeus",
                    benefits: "Stretches and strengthens the long head of the triceps overhead, maximizing full arm development.",
                    formNotes: [
                        "Sit on the flat bench holding a single dumbbell with both hands cupping the top inner plate.",
                        "Raise the dumbbell overhead with arms vertical.",
                        "Keeping upper arms stationary and elbows pointed forward, lower the weight behind your head until forearms pass parallel.",
                        "Contract your triceps to press the weight back overhead."
                    ],
                    safetyNotes: [
                        "Keep elbows tucked rather than flaring excessively wide.",
                        "Maintain an upright posture without excessive lumbar arching."
                    ],
                    flatBenchRole: "Allows seated stabilization without back pad obstruction.",
                    warmupRecommended: false
                )
            ],
            recoveryGuidance: nil
        ),

        // MARK: - DAY 2: Lower A
        WorkoutDaySchedule(
            id: "day-2-lower-a",
            dayNumber: 2,
            dayName: "Day 2",
            title: "Lower A (Lower Body)",
            subtitle: "Quads, Glutes, Hamstrings & Core",
            isRestDay: false,
            estimatedMinutes: 60,
            exercises: [
                ExerciseDefinition(
                    id: "ex_bb_back_squat",
                    name: "Barbell Back Squat",
                    equipment: [.barbell],
                    defaultSets: 3,
                    minReps: 8,
                    maxReps: 10,
                    targetDurationSeconds: nil,
                    targetMuscles: "Quadriceps, Gluteus Maximus, Hamstrings, Adductors, Core",
                    benefits: "The foundational lower-body compound movement for whole-body mass, leg density, and systemic strength.",
                    formNotes: [
                        "Rest the barbell comfortably across your upper traps (high bar) with feet shoulder-width apart, toes flared slightly out.",
                        "Take a deep diaphragmatic breath, brace your core, and sit your hips back and down.",
                        "Descend until thighs reach parallel with the floor while keeping chest proud and knees tracking in line with toes.",
                        "Drive through mid-foot to stand back up, exhaling at the top."
                    ],
                    safetyNotes: [
                        "Never let knees cave inward (valgus collapse).",
                        "Maintain a neutral spine; do not round your lower back at bottom (butt wink)."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_bb_rdl",
                    name: "Barbell Romanian Deadlift",
                    equipment: [.barbell],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Hamstrings, Glutes, Erector Spinae, Latissimus Dorsi",
                    benefits: "Builds powerful posterior chain resilience, hamstring length-strength, and hip hinge mechanics.",
                    formNotes: [
                        "Hold barbell at hips with an overhand grip, feet hip-width apart.",
                        "Keeping knees slightly unlocked but fixed, push hips back as if touching a wall behind you.",
                        "Slide the barbell close down your thighs and shins until you feel a deep hamstring stretch (just below knees).",
                        "Squeeze glutes and thrust hips forward to return to standing."
                    ],
                    safetyNotes: [
                        "This is a hip hinge, NOT a squat—do not drop your hips down low.",
                        "Keep the bar in contact with your legs throughout the movement to protect lower back."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_db_bulgarian_split_squat",
                    name: "Dumbbell Bulgarian Split Squat",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 8,
                    maxReps: 10,
                    targetDurationSeconds: nil,
                    targetMuscles: "Quadriceps, Glutes, Adductors, Stabilizing Core (Per Leg)",
                    benefits: "Eliminates leg strength asymmetries, develops hip stability, and drives intense quad/glute growth using the flat bench.",
                    formNotes: [
                        "Stand ~2 feet in front of the flat bench, holding dumbbells at your sides.",
                        "Place top of rear foot comfortably on the bench surface.",
                        "Lower your hips straight down until front thigh is parallel to the ground.",
                        "Drive through the front heel to return to top position. Complete all reps on one side before switching."
                    ],
                    safetyNotes: [
                        "Keep front knee tracking over the second toe; don't let it drift inward.",
                        "Torso can have a slight forward lean to bias glutes and reduce spinal stress."
                    ],
                    flatBenchRole: "Elevates rear foot at the ideal 16–18 inch height for full single-leg range of motion.",
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_plank",
                    name: "Plank",
                    equipment: [.bodyweight],
                    defaultSets: 3,
                    minReps: 30,
                    maxReps: 45,
                    targetDurationSeconds: 45,
                    targetMuscles: "Rectus Abdominis, Transverse Abdominis, Obliques, Shoulders",
                    benefits: "Enhances anti-extension core endurance, pelvic stability, and bracing capability for heavy compound lifts.",
                    formNotes: [
                        "Rest on forearms with elbows directly under shoulders.",
                        "Extend legs back with toes tucked, body forming a straight line from head to heels.",
                        "Squeeze glutes, draw navel toward spine, and push the floor away through your forearms.",
                        "Breathe smoothly while maintaining isometric tension for 30–45 seconds."
                    ],
                    safetyNotes: [
                        "Do not allow hips to sag or pike up into the air."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: false
                )
            ],
            recoveryGuidance: nil
        ),

        // MARK: - DAY 3: Rest / Light Recovery
        WorkoutDaySchedule(
            id: "day-3-rest",
            dayNumber: 3,
            dayName: "Day 3",
            title: "Rest / Light Recovery",
            subtitle: "Active Regeneration & Tissue Repair",
            isRestDay: true,
            estimatedMinutes: 20,
            exercises: [],
            recoveryGuidance: """
            Today is a dedicated recovery day to allow central nervous system recovery and muscle protein synthesis.

            Recommended Activities:
            • 20–30 minute brisk walk outdoors or light mobility flow.
            • 10 minutes of gentle hamstring, hip flexor, and chest doorway stretches.
            • Stay hydrated (2.5–3.5 liters of water) and aim for 1.6–2.0g protein per kg of bodyweight.
            • Prioritize 7–9 hours of deep sleep tonight.
            """
        ),

        // MARK: - DAY 4: Upper B
        WorkoutDaySchedule(
            id: "day-4-upper-b",
            dayNumber: 4,
            dayName: "Day 4",
            title: "Upper B (Upper Body)",
            subtitle: "Chest, Back, Delts & Arms",
            isRestDay: false,
            estimatedMinutes: 60,
            exercises: [
                ExerciseDefinition(
                    id: "ex_flat_bb_bench",
                    name: "Flat Barbell Bench Press",
                    equipment: [.barbell, .flatBench],
                    defaultSets: 3,
                    minReps: 8,
                    maxReps: 10,
                    targetDurationSeconds: nil,
                    targetMuscles: "Pectoralis Major, Anterior Deltoids, Triceps Brachii",
                    benefits: "Peak pressing overload for maximum upper-body mass and pressing strength on the flat bench.",
                    formNotes: [
                        "Lie on the flat bench with eyes directly under the racked bar. Plant feet firmly on the floor.",
                        "Grip the bar just wider than shoulder-width; retract and depress scapulae.",
                        "Unrack and stabilize the bar over your mid-chest.",
                        "Lower smoothly to lower-mid sternum, keeping elbows tucked at ~45–60° from torso.",
                        "Drive the bar back up in a subtle J-curve to the start position."
                    ],
                    safetyNotes: [
                        "Always use safety catches or a thumb-around grip (never a suicide grip).",
                        "Keep your buttocks glued to the bench throughout every rep."
                    ],
                    flatBenchRole: "Rigid horizontal foundation to generate leg drive and scapular stability.",
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_single_arm_db_row",
                    name: "Single-Arm Dumbbell Row",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Latissimus Dorsi, Rhomboids, Teres Major, Biceps",
                    benefits: "Unilateral pulling allows deep stretch and full contraction on each side while protecting lower back.",
                    formNotes: [
                        "Place one knee and one hand firmly on the flat bench, creating a sturdy flat-table torso.",
                        "Hold dumbbell in the free hand with arm hanging fully extended.",
                        "Pull the dumbbell toward your hip pocket, leading with the elbow.",
                        "Pause briefly at peak contraction, then lower slowly to a full stretch."
                    ],
                    safetyNotes: [
                        "Do not twist or rotate your spine to heave the weight.",
                        "Keep your supporting arm active and neck neutral."
                    ],
                    flatBenchRole: "Three-point stability base (knee + hand on bench) for isolated unilateral lat rowing.",
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_db_lateral_raise",
                    name: "Dumbbell Lateral Raise",
                    equipment: [.dumbbell],
                    defaultSets: 3,
                    minReps: 12,
                    maxReps: 15,
                    targetDurationSeconds: nil,
                    targetMuscles: "Lateral Deltoids (Side Delts), Supraspinatus",
                    benefits: "Isolates side shoulders to create wider upper-body silhouette and complete 3D shoulder development.",
                    formNotes: [
                        "Stand with feet shoulder-width apart, holding dumbbells at your sides with a slight forward lean at hips.",
                        "Lead with your elbows, raising arms out to the sides until parallel with the floor.",
                        "Keep pinkies slightly higher than thumbs or hands level (pour water analogy).",
                        "Lower weights with strict 2-second negative; don't drop them."
                    ],
                    safetyNotes: [
                        "Do not shrug your traps up toward your ears.",
                        "Use light, strict weights—momentum negates side-delt isolation."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_db_hammer_curl",
                    name: "Dumbbell Hammer Curl",
                    equipment: [.dumbbell],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Brachialis, Brachioradialis (Forearm), Biceps Brachii",
                    benefits: "Pushes the biceps outward for arm thickness, strengthens elbow flexor tendons, and bolsters grip.",
                    formNotes: [
                        "Hold dumbbells with neutral grip (palms facing each other) throughout the entire movement.",
                        "Curl dumbbells up toward shoulders while keeping elbows pinned at sides.",
                        "Squeeze forearm and upper arm at top, then lower under control."
                    ],
                    safetyNotes: [
                        "Avoid swinging torso backward during the lift."
                    ],
                    flatBenchRole: "Can be done seated on the flat bench or standing.",
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_db_skull_crusher",
                    name: "Dumbbell Skull Crusher",
                    equipment: [.dumbbell, .flatBench],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Triceps Brachii (Medial and Lateral heads)",
                    benefits: "Direct triceps isolation with deep eccentric stretch while lying supine on the flat bench.",
                    formNotes: [
                        "Lie flat on the bench, holding dumbbells directly over shoulders with palms facing each other.",
                        "Keeping upper arms fixed and slightly tilted backward (toward crown of head), bend elbows to lower dumbbells beside ears/forehead.",
                        "Extend arms back to start by squeezing your triceps."
                    ],
                    safetyNotes: [
                        "Keep upper arms steady—do not let elbows flare wide.",
                        "Control the descent carefully so dumbbells stay safe distance from face."
                    ],
                    flatBenchRole: "Provides stable horizontal support for pure elbow-hinge triceps isolation.",
                    warmupRecommended: false
                )
            ],
            recoveryGuidance: nil
        ),

        // MARK: - DAY 5: Lower B & Optional Weekly Accessory
        WorkoutDaySchedule(
            id: "day-5-lower-b",
            dayNumber: 5,
            dayName: "Day 5",
            title: "Lower B & Optional Accessory",
            subtitle: "Quads, Glutes & Optional Finisher",
            isRestDay: false,
            estimatedMinutes: 60,
            exercises: [
                ExerciseDefinition(
                    id: "ex_db_goblet_squat",
                    name: "Dumbbell Goblet Squat",
                    equipment: [.dumbbell],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Quadriceps, Glutes, Core, Anterior Torso Stabilizers",
                    benefits: "Front-loaded weight acts as a counter-balance, reinforcing upright posture and deep quad engagement.",
                    formNotes: [
                        "Hold a single heavy dumbbell vertically against your sternum with both hands cupping the upper bell.",
                        "Set feet slightly wider than shoulders, toes angled out.",
                        "Squat deeply between your legs, elbows tracking inside your knees at the bottom.",
                        "Drive up through whole foot, keeping chest tall and core braced."
                    ],
                    safetyNotes: [
                        "Do not allow the dumbbell to pull your chest forward or round your spine."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_bb_hip_thrust",
                    name: "Barbell Hip Thrust",
                    equipment: [.barbell, .flatBench],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 12,
                    targetDurationSeconds: nil,
                    targetMuscles: "Gluteus Maximus, Hamstrings, Adductors",
                    benefits: "Unmatched horizontal glute overload with minimal lumbar compression, utilizing the flat bench pivot.",
                    formNotes: [
                        "Sit on the floor with your upper back (scapulae line) resting against the long edge of the flat bench.",
                        "Roll a padded barbell over your hips; plant feet flat about shoulder-width apart.",
                        "Drive through your heels to extend your hips upward until thighs and torso form a straight tabletop.",
                        "Squeeze glutes hard at the top with chin tucked, then lower with control."
                    ],
                    safetyNotes: [
                        "Tuck your chin toward your chest throughout—do not throw your head back.",
                        "Do not hyperextend your lower back at top; stop when glutes are fully contracted."
                    ],
                    flatBenchRole: "Acts as the sturdy fulcrum/pivot point for upper-back support during hip elevation.",
                    warmupRecommended: true
                ),
                ExerciseDefinition(
                    id: "ex_db_reverse_lunge",
                    name: "Dumbbell Reverse Lunge",
                    equipment: [.dumbbell],
                    defaultSets: 3,
                    minReps: 10,
                    maxReps: 10,
                    targetDurationSeconds: nil,
                    targetMuscles: "Quadriceps, Glutes, Hamstrings, Balance Stabilizers",
                    benefits: "Kinder to the knees than forward lunges while delivering powerful single-leg quad and glute loading.",
                    formNotes: [
                        "Stand tall holding dumbbells at sides.",
                        "Step one foot backward and lower back knee toward the ground until front knee is bent at 90°.",
                        "Keep front shin relatively vertical and front heel planted firmly.",
                        "Push through the front heel to return to the starting position."
                    ],
                    safetyNotes: [
                        "Lower back knee gently—do not slam it into the hard floor.",
                        "Maintain torso stability without side-to-side tilting."
                    ],
                    flatBenchRole: nil,
                    warmupRecommended: false
                ),
                ExerciseDefinition(
                    id: "ex_optional_accessory_block",
                    name: "Optional Accessory Block",
                    equipment: [.dumbbell, .flatBench, .bodyweight],
                    defaultSets: 2,
                    minReps: 12,
                    maxReps: 15,
                    targetDurationSeconds: nil,
                    targetMuscles: "Arms, Core, or Light Cardio Finisher (User Choice)",
                    benefits: "Flexible 15–20 min finisher for lagging muscle groups or extra core/conditioning if energy permits, preserving 2 full recovery days.",
                    formNotes: [
                        "Pick 1–2 movements based on how fresh you feel: extra Hanging/Lying Leg Raises on the bench, Farmer's Walks with dumbbells, or light interval walking.",
                        "Perform 2–3 sets of 12–15 reps with moderate intensity.",
                        "Keep total session time under 60–65 minutes to prevent overtraining."
                    ],
                    safetyNotes: [
                        "If you feel fatigued or joint sore, SKIP this block and prioritize recovery!"
                    ],
                    flatBenchRole: "Can be used for bench leg raises or seated curls.",
                    warmupRecommended: false
                )
            ],
            recoveryGuidance: nil
        ),

        // MARK: - DAY 6: Rest & Recovery
        WorkoutDaySchedule(
            id: "day-6-rest",
            dayNumber: 6,
            dayName: "Day 6",
            title: "Weekend Rest & Growth",
            subtitle: "Full Recovery & Neuromuscular Rest",
            isRestDay: true,
            estimatedMinutes: 0,
            exercises: [],
            recoveryGuidance: """
            Full recovery day. Muscles grow when resting, not when training.

            Focus on:
            • Nutritious, protein-rich meals to fuel muscle tissue remodeling.
            • Mild walking (e.g. 5,000–8,000 steps) for blood flow and nutrient delivery.
            • Mental recharge before the upcoming week.
            """
        ),

        // MARK: - DAY 7: Rest & Recovery
        WorkoutDaySchedule(
            id: "day-7-rest",
            dayNumber: 7,
            dayName: "Day 7",
            title: "Rest & Prep for Next Week",
            subtitle: "Review Progress & Prepare Weights",
            isRestDay: true,
            estimatedMinutes: 0,
            exercises: [],
            recoveryGuidance: """
            Final recovery day of the training block.

            Checklist:
            • Review your logged weights in the History tab.
            • Note any exercises where you hit the top rep target (e.g., 12 reps on all sets) to increase weight by +1.0kg to +2.5kg on Day 1.
            • Prepare your barbell plates, dumbbells, and clean your bench area.
            • Get to bed early for explosive energy tomorrow!
            """
        )
    ]
}
