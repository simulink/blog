# Scuba Diver — Full-Dive Harness Implementation Plan

## Status: Not Started
**Last Updated:** 2026-06-14  
**Architecture Spec:** [scuba-diver-architecture.md](scuba-diver-architecture.md)  
**Test Plan:** [scuba-diver-test-plan.md](scuba-diver-test-plan.md)

---

## 1. Progress Summary

| Phase | Status | Subsystems |
|-------|--------|------------|
| Phase 0: Interface & Profile Infrastructure | 🔲 Not Started | Parameter scripts, profile generators |
| Phase 1: Breathing Generator | 🔲 Not Started | Respiratory waveform subsystem |
| Phase 2: Dive Profile Controller | 🔲 Not Started | Stateflow dive FSM + BCD controller |
| Phase 3: Harness Integration | 🔲 Not Started | full_dive_test.slx assembly |
| Phase 4: Multi-Scenario Validation | 🔲 Not Started | All 4 scenarios from system spec |

---

## 2. Model Hierarchy

```
full_dive_test.slx (root)
├── Dive Profile (Stateflow or From Workspace)     # Generates depth_target, phase signals
├── Breathing Generator (Subsystem)                 # Sinusoidal breath_effort signal
│   ├── Breath Oscillator                          # sin(2π × rate/60 × t) with amplitude
│   └── Depth-Scaled Effort                        # Effort scales with depth for realistic WOB
├── BCD Controller (Stateflow or MATLAB Fcn)       # Depth error → inflate/purge commands
│   ├── Descent logic (inflate for rate control)
│   ├── Hold logic (deadband + periodic corrections)
│   └── Ascent logic (vent to limit ascent rate)
├── Plant (Model Reference → Scuba_Diver.slx)     # 3 in, 2 out
├── Gas Consumption Monitor (Subsystem)            # Integrates flow, computes SAC
├── Safety Monitor (Subsystem)                     # Rate limits, ceiling violations
├── Logging & Scopes                               # Key signals for post-processing
└── Stop Simulation (Stop block)                   # Depth < 0 or tank empty
```

---

## 3. Dependencies

### 3.1 MATLAB Toolbox Dependencies

| Toolbox | Required For | Required? |
|---------|-------------|-----------|
| Simulink | All | Yes |
| Simscape | Plant model physics | Yes |
| Stateflow | Dive profile FSM, BCD controller | Yes |
| Simscape (custom library) | Gas domain components | Yes (rebuild with `sscbuild`) |

### 3.2 Deliverables

| Asset | Path | Description |
|-------|------|-------------|
| Plant model | `models/Scuba_Diver.slx` | Reusable plant: 3 inports, 2 outports |
| Descent test harness | `models/descent_test.slx` | Simple drop-and-hold for initial validation |
| Full-dive test harness | `models/full_dive_test.slx` | Multi-scenario dive profile harness |
| Parameter file | `parameters/scuba_params.m` | Master parameter configuration |
| Gas properties | `parameters/gas_properties.m` | Gas mix lookup (air, nitrox32) |
| Diver configs | `parameters/diver_configs.m` | Preset configurations (beginner, experienced, nitrox) |
| Profile generator | `scripts/dive_profiles.m` | Multi-scenario dive profile function |
| Compiled library | `models/scuba_lib.slx` | Built from .ssc source via `sscbuild` |

---

## 4. Workstream Graph

```
                    Phase 0: Interface & Profile Infrastructure
                    (freeze plant ports, create profile functions, create params)
                                    │
               ┌────────────────────┼────────────────────┐
               │                    │                    │
        ┌──────▼──────┐     ┌──────▼──────┐     ┌──────▼──────┐
        │ Breathing    │     │ Dive Profile │     │ BCD         │
        │ Generator    │     │ State Machine│     │ Controller  │
        │ (Phase 1)    │     │ (Phase 2a)   │     │ (Phase 2b)  │
        └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
               │                    │                    │
               └────────────────────┼────────────────────┘
                                    │
                    Phase 3: Harness Integration
                    (wire all subsystems + plant, configure solver, add monitors)
                                    │
                    Phase 4: Multi-Scenario Validation
                    (run all profiles, validate against acceptance criteria)
```

