# Scuba Diver Plant Model — Test Plan

## Status: Draft
**Last Updated:** 2026-06-14  
**Architecture Spec:** [scuba-diver-architecture.md](scuba-diver-architecture.md)

---

## 1. Overview

**Validation Stages:**
- **Stage 1: Component Open-Loop** — Verify individual gas circuit components respond correctly to prescribed inputs
- **Stage 2: Integrated Open-Loop** — Drive plant with known breath/BCD signals, verify gas consumption and motion
- **Stage 3: Closed-Loop** — Full harness with controller; validate dive profiles against acceptance criteria

**Validation Philosophy:** Each stage must pass before proceeding. Failures at higher stages are debugged by dropping back to lower stages.

**Primary validation references:**
- SAC rate data: Buzzacott et al. (2014) — 12-25 L/min surface equivalent
- Buoyancy model: Valenko et al. (2016) — dynamic BCD/buoyancy model
- Drag: Passmore & Rickers (2002) — Cd = 1.0-1.2
- Dive profiles: US Navy Diving Manual Rev 7 — ascent rates, safety stops

---

## 2. Subsystem Open-Loop Validation

### 2.1 Gas Tank Depletion

**What is validated:** Tank pressure drops correctly as gas is extracted

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Physical Basis |
|------|-------|-----------------|---------------------|----------------|
| Tank pressure at full | n_tank = 98.47 mol | P = 200e5 Pa | Within 0.1% of PV/nRT | Ideal gas law |
| Tank pressure at half | n_tank = 49.24 mol | P = 100e5 Pa | Within 0.1% | Linear in n |
| Gas weight at full | n_tank = 98.47 mol | f = 28.0 N | Within 1% of n×M×g | Weight formula |

#### Transient Tests

| Test | Excitation | Expected Response | Acceptance Criterion | Physical Basis |
|------|-----------|-------------------|---------------------|----------------|
| Constant extraction | 0.01 mol/s outflow for 600s | Pressure drops from 200 to 197.6 bar | Linear drop, ΔP = Δn×RT/V = 2.4 bar | Mass conservation |

### 2.2 Second Stage Regulator (Demand Valve)

**What is validated:** Opens only on inhale; flow proportional to demand

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Physical Basis |
|------|-------|-----------------|---------------------|----------------|
| No demand | P_lung = P_amb | n_dot = 0 | Exactly zero flow | Valve closed |
| Cracking threshold | P_lung = P_amb - 100 Pa | n_dot ≈ 0 (just at crack) | Flow < 0.001 mol/s | At crack pressure |
| Full inhale | P_lung = P_amb - 300 Pa | n_dot = (300-100)/6000 = 0.033 mol/s | Within 5% | Linear above crack |

#### Edge Cases

| Test | Condition | Expected Behavior | Acceptance Criterion |
|------|-----------|-------------------|---------------------|
| Exhale (positive effort) | P_lung > P_amb | Zero flow through 2nd stage | n_dot = 0 (one-way) |
| Low tank pressure | P_tank < P_amb + IP_offset | Reduced flow, no negative | Flow ≥ 0 always |

### 2.3 Lungs (Breathing Cycle)

**What is validated:** Volume oscillates with breathing; gas enters on inhale, exits on exhale

#### Transient Tests

| Test | Excitation | Expected Response | Acceptance Criterion | Physical Basis |
|------|-----------|-------------------|---------------------|----------------|
| Single breath at surface | breath_effort = -200 Pa for 2s, then +200 Pa for 2s | V_lungs increases ~0.5L then returns to residual | Tidal volume within 20% of 0.5L | Physiology standard |
| Breathing at 20m | Same effort at 20m depth | Same moles transferred but volume is ~1/3 of surface | Volume = n×RT/P_amb (3 ATA) | Boyle's law |
| SAC rate check | 15 bpm continuous at 20m | Gas consumption ~15 L/min surface equivalent | Within ±25% | Buzzacott 2014 |

### 2.4 BCD Bladder

