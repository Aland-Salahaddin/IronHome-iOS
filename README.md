# IronHome iOS — Beginner Home Hypertrophy Tracker 🏋️‍♂️

A clean, focused iOS fitness application engineered specifically for a beginner training at home with **dumbbells**, a **barbell**, and a **flat bench** (no incline bench or gym machines).

The app structures training across a **4-day Upper/Lower split** plus an **optional Day 5 accessory/light activity day** (~60 minutes per session), complete with previous performance comparisons, top-of-rep-range progression detection, a built-in rest timer (60–120s), warm-up reminders, and complete automated pipelines to produce a sideloadable `.ipa` for **Sideloadly**.

---

## 📅 Weekly Workout Schedule & Structure

All exercises are strictly selected for a home gym equipped only with dumbbells, a barbell, and a flat bench:

### Day 1 — Upper A (Upper Body) (~60 min)
* **Flat Dumbbell Bench Press** — 3 sets × 8–12 reps
  * *Target & Benefit:* Chest (Pectoralis Major), anterior deltoids, and triceps with stable torso support on the flat bench.
* **Barbell Bent-Over Row** — 3 sets × 8–12 reps
  * *Target & Benefit:* Back width and thickness (lats, rhomboids, traps), rear deltoids, and biceps.
* **Seated Dumbbell Overhead Press** — 3 sets × 10–12 reps
  * *Target & Benefit:* Shoulders (anterior and lateral deltoids), triceps, and upright core stability on the flat bench.
* **Dumbbell Bicep Curl** — 2–3 sets × 10–15 reps
  * *Target & Benefit:* Direct biceps brachii stimulation, forearm flexors, and grip support.
* **Dumbbell Tricep Overhead Extension** — 2–3 sets × 10–15 reps
  * *Target & Benefit:* Triceps long head development with deep overhead stretch while seated on the flat bench.

### Day 2 — Lower A (Lower Body) (~60 min)
* **Barbell Back Squat** — 3 sets × 8–10 reps
  * *Target & Benefit:* Quadriceps, glutes, hamstrings, and systemic lower-body strength.
* **Barbell Romanian Deadlift (RDL)** — 3 sets × 10–12 reps
  * *Target & Benefit:* Hamstrings, glutes, and posterior chain development with controlled spinal hinge alignment.
* **Dumbbell Bulgarian Split Squat** — 2–3 sets × 8–10 reps per leg
  * *Target & Benefit:* Unilateral leg strength, hip balance, quads, and glutes using the flat bench for rear-foot elevation.
* **Plank** — 3 sets × 30–45 seconds
  * *Target & Benefit:* Anti-extension core endurance, transverse abdominis, and bracing mechanics for heavy lifts.

### Day 3 — Rest / Light Recovery
* Dedicated recovery day for central nervous system reset and muscle repair.
* Light 20–30 min outdoor walk, gentle hamstring and hip flexor mobility, hydration, and 7–9 hours of sleep.

### Day 4 — Upper B (Upper Body) (~60 min)
* **Flat Barbell Bench Press** — 3 sets × 8–10 reps
  * *Target & Benefit:* Peak horizontal pressing strength and chest mass on the flat bench.
* **Single-Arm Dumbbell Row** — 3 sets × 10–12 reps per side
  * *Target & Benefit:* Unilateral lat width and mid-back development using 3-point bench support (knee + hand on the flat bench).
* **Dumbbell Lateral Raise** — 3 sets × 12–15 reps
  * *Target & Benefit:* Lateral deltoid isolation for shoulder width and upper-body V-taper.
* **Dumbbell Hammer Curl** — 2–3 sets × 10–12 reps
  * *Target & Benefit:* Brachialis, brachioradialis, and biceps for arm thickness and elbow tendon resilience.
* **Dumbbell Skull Crusher** — 2–3 sets × 10–12 reps
  * *Target & Benefit:* Pure triceps isolation lying supine on the flat bench.

### Day 5 — Lower B & Optional Weekly Accessory (~60 min)
* **Dumbbell Goblet Squat** — 3 sets × 10–12 reps
  * *Target & Benefit:* Quadriceps, core engagement, and upright squat mechanics.
* **Barbell Hip Thrust** — 3 sets × 10–12 reps
  * *Target & Benefit:* Maximum glute hypertrophy and hip extension using the flat bench edge as the upper-back pivot.
* **Dumbbell Reverse Lunge** — 2–3 sets × 10 reps per leg
  * *Target & Benefit:* Quads and glutes with reduced patellar shear stress compared to forward lunges.
* **Optional Accessory Block (15–20 min if energy permits)** — 2–3 sets × 12–15 reps
  * *Target & Benefit:* Flexible finisher for arms, core, or light cardio while strictly preserving at least two full rest days per week.

### Days 6 & 7 — Rest & Recovery
* Full rest days allowing muscle tissue remodeling and preparation for the next week of progression.

---

## ⚡ Equipment, Tracking & Progression Engine

1. **Flat Bench Cues & Roles:**
   Every exercise identifies how the flat bench supports the lift (e.g. scapular pinning on presses, 3-point base for rows, rear-foot platform for split squats, and pivot edge for hip thrusts).