---

## 5. Build Phases

### Phase 0: Interface & Profile Infrastructure
**Goal:** Create parameter infrastructure, dive profile functions, and define plant interface contract  
**Duration:** 2–3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 0.1 | Create `scuba_params.m` | Master parameter function returning full configuration struct |
| 0.2 | Create `gas_properties.m` | Gas mix lookup (air, nitrox32) |
| 0.3 | Create `load_plant_params.m` | Flattens struct into workspace variables for Simscape blocks |
| 0.4 | Create `initWorkspace.m` | Project startup script calling param loaders |
| 0.5 | Create `dive_profiles.m` | Function returning profile struct for each scenario (depths, times, rates) |
| 0.6 | Create `compute_bcd_init_moles.m` | Helper: given target_depth, compute n_bcd for neutral buoyancy |
| 0.7 | Document sign conventions | Add comment header to harness matching architecture spec §6.4 |

**Verification:**
- `initWorkspace` runs without error
- `dive_profiles('square_18m')` returns valid struct
- `compute_bcd_init_moles(20)` ≈ 0.298 mol

**Checkpoint 0:** Infrastructure ready; interface contract frozen; profile functions tested.

---

### Phase 1: Breathing Generator with Depth Trim
**Goal:** Create a subsystem that generates realistic breath_effort with biased breathing for fine depth control  
**Duration:** 3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 1.1 | Design base waveform | Sinusoidal: `effort = -A × sin(2π × f × t)` where f = rate/60, A = 200 Pa |
| 1.2 | Add depth scaling | Work of breathing increases with gas density: A_eff = A × (1 + depth/40) |
| 1.3 | Add breath-trim bias | Asymmetric inhale/exhale to control lung volume for fine buoyancy adjustment |
| 1.4 | Implement duty-cycle shift | Bias toward longer inhale (fuller lungs → more buoyant) or longer exhale (emptier lungs → less buoyant) |
| 1.5 | Implement amplitude asymmetry | Deeper inhale or deeper exhale to shift mean lung volume |
| 1.6 | Parameterize | Inputs: breathing_rate [bpm], amplitude [Pa], depth [m], depth_error [m], velocity [m/s] |
| 1.7 | Build subsystem | Simulink subsystem with oscillator + bias logic |
| 1.8 | Test standalone | Verify waveform shape, frequency, and mean lung volume shift with bias |

**Waveform specification:**

```
Base oscillator:
  breath_effort(t) = -A_eff × sin(2π × f × t + phase_bias)
  A_eff = A_base × (1 + depth/40)  (gas density scaling)

Depth trim via breathing bias:
  When diver is slightly too deep (depth_error > deadzone):
    - Bias toward fuller lungs: longer/deeper inhale, shorter exhale
    - Mean lung volume increases → net buoyancy increases → diver rises
  When diver is slightly too shallow (depth_error < -deadzone):
    - Bias toward emptier lungs: shorter inhale, longer/deeper exhale
    - Mean lung volume decreases → net buoyancy decreases → diver sinks

Bias mechanisms (combined):
  1. Duty-cycle shift: inhale_fraction = 0.5 + duty_shift × bias
     (bias in [-1, 1] from depth error with deadzone and saturation)
  2. Amplitude asymmetry: inhale_amp = A × (1 + amp_gain × bias)
                          exhale_amp = A × (1 - amp_gain × bias)

Bias computation:
  raw_error = depth - depth_target
  vel_term = K_vel × velocity
  bias_input = raw_error + vel_term
  bias = deadzone_then_saturate(bias_input, deadzone=0.3m, saturation=1.5m)

Parameters:
  A_base = 200 Pa (peak muscular pressure, Held & Pendergast 2013)
  rate = 15 bpm (default)
  deadzone = 0.3 m (no bias below this error)
  saturation = 1.5 m (bias saturates at ±1 beyond this)
  K_vel = 0.8 s/m (velocity damping)
  duty_shift_max = 0.10 (fraction of cycle shifted)
  amp_gain = 0.3 (±30% asymmetry at full bias)
```