**What is validated:** Volume responds to moles and depth; buoyancy force correct

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Physical Basis |
|------|-------|-----------------|---------------------|----------------|
| Volume at surface | n_bcd = 0.298 mol, depth = 0 | V = 0.298×8.314×293.15/101325 = 7.17 L | Within 1% | PV=nRT |
| Volume at 20m | n_bcd = 0.298 mol, depth = 20m | V = 0.298×2439.5/302456 = 2.4 L | Within 1% | Boyle compression |
| Volume at 40m | n_bcd = 0.298 mol, depth = 40m | V = 0.298×2439.5/503587 = 1.44 L | Within 1% | 5 ATA |
| Buoyancy at 20m | V_bcd = 2.4 L | F_buoy = -1025×9.81×0.0024 = -24.1 N | Within 2% | Archimedes |
| Overfill stiffness | V_free > V_max (15L) | P_excess > 0, internal P > P_amb | K_wall × ΔV positive | Wall stiffness |

#### Edge Cases

| Test | Condition | Expected Behavior | Acceptance Criterion |
|------|-----------|-------------------|---------------------|
| Empty BCD | n_bcd → 0 with purge open | n_bcd stays ≥ 0, no negative moles | Clamp active |
| BCD at V_max | n_bcd such that V_free = 16 L | Actual volume = 15L, excess pressure drives OPRV | V_actual ≤ V_max |

### 2.5 DiverBody (Neutral Buoyancy Check)

**What is validated:** Force balance achieves neutral buoyancy at design point

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Physical Basis |
|------|-------|-----------------|---------------------|----------------|
| Neutral at 20m | Proper BCD fill, all volumes at 20m | Net vertical force ≈ 0 | |F_net| < 5 N | Neutral buoyancy definition |
| Negative at surface (empty BCD) | n_bcd = 0, depth = 1m | Net force positive (sinks) | F_net > 20 N (2+ kg negative) | Weighted for descent |
| Terminal velocity | Free fall, empty BCD | v_terminal ≈ 0.5-1.0 m/s | Matches drag balance: v = √(2×F_net/(ρ×Cd×A)) | Drag equilibrium |

---

## 3. Integrated Open-Loop Plant Validation

### 3.1 Passive Descent (No Controller)

**Operating Conditions:** Surface start (1m), empty BCD (n_bcd=0.05), no inflate/purge commands

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| inflate_cmd | Constant | 0 | 60 s |
| purge_cmd | Constant | 0 | 60 s |
| breath_effort | Sinusoidal | A=200 Pa, f=0.25 Hz | 60 s |

**Expected Outputs:**

| Signal | Expected Behavior | Acceptance Criterion | Comparison Method |
|--------|-------------------|---------------------|-------------------|
| depth | Increases (diver sinks due to negative buoyancy) | Depth > 5m at t=30s | Physics: ~2 kg negative → a ≈ 0.02 m/s² |
| velocity | Increases then saturates at terminal velocity | v_max < 1.5 m/s | Drag balance |
| tank_pressure | Slight decrease (breathing at increasing depth) | ΔP < 5 bar in 60s | SAC at shallow depth |

### 3.2 BCD Inflation Arrest

**Operating Conditions:** Start at 10m depth, diver sinking at 0.3 m/s, apply inflate command

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| inflate_cmd | Step | 0→1 at t=10s, 1→0 at t=15s (5s burst) | 60 s |
| purge_cmd | Constant | 0 | 60 s |
| breath_effort | Sinusoidal | A=200 Pa, f=0.25 Hz | 60 s |

**Expected Outputs:**

| Signal | Expected Behavior | Acceptance Criterion | Comparison Method |
|--------|-------------------|---------------------|-------------------|
| depth | Descent slows, stops, possibly reverses | Descent arrested within 10s of inflate | Momentum + buoyancy |
| velocity | Decelerates toward zero | |v| < 0.05 m/s within 15s of inflate end | Force balance |
| bcd_volume | Increases during inflate burst | ΔV > 0.5 L | Flow rate through inflate valve |

### 3.3 Boyle Expansion on Ascent

**Operating Conditions:** Start at 30m with neutral BCD, apply constant purge

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| inflate_cmd | Constant | 0 | 120 s |
| purge_cmd | Step | 0→0.3 at t=5s (partial purge to initiate ascent) | 120 s |
| breath_effort | Sinusoidal | A=200 Pa, f=0.25 Hz | 120 s |

**Expected Outputs:**

| Signal | Expected Behavior | Acceptance Criterion | Comparison Method |
|--------|-------------------|---------------------|-------------------|
| depth | Decreases (ascent) | Ascent rate increases as BCD expands (Boyle) | Positive feedback expected |
| bcd_volume | Increases despite purge (Boyle wins if purge too slow) | Volume expansion observable | V = nRT/P_amb, P_amb decreasing |
| velocity | Accelerating ascent if purge insufficient | Documents the control challenge | Validates need for active control |