2. **Double-Progression Overload Engine:**
   * When you hit the top of the rep range (e.g., all 3 sets at 12 reps on the Flat Dumbbell Bench Press), the app triggers a green **Progression Milestone**:
     * **Barbell lifts:** Recommends adding **+2.5 kg** (+1.25 kg micro-plates per collar) next session.
     * **Dumbbell lifts:** Recommends adding **+1.0 kg to +2.0 kg** per dumbbell next session.
3. **Previous Performance Indicator:**
   During active workout logging, each set displays the exact weight and rep count achieved in the previous session directly beside your input steppers.
4. **Built-in Rest Timer (60–120s):**
   * Configurable auto-start on set completion.
   * Quick presets: **60s** (Arms & Lateral Raises), **90s** (Standard Hypertrophy), and **120s** (Heavy Squats & Presses).
   * Floating overlay bar while navigating the app with audio chimes and haptic feedback upon completion.
5. **Warm-up Reminders & Calculator:**
   * Automatically provides 1–2 ramp-up warm-up sets (50% for 8 reps, 75% for 4 reps) before working compound sets.
   * One-tap button to inject warm-up sets into the active session without counting toward hypertrophy volume.

---

## 📦 `.ipa` Build Order & Sideloadly Pathways

You can produce the sideloadable `.ipa` file using any of the three configured pathways:

### Pathway 1: GitHub Actions (Automated `macos-latest` CI/CD)
The repository includes `.github/workflows/build-ipa.yml`.

1. Create a GitHub repository and push this folder:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for IronHome iOS"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/IronHome-iOS.git
   git push -u origin main
   ```
2. Navigate to your repository on GitHub and click the **Actions** tab.
3. The **Build Sideloadable IPA (IronHome)** workflow will trigger automatically.
4. Once completed (~2 minutes), click the workflow run, scroll down to **Artifacts**, and download `IronHome-Sideloadly-IPA.zip`.
5. Unzip it to get `IronHome.ipa`.

### Pathway 2: Local macOS / Mac Cloud / VM
If you have access to a Mac or a cloud macOS runner (e.g., MacStadium, GitHub Codespaces with macOS, or Codemagic):

```bash
chmod +x build_ipa.sh
./build_ipa.sh
```

Or run manual commands:
```bash
# 1. Archive the project without code signing
xcodebuild archive \
  -project IronHome.xcodeproj \
  -scheme IronHome \
  -configuration Release \
  -archivePath build/IronHome.xcarchive \
  -destination "generic/platform=iOS" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  AD_HOC_CODE_SIGNING_ALLOWED=YES

# 2. Package into Payload structure
mkdir -p build/Payload
cp -R build/IronHome.xcarchive/Products/Applications/IronHome.app build/Payload/

# 3. Zip to .ipa
cd build
zip -r -q IronHome.ipa Payload
```
The resulting `IronHome.ipa` is created in `./build/IronHome.ipa`.

### Pathway 3: Interactive Web / PWA Preview
Open `preview/index.html` in any browser (Chrome, Edge, Safari) to interact immediately with the complete workout tracking engine, rest timer, progression highlights, and local storage data persistence on Windows!

---

## 📲 How to Sideload `IronHome.ipa` with Sideloadly

1. **Install Sideloadly:**
   * Download and install Sideloadly from [sideloadly.io](https://sideloadly.io/) (Available for Windows and macOS).
   * Ensure iTunes and iCloud (non-Microsoft Store version or official web installer) are installed on Windows as prompted by Sideloadly.
2. **Connect Device:**
   * Connect your iPhone to your PC using a USB cable (or enable Wi-Fi sync in iTunes).
   * Unlock your iPhone and tap **Trust This Computer** if prompted.
3. **Configure Sideloadly:**
   * Select your connected iPhone from the **iDevice** dropdown.
   * Drag and drop `IronHome.ipa` into the large IPA icon box on the left.
   * In the **Apple ID** field, enter your regular Apple ID email.
4. **Start Sideloading:**
   * Click **Start**.
   * Enter your Apple ID password (and 2FA verification code sent to your Apple device) when prompted. Sideloadly will fetch a free development certificate from Apple, sign the app, and install it on your device.
5. **Trust the Certificate on iPhone (First Time Only):**
   * On your iPhone, go to **Settings** → **General** → **VPN & Device Management**.
   * Under *Developer App*, tap your Apple ID email.
   * Tap **Trust "[Your Apple ID]"** and confirm.
6. **Enable Developer Mode (iOS 16+ Only):**
   * Go to **Settings** → **Privacy & Security**.
   * Scroll to the bottom and tap **Developer Mode**.
   * Toggle it **On** and restart your iPhone when prompted.
7. **Launch IronHome:**
   * Open **IronHome** on your home screen and begin your Day 1 Upper A session!

### ⏳ The 7-Day Apple ID Refresh Lifecycle
* Apple free developer accounts issue provisioning profiles that are valid for **7 days**.
* After 7 days, iOS will report that the app is no longer available until re-signed.
* **Your workout history and settings are 100% preserved:** When re-sideloading with Sideloadly at day 7, DO NOT delete the app. Simply connect your device, drag `IronHome.ipa` into Sideloadly, and click **Start**. It updates the signature in place without wiping your logged sets or personal records!
* *Tip:* Sideloadly supports automatic Wi-Fi refresh if Sideloadly is left open in the background on your home network.