**Physical basis:** Real divers maintain neutral buoyancy at a constant depth primarily through breath control — inhaling deeper to rise slightly, exhaling more to sink slightly. The BCD is only adjusted for large depth changes or to compensate for wetsuit compression. The ~0.5L tidal volume provides approximately ±0.5 kgf of buoyancy modulation, sufficient for ±0.3m corrections.

**Verification:**
- At surface (depth=0): peak effort = ±200 Pa, frequency = 0.25 Hz
- At 30m: peak effort = ±350 Pa (depth scaling active)
- With +0.5m depth error: mean lung volume visibly higher than neutral (bias active)
- With zero error: symmetric breathing (no bias)
- 2nd stage opens during negative half-cycle (verified in plant)

**Checkpoint 1:** Breathing subsystem produces correct waveform with active depth trim; plant responds with gas flow and subtle buoyancy changes.

---

### Phase 2a: Dive Profile State Machine
**Goal:** Stateflow chart that sequences through dive phases and outputs depth_target  
**Duration:** 3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 2a.1 | Define states | SURFACE → DESCEND → BOTTOM → ASCEND → SAFETY_STOP → FINAL_ASCENT → SURFACED |
| 2a.2 | Define transitions | Time-based or depth-based triggers per profile struct |
| 2a.3 | Implement depth_target ramp | Linear interpolation between waypoints at prescribed rates |
| 2a.4 | Add phase output | Enum signal indicating current phase (for BCD controller) |
| 2a.5 | Parameterize from profile struct | All depths, durations, rates come from workspace struct |
| 2a.6 | Test with ideal depth follower | Verify profile timing matches `dive_profiles()` output |

**State machine design:**

```
SURFACE (t < t_start)
  → DESCEND [on: t ≥ t_start]
     depth_target ramps from start_depth to target_depth at descent_rate
  → BOTTOM [on: depth_target reached]
     depth_target = bottom_depth (constant)
     For multi-level: sequence of sub-targets
  → ASCEND [on: bottom_time elapsed]
     depth_target ramps up at ascent_rate (max 9 m/min)
     For stepped: hold at intermediate depths
  → SAFETY_STOP [on: depth_target = safety_depth]
     Hold at 5m for safety_duration
  → FINAL_ASCENT [on: safety time elapsed]
     depth_target ramps to 1m at 3 m/min
  → SURFACED [on: depth_target = 1m]
     Simulation continues until stable or stop time
```

**Verification:**
- Profile timing matches `dive_profiles()` specification
- Ascent rate never exceeds 0.167 m/s (10 m/min) in output
- State transitions occur at correct times/depths

---

### Phase 2b: BCD Controller (Large Maneuvers Only)
**Goal:** Controller that manages inflate/purge for descent, ascent, and level changes — NOT for fine depth hold  
**Duration:** 3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 2b.1 | Define control law | BCD fires only for large depth errors or phase transitions; breathing handles the rest |
| 2b.2 | Phase-dependent behavior | Descent: gravity + brake; Hold: BCD only if breath-trim saturated; Ascent: vent Boyle expansion |
| 2b.3 | Implement in Stateflow or MATLAB Function | Inputs: depth, vel, depth_target, phase → Outputs: inflate_cmd, purge_cmd |
| 2b.4 | Add safety overrides | Max ascent rate limiter: force purge if ascending > 10 m/min |
| 2b.5 | Anti-windup | Don't continuously inflate when at surface (depth < 2m) |
| 2b.6 | Tune gains | Iterate until BCD fires rarely during hold; breathing does the fine work |

**Control law design:**