### 3.4 Gas Consumption Rate Verification

**Operating Conditions:** Hold at 20m (neutral buoyancy), breathe normally for 10 min

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| inflate_cmd | Constant | 0 | 600 s |
| purge_cmd | Constant | 0 | 600 s |
| breath_effort | Sinusoidal | A=200 Pa, f=0.25 Hz (15 bpm) | 600 s |

**Expected Outputs:**

| Signal | Expected Behavior | Acceptance Criterion | Comparison Method |
|--------|-------------------|---------------------|-------------------|
| tank_pressure | Linear decrease | ΔP ≈ 15-25 bar over 10 min at 20m | SAC formula: 15 L/min × 3 ATA × 10 min = 450 L = ~20% of tank |
| n_tank (moles) | Decrease by ~18 mol | ΔP×V/(RT) = 18±5 mol | Molar conservation |
| depth | Remains near 20m (±0.5m) | Stable if BCD properly initialized | Neutral buoyancy |

---

## 4. Closed-Loop Validation

### 4.1 Scenario 1: Recreational Square Profile (18m)

**Setup:** `full_dive_test.slx` with `dive_profiles('square_18m')`, default parameters

**Scenario:**
1. Start at 1m, nearly empty BCD, diver negatively buoyant
2. Controller commands descent to 18m
3. Hold at 18m for 40 minutes
4. Ascent to 5m at ≤ 9 m/min
5. Safety stop 3 min at 5m
6. Surface to 1m

**Acceptance Criteria:**

| Metric | Target | Physical Justification |
|--------|--------|------------------------|
| Descent rate | 0.3–0.5 m/s | Controlled comfortable descent (US Navy: max 23 m/min) |
| Bottom depth RMS error | < 0.3 m | Comfortable neutral buoyancy for recreational diver |
| BCD activity during hold | BCD commands = 0 for >90% of hold time | Real divers use breath, not BCD, for fine trim |
| Max ascent rate | ≤ 0.167 m/s (10 m/min) | Modern standard (US Navy Rev 7, PADI) |
| Safety stop depth error | < ±0.5 m from 5m | Must stay at stop depth |
| SAC rate (derived) | 12–20 L/min surface equivalent | Buzzacott 2014 range for relaxed swimming |
| Tank end pressure | > 50 bar (reserve) | Standard 50-bar reserve |
| No unphysical states | n_tank > 0, n_bcd ≥ 0, depth ≥ 0 | Physical constraints |

### 4.2 Scenario 2: Multi-Level Profile

**Setup:** `dive_profiles('multi_level')`, default parameters

**Scenario:**
1. Descent to 30m, hold 10 min
2. Ascent to 20m at 9 m/min, hold 15 min
3. Ascent to 10m at 9 m/min, hold 15 min
4. Safety stop at 5m, surface

**Acceptance Criteria:**

| Metric | Target | Physical Justification |
|--------|--------|------------------------|
| Level transition time | < 90s to stabilize at new depth | BCD adjustment + breath-trim settling |
| BCD adjustment at each level | Single inflate/purge burst, then idle | Real diver: set BCD once per depth, breathe to hold |
| Depth overshoot at each level | < 1.0 m | Acceptable for recreational diving |
| Max ascent rate between levels | ≤ 0.167 m/s | Safety standard |
| Gas consumption at 30m vs 10m | ~3:2 ratio | Proportional to absolute pressure |

### 4.3 Scenario 3: Deep Bounce (40m)

**Setup:** `dive_profiles('deep_bounce')`, increased weights (6 kg)

**Scenario:**
1. Rapid descent to 40m
2. 5 min bottom time
3. Ascent with deep stop at 20m
4. Safety stop, surface

**Acceptance Criteria:**

| Metric | Target | Physical Justification |
|--------|--------|------------------------|
| Max depth overshoot | < 2 m past 40m | Hard stops at 45m provide backup |
| BCD volume at 40m | 0.5–3 L (partial fill for neutral) | Must compensate for compression |
| Ascent from 40m: BCD volume change | Observable Boyle expansion | V doubles from 40m to 20m |
| OPRV activation | May trigger if vent too slow | Validates safety mechanism |
| Max ascent rate | ≤ 0.167 m/s | Critical for deep dives |

### 4.4 Scenario 4: Shallow Endurance (10m, 60 min)