```
depth_error = depth_target - depth  (positive = too shallow, need to descend)

DESCENT phase:
  inflate_cmd = 0 (let gravity pull down, diver is negatively buoyant)
  purge_cmd = 0
  If vel > max_descent_rate: inflate_cmd = K_brake × (vel - max_descent_rate)
  Near target depth (within 2m): inflate BCD toward neutral buoyancy for that depth

HOLD phase:
  Primary control: breathing trim (Phase 1 handles ±0.3m via lung volume bias)
  BCD intervenes ONLY when depth error exceeds bcd_deadband (default 2.0m):
    If depth_error > bcd_deadband:  purge_cmd = K_p × (depth_error - bcd_deadband)
    If depth_error < -bcd_deadband: inflate_cmd = K_p × (|depth_error| - bcd_deadband)
    Otherwise: inflate_cmd = 0; purge_cmd = 0 (let breathing handle it)
  This models real diver behavior: BCD is set-and-forget at a given depth.

ASCEND phase:
  purge_cmd = K_ascent × max(0, Boyle_expansion_rate)  (preemptive venting)
  If |vel| > max_ascent_rate: purge_cmd = 1.0 (emergency vent)
  inflate_cmd = 0
  Between levels (multi-level profile): re-establish neutral BCD at new depth

SAFETY_STOP phase:
  One-time BCD adjustment to neutral at 5m
  Then breathing-only for fine hold (same as HOLD with tight deadband)

Parameters:
  K_p = 2.0 (1/m) — proportional gain (BCD, large errors only)
  K_brake = 10.0 (s/m) — descent rate braking
  K_ascent = 0.5 — ascent vent gain
  bcd_deadband = 2.0 m — BCD only fires beyond this depth error
  max_descent_rate = 0.5 m/s
  max_ascent_rate = 0.167 m/s (10 m/min)
```

**Physical basis:** Real divers set the BCD once at each depth to achieve approximate neutral buoyancy, then use breath control for fine adjustments (±0.3m). The BCD is only actively used during descent (to slow down and establish neutral), ascent (to vent expanding gas), and level changes (to re-establish neutral at a new depth). During a steady hold at constant depth, BCD commands should be rare — the breathing trim handles small perturbations through lung volume modulation (~0.5L tidal volume ≈ ±0.5 kgf buoyancy).

**Verification:**
- In HOLD at 20m: BCD commands are zero or near-zero for >90% of hold time
- Breathing trim maintains depth within ±0.5m during hold
- BCD fires only during descent, ascent, or if perturbation exceeds 2m
- During ASCENT: velocity never exceeds 0.167 m/s for more than 2s
- During DESCENT: velocity stays below 0.5 m/s
- No chattering (inflate and purge not simultaneously active)

---

### Phase 3: Harness Integration
**Goal:** Assemble `full_dive_test.slx` with all subsystems wired to plant  
**Duration:** 3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 3.1 | Create new model | `models/full_dive_test.slx` — blank Simulink model |
| 3.2 | Add Model Reference | Reference `Scuba_Diver.slx` as plant |
| 3.3 | Wire breathing generator | depth output → breathing gen → breath_effort input |
| 3.4 | Wire dive profile | Profile chart → depth_target → BCD controller |
| 3.5 | Wire BCD controller | depth, vel, depth_target, phase → inflate_cmd, purge_cmd |
| 3.6 | Add monitoring | Gas consumption integrator, safety monitor, scopes |
| 3.7 | Configure solver | ode23t, RelTol=1e-4, MaxStep=0.1 |
| 3.8 | Add initialization callback | Model InitFcn: `initWorkspace; profile = dive_profiles('square_18m');` |
| 3.9 | Add stop conditions | Depth < 0 OR tank_moles < 1 (reserve pressure) |
| 3.10 | Add logging | To Workspace blocks or Simscape logging for truth outputs |

**Verification:**
- Model compiles without errors
- Runs Scenario 1 (square 18m) to completion
- Depth, velocity, tank pressure signals look physically reasonable
- No solver failures or NaN values

**Checkpoint 3:** Harness runs end-to-end for at least one scenario.

---

### Phase 4: Multi-Scenario Validation
**Goal:** Run all 4 scenarios, validate against acceptance criteria from system spec  
**Duration:** 2–3 hours

| Step | Operation | Details |
|------|-----------|---------|
| 4.1 | Run Scenario 1 | Square 18m, 45 min — validate SAC, depth stability |
| 4.2 | Run Scenario 2 | Multi-level 30→20→10m — validate level transitions |
| 4.3 | Run Scenario 3 | Deep bounce 40m — validate large BCD changes, OPRV |
| 4.4 | Run Scenario 4 | Shallow 10m, 60 min — validate endurance, low activity |
| 4.5 | Create `run_scenarios.m` | Script that runs all 4 and generates comparison plots |
| 4.6 | Tune controller | Adjust gains if any scenario fails acceptance criteria |
| 4.7 | Document results | Record actual metrics vs targets in test plan |

**Checkpoint 4:** All 4 scenarios pass acceptance criteria; results documented.

---

## 6. Parameter Table

### Plant Parameters (from `scuba_params.m`)

| Parameter | Symbol | Value | Unit | Source | Block Path |
|-----------|--------|-------|------|--------|------------|
| Tank volume | V_tank | 0.012 | m³ | AL80 spec (Catalina catalog) | Plant/GasTank |
| Tank start pressure | P_tank_0 | 200e5 | Pa | Standard fill | Plant/GasTank |
| Tank start moles | n_tank_0 | 98.47 | mol | PV/RT derived | Plant/GasTank |
| Gas molar mass | M_gas | 0.029 | kg/mol | Air (78% N₂ + 21% O₂) | Plant/GasTank |
| 1st stage IP offset | IP_offset | 10e5 | Pa | EN 250 typical (8-11 bar) | Plant/FirstStageReg |
| 1st stage resistance | R_1st | 1e3 | Pa·s/mol | Tuned for realistic flow | Plant/FirstStageReg |
| IP volume | V_ip | 1e-4 | m³ | Hose volume (~100 mL) | Plant/GasVolume |
| 2nd stage cracking | P_crack_2nd | 100 | Pa | EN 250 limit (~1 mbar) | Plant/SecondStageReg |
| 2nd stage resistance | R_2nd | 6000 | Pa·s/mol | Tuned for 15 L/min SAC | Plant/SecondStageReg |
| Lung residual moles | n_lungs_0 | 0.0624 | mol | ~1.5L at surface | Plant/Lungs |
| Exhale cracking | P_crack_exh | 50 | Pa | Low resistance exhale | Plant/ExhaleValve |
| Exhale resistance | R_exh | 9000 | Pa·s/mol | Tuned to balance 2nd stage | Plant/ExhaleValve |
| BCD max volume | V_max | 0.015 | m³ | 15L typical recreational | Plant/BCDBladder |
| BCD wall stiffness | K_wall | 1e7 | Pa/m³ | Stiff bladder material | Plant/BCDBladder |
| BCD inflate R | R_inflate | 5e6 | Pa·s/mol | Slow inflation rate | Plant/BCDInflateValve |
| Purge valve R | R_purge | 1e4 | Pa·s/mol | Fast dump rate | Plant/PurgeValve |
| Purge dump bias | P_dump | 5000 | Pa | ~50cm water column | Plant/PurgeValve |
| OPRV cracking | P_crack_oprv | 20684 | Pa | 3.0 psi gauge | Plant/OPRV |
| OPRV resistance | R_oprv | 5000 | Pa·s/mol | Fast relief | Plant/OPRV |
| Diver mass | m_diver | 80 | kg | Average adult male | Plant/DiverBody |
| Diver body volume | V_body | 0.078 | m³ | ~78L displacement | Plant/DiverBody |
| Drag coefficient | Cd | 1.1 | — | Passmore & Rickers 2002 | Plant/DiverBody |
| Frontal area | A_frontal | 0.12 | m² | Horizontal trim | Plant/DiverBody |
| Water density | ρ_water | 1025 | kg/m³ | Seawater standard | Plant/DiverBody |
| Weight belt | m_weights | 4 | kg | Recreational typical | Plant/Weights |
| Gear mass | m_gear | 5 | kg | Fins, mask, reg, BCD | Plant/Weights |
| Gas constant | R_gas | 8.314 | J/(mol·K) | NIST | Domain |
| Temperature | T | 293.15 | K | 20°C isothermal | Domain |
| Gravity | g | 9.81 | m/s² | Standard | MechProps |