**Setup:** `dive_profiles('shallow_60min')`, tropical config (12 bpm, low SAC)

**Scenario:**
1. Gentle descent to 10m
2. 55 min at 10m with low activity
3. Direct ascent, safety stop, surface

**Acceptance Criteria:**

| Metric | Target | Physical Justification |
|--------|--------|------------------------|
| Depth stability over 55 min | < ±0.3m, no drift | Long-term stability test |
| BCD activity during hold | Zero BCD commands for entire 55-min hold | Breath-only control at constant depth |
| SAC rate | 10–15 L/min surface equivalent | Low activity tropical dive |
| Tank end pressure | > 80 bar (plenty of gas at 10m) | Shallow = low consumption |
| Simulation time (wall-clock) | < 5 min | Performance requirement |

---

## 5. Simulation Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver | ode23t | Required for Simscape DAE; L-stable implicit |
| Relative tolerance | 1e-4 | Balance accuracy/speed; tighten to 1e-5 for publication plots |
| Max step size | 0.1 s | Captures 0.25 Hz breathing; reduce to 0.05 if instabilities |
| Stop time | Scenario-dependent | See implementation plan Appendix B |
| Initial conditions | From `scuba_params.m` + scenario overrides | Surface-start or depth-start |
| Signal logging | Simscape log (all) + To Workspace for depth, vel, P_tank, V_bcd | Post-processing |

---

## 6. Input Signal Definitions

| Signal ID | Type | Parameters | Used In |
|-----------|------|-----------|---------|
| BREATH_NORMAL | Sinusoidal | A=200 Pa, f=0.25 Hz (15 bpm) | All scenarios |
| BREATH_RELAXED | Sinusoidal | A=150 Pa, f=0.20 Hz (12 bpm) | Scenario 4 |
| BREATH_STRESSED | Sinusoidal | A=300 Pa, f=0.33 Hz (20 bpm) | Sensitivity tests |
| INFLATE_STEP | Step | 0→1 at t_trigger, duration 2-5s | Open-loop BCD tests |
| PURGE_STEP | Step | 0→1 at t_trigger, duration 2-5s | Open-loop BCD tests |
| PROFILE_SQUARE_18 | Piecewise-linear | See Appendix B, Scenario 1 | Closed-loop Scenario 1 |
| PROFILE_MULTI | Piecewise-linear | See Appendix B, Scenario 2 | Closed-loop Scenario 2 |
| PROFILE_DEEP | Piecewise-linear | See Appendix B, Scenario 3 | Closed-loop Scenario 3 |
| PROFILE_SHALLOW | Piecewise-linear | See Appendix B, Scenario 4 | Closed-loop Scenario 4 |

---

## 7. Gherkin Scenario Templates

### 7.1 Gas Consumption Verification

```gherkin
Feature: Scuba Diver - Gas Consumption Rate

  Scenario: SAC rate at 20m matches expected range
    Given the model "full_dive_test.slx" is loaded
    And the solver is "ode23t" with relative tolerance 1e-4
    And parameter "ic_depth" is set to 20
    And parameter "bcd_n_init" is set to 0.298
    And the dive profile is "hold_at_depth" with depth 20 and duration 600

    When the simulation runs for 600 seconds
    And breathing is active at 15 bpm with amplitude 200 Pa

    Then the tank pressure drop shall be between 15 and 30 bar
    And the derived SAC rate shall be between 12 and 20 L/min surface equivalent
    And "depth" shall remain within 0.5 m of 20 m throughout
```

### 7.2 Ascent Rate Compliance

```gherkin
Feature: Scuba Diver - Ascent Rate Safety

  Scenario: Controlled ascent from 30m stays within safe rate
    Given the model "full_dive_test.slx" is loaded
    And the dive profile is "multi_level" starting at depth 30
    And the BCD controller is active

    When the ascent phase begins at t_ascent
    
    Then the ascent rate shall not exceed 0.167 m/s at any time
    And the ascent rate shall not exceed 0.167 m/s for more than 2 consecutive seconds
    And the diver shall reach 5 m within 300 seconds of ascent start
```

### 7.3 BCD Boyle Expansion Control

```gherkin
Feature: Scuba Diver - Boyle Expansion Management

  Scenario: BCD does not cause runaway ascent from 40m
    Given the model "full_dive_test.slx" is loaded
    And the dive profile is "deep_bounce" with bottom depth 40
    And the BCD controller is active

    When the ascent phase begins from 40m

    Then the BCD volume shall increase during ascent (Boyle expansion observable)
    And the ascent rate shall remain controlled (< 0.167 m/s)
    And the OPRV may activate if BCD pressure exceeds 3 psi gauge
    And the diver shall not reach surface in less than 180 seconds from 40m
```

### 7.4 Full Dive Completion

```gherkin
Feature: Scuba Diver - Complete Dive Profile

  Scenario: Recreational square profile completes successfully
    Given the model "full_dive_test.slx" is loaded
    And the dive profile is "square_18m"
    And all parameters are at nominal values

    When the simulation runs to completion

    Then the simulation shall complete without solver errors
    And tank moles shall remain positive throughout
    And BCD moles shall remain non-negative throughout
    And depth shall remain between 0 and 45 m throughout
    And the diver shall return to within 2 m of surface by simulation end
    And final tank pressure shall be above 50 bar
```

---

## 8. Parameter Sensitivity Tests

| Parameter | Nominal | Range | Test | Acceptance Criterion |
|-----------|---------|-------|------|---------------------|
| diver.mass | 80 kg | 60–100 kg | Scenario 1 re-run | Completes; depth error < 1.0m (relaxed) |
| weightbelt.mass | 4 kg | 2–8 kg | Scenario 1 re-run | Completes; may need longer descent with less weight |
| breathing.rate | 15 bpm | 10–25 bpm | Scenario 1 re-run | Tank doesn't empty; SAC scales linearly with rate |
| diver.dragCoeff | 1.1 | 0.8–1.5 | Descent test | Terminal velocity changes; ascent rate still controlled |
| secondStage.R_open | 6000 | 3000–12000 | Gas consumption test | SAC rate changes proportionally; no solver failure |
| bcd.initMoles | 0.298 | 0.1–0.5 | Hold at 20m | Controller compensates; may take longer to stabilize |
| tank.startPressure | 200e5 | 150e5–230e5 | Scenario 4 (60 min) | Low fill: may run out; high fill: no issue |

**Method:** For each parameter, run specified scenario at nominal, +boundary, and -boundary. Model must remain stable and produce physically reasonable results. Controller may need longer to stabilize but must not fail.

---

## 9. Numerical Robustness Tests

| Test | Variation | Acceptance Criterion |
|------|-----------|---------------------|
| Tighter tolerance | RelTol = 1e-5 (10× tighter) | Results within 2% of baseline; longer sim time acceptable |
| Looser tolerance | RelTol = 1e-3 (10× looser) | Results within 5% of baseline; no NaN or solver failure |
| Smaller max step | MaxStep = 0.01 s | Results within 1% of baseline |
| Larger max step | MaxStep = 0.5 s | Solver may reject steps but completes without failure |
| Alternative solver | ode15s (stiff, multistep) | Completes; results within 5% of ode23t baseline |
| Zero initial velocity | v₀ = 0 | Baseline (already default) |
| Small initial velocity | v₀ = 0.1 m/s downward | Converges to same trajectory within 10s |

---

## Appendix A: Test Execution Commands

```matlab
% Run single scenario
initWorkspace;
profile = dive_profiles('square_18m');
sim('full_dive_test');

% Run all scenarios
run_scenarios;  % Script that iterates over all profiles

% Run sensitivity sweep
results = sweep_parameter('diver_mass', [60 80 100], 'square_18m');

% Verify gas consumption
[sac_rate, tank_used_pct] = compute_sac(out, params);
assert(sac_rate > 12 && sac_rate < 20, 'SAC out of range');
```

---

## Appendix B: Acceptance Criteria Summary

| Criterion | Value | Source |
|-----------|-------|--------|
| Max ascent rate | 0.167 m/s (10 m/min) | US Navy Diving Manual Rev 7 |
| Max descent rate | 0.5 m/s (30 m/min) | US Navy (75 ft/min limit) |
| Depth hold accuracy | ±0.3–0.5 m | Valenko 2013, Riznar 2015 (ABCD systems) |
| SAC rate (relaxed) | 12–20 L/min | Buzzacott 2014 field data |
| Safety stop duration | ≥ 3 min | PADI, SSI, NAUI standards |
| Safety stop depth | 5 ± 1 m | Industry standard |
| Tank reserve | > 50 bar | Standard recreational practice |
| BCD volume limits | [0, 15 L] | Physical bladder capacity |