### Harness Controller Parameters (new)

| Parameter | Symbol | Value | Unit | Source | Block Path |
|-----------|--------|-------|------|--------|------------|
| Breathing rate | f_breath | 15 | bpm | Buzzacott 2014 (relaxed) | BreathingGen |
| Breath amplitude | A_breath | 200 | Pa | Held & Pendergast 2013 | BreathingGen |
| Depth effort scaling | K_depth | 1/40 | 1/m | Approx. gas density effect | BreathingGen |
| Breath trim deadzone | bc_deadzone | 0.3 | m | No bias below this error | BreathingGen |
| Breath trim saturation | bc_saturation | 1.5 | m | Bias saturates at ±1 | BreathingGen |
| Breath velocity damping | bc_K_vel | 0.8 | s/m | Velocity damping gain | BreathingGen |
| Duty-cycle shift max | bc_duty_shift | 0.10 | — | Fraction of cycle shifted | BreathingGen |
| Amplitude asymmetry gain | bc_amp_gain | 0.3 | — | ±30% at full bias | BreathingGen |
| BCD deadband | bcd_deadband | 2.0 | m | BCD only fires beyond this | BCDController |
| BCD proportional gain | K_p | 2.0 | 1/m | Tuned (large errors only) | BCDController |
| Max descent rate | v_desc_max | 0.5 | m/s | US Navy (30 m/min limit) | BCDController |
| Max ascent rate | v_asc_max | 0.167 | m/s | US Navy (10 m/min modern) | BCDController |
| Safety stop depth | d_safety | 5 | m | PADI/SSI standard | DiveProfile |
| Safety stop duration | t_safety | 180 | s | 3 minutes minimum | DiveProfile |

---

## 7. Sync Points

After each phase:
1. Model compiles without error
2. Visual inspection of block diagram matches architecture
3. Run sanity simulation (even partial)
4. Compare key signals against physical expectations
5. Update Progress Summary in this document

---

## 8. Definition of Done

### Phase 0 Complete
- [ ] Plant interface verified (3 in, 2 out)
- [ ] `dive_profiles.m` returns valid structs for all 4 scenarios
- [ ] `compute_bcd_init_moles.m` works for depths 5–40m
- [ ] Surface-start parameters added to `scuba_params.m`

### Phase 1 Complete
- [ ] Breathing subsystem generates correct frequency and amplitude
- [ ] Depth scaling active and reasonable
- [ ] Breath-trim bias shifts mean lung volume in response to depth error
- [ ] Plant responds to breathing (gas flows in/out of lungs)
- [ ] Biased breathing alone holds depth within ±0.5m (no BCD)

### Phase 2 Complete
- [ ] Dive profile sequences through all phases correctly
- [ ] BCD controller fires only for large maneuvers (>2m error) or phase transitions
- [ ] During hold: BCD idle >90% of time, breathing trim maintains depth
- [ ] Ascent rate limited to 10 m/min
- [ ] No simultaneous inflate + purge commands

### Phase 3 Complete
- [ ] `full_dive_test.slx` runs Scenario 1 end-to-end
- [ ] All signals logged and plottable
- [ ] No solver failures, NaN, or unphysical values
- [ ] Stop conditions work (depth < 0 terminates)

### Phase 4 Complete
- [ ] All 4 scenarios run to completion
- [ ] SAC rate within ±15% of target for each scenario
- [ ] Depth tracking RMS < 0.3m in all hold phases
- [ ] Tank never goes negative
- [ ] `run_scenarios.m` produces comparison report

---

## 9. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Plant interface mismatch | Phase 0 explicitly verifies ports before any building |
| BCD controller instability | Start with conservative gains; add derivative damping; test hold phase first |
| Solver failure during ascent (Boyle expansion) | Preemptive venting in ascent logic; reduce max step size to 0.05s |
| Gas consumption unrealistic | Validate against SAC formula early (Phase 1 + breathing test) |
| Long sim time (36+ min) | Target ode23t variable-step; accept 2-5 min wall-clock |
| Surface start instability | Begin at 1m (not 0) to avoid hard-stop contact at t=0 |

---

## Appendix A: Solver Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver type | Variable-step | Simscape requires; faster for varying dynamics |
| Solver | ode23t | L-stable implicit, handles stiff DAE; required by Simscape custom domain |
| Max step size | 0.1 s | Fast enough for breathing (0.25 Hz) and BCD dynamics |
| Relative tolerance | 1e-4 | Balance accuracy vs speed; tighten to 1e-5 if needed |
| Stop time | Scenario-dependent | 2700s (45min), 2400s (40min), 1200s (20min), 3600s (60min) |
| Simscape logging | All | For truth outputs and debugging |

---

## Appendix B: Dive Profile Specifications

### Scenario 1: Square 18m (45 min)

| Phase | Start Depth | End Depth | Rate | Duration |
|-------|-------------|-----------|------|----------|
| Descent | 1 m | 18 m | 0.5 m/s | 34 s |
| Bottom | 18 m | 18 m | — | 40 min |
| Ascent | 18 m | 5 m | 0.15 m/s | 87 s |
| Safety stop | 5 m | 5 m | — | 3 min |
| Final ascent | 5 m | 1 m | 0.05 m/s | 80 s |

**Expected gas consumption:** SAC=15 L/min × (18/10+1) = 42 L/min actual × 40 min ≈ 1680 L ≈ 74% of AL80

### Scenario 2: Multi-Level (30→20→10)

| Phase | Start Depth | End Depth | Rate | Duration |
|-------|-------------|-----------|------|----------|
| Descent | 1 m | 30 m | 0.5 m/s | 58 s |
| Level 1 | 30 m | 30 m | — | 10 min |
| Transit | 30 m | 20 m | 0.15 m/s | 67 s |
| Level 2 | 20 m | 20 m | — | 15 min |
| Transit | 20 m | 10 m | 0.15 m/s | 67 s |
| Level 3 | 10 m | 10 m | — | 15 min |
| Ascent | 10 m | 5 m | 0.15 m/s | 33 s |
| Safety stop | 5 m | 5 m | — | 3 min |
| Final ascent | 5 m | 1 m | 0.05 m/s | 80 s |

**Expected gas consumption:** Weighted average ~35 L/min × 40 min ≈ 1400 L ≈ 62% of AL80

### Scenario 3: Deep Bounce (40m, 5 min)

| Phase | Start Depth | End Depth | Rate | Duration |
|-------|-------------|-----------|------|----------|
| Descent | 1 m | 40 m | 0.5 m/s | 78 s |
| Bottom | 40 m | 40 m | — | 5 min |
| Deep stop | 40 m → 20 m | 20 m | 0.15 m/s | 133 s |
| Hold | 20 m | 20 m | — | 2 min |
| Ascent | 20 m | 5 m | 0.15 m/s | 100 s |
| Safety stop | 5 m | 5 m | — | 3 min |
| Final ascent | 5 m | 1 m | 0.05 m/s | 80 s |

**Expected gas consumption:** SAC=15 × 5 ATA × 5 min + shallower phases ≈ 600 L ≈ 26% of AL80

### Scenario 4: Shallow 10m (60 min)

| Phase | Start Depth | End Depth | Rate | Duration |
|-------|-------------|-----------|------|----------|
| Descent | 1 m | 10 m | 0.3 m/s | 30 s |
| Bottom | 10 m | 10 m | — | 55 min |
| Ascent | 10 m | 5 m | 0.15 m/s | 33 s |
| Safety stop | 5 m | 5 m | — | 3 min |
| Final ascent | 5 m | 1 m | 0.05 m/s | 80 s |

**Expected gas consumption:** SAC=12 × 2 ATA × 55 min ≈ 1320 L ≈ 58% of AL80 (low SAC for relaxed diver)
