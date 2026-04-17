# Disk Brake Thermal Model — Implementation & Test Plan

## Status: Not Started
**Last Updated:** 2026-04-14  
**Architecture Spec:** [disk-brake-thermal-system-architecture.md](disk-brake-thermal-system-architecture.md)

---

## 1. Progress Summary

| Phase | Status | Subsystems |
|-------|--------|------------|
| Phase 0: Interface Contract & Stubs | 🔲 Not Started | All |
| Phase 1: Subsystem Implementation | 🔲 Not Started | Vehicle, BrakeHydraulics, SimpleDrive, Heat Partition, Rotor Node, Pad Node, Backing Node, Convection |
| Phase 2: Integration & Open-Loop Validation | 🔲 Not Started | Complete plant |
| Phase 3: Scenario Validation | 🔲 Not Started | All test scenarios |

---

## 2. Model Hierarchy

```
DiskBrakeThermal.slx (root)
├── BrakeHydraulics        # brake_cmd → tau_brake, F_brake_at_wheel, P_brake_front
├── SimpleDrive            # accel_cmd → F_drive
├── VehicleLongitudinal    # Point-mass: F_drive, F_brake_at_wheel, grade → v
├── HeatPartition          # Splits P_brake between rotor and pad
├── RotorThermalNode       # Energy balance ODE for rotor
├── PadThermalNode         # Energy balance ODE for pad
├── BackingPlateNode       # Energy balance ODE for backing plate
└── ConvectionCalculator   # Speed-dependent h_conv
```

---

## 3. Dependencies

| Toolbox | Required For | Required? |
|---------|-------------|-----------|
| Simulink | All | Yes |
| MATLAB | Parameter script, post-processing | Yes |
| Simscape | — | No (signal-flow approach chosen) |

---

## 4. Build Phases

### Phase 0: Interface Contract & Stubs
**Goal:** Create compilable root model with stub subsystems and parameter initialization script.

| Step | Operation | Details |
|------|-----------|---------|
| 0.1 | Create parameter script | `disk_brake_thermal_params.m` with all parameters from architecture spec §A7 (vehicle + thermal) |
| 0.2 | Create root model | `DiskBrakeThermal.slx` with 4 inports (brake_cmd, accel_cmd, theta_grade, T_amb) and 3 outports (T_rotor, T_pad, v_vehicle) |
| 0.3 | Create stub subsystems | 8 subsystems with correct port interfaces (passthrough or constant output) |
| 0.4 | Wire stubs | Connect signal flow per architecture §A2 (vehicle → thermal) |
| 0.5 | Add debug outputs | Signal logging for v_vehicle, tau_brake, F_brake_at_wheel, P_brake, Q_rotor, Q_conv, Q_rad, T_backing |
| 0.6 | Configure solver | Variable-step, ode45, RelTol=1e-6, MaxStep=0.1, StopTime=300 |

**Verification:**
- Model compiles and runs with stubs
- `model_overview` shows correct hierarchy
- `model_read` shows correct ports on each subsystem

**Checkpoint 0:** Root model runs 300 s with zero inputs, all temperatures stay at initial value.

---

### Phase 1: Subsystem Implementation
**Goal:** Implement physics in each subsystem.

All subsystems are loosely coupled — they can be built in parallel.

#### 1.1 BrakeHydraulics
- Inputs: brake_cmd (0–1), v_vehicle (m/s) [feedback from VehicleLongitudinal]
- Outputs: tau_brake (N·m), F_brake_at_wheel (N), P_brake_front (W)
- Implementation:
  - P_line = brake_cmd × P_line_max
  - F_clamp = P_line × A_piston
  - F_friction = 2 × μ_pad × F_clamp
  - tau_brake = F_friction × R_eff
  - F_brake_at_wheel = 4 × tau_brake / R_wheel
  - P_brake_front = tau_brake × v_vehicle / R_wheel
- Blocks: Gain, Product

#### 1.2 SimpleDrive
- Input: accel_cmd (0–1)
- Output: F_drive (N)
- Implementation: F_drive = accel_cmd × F_drive_max
- Blocks: Gain

#### 1.3 VehicleLongitudinal
- Inputs: F_brake_at_wheel (N) [from BrakeHydraulics], F_drive (N) [from SimpleDrive], theta_grade (rad)
- Outputs: v_vehicle (m/s)
- State: v_vehicle (Integrator, IC = v0, lower limit = 0)
- Implementation:
  - F_drag = 0.5 × ρ_air_drag × Cd_A × v²
  - F_roll = Cr × m_veh × g × cos(θ)
  - F_grade = m_veh × g × sin(θ)
  - dv/dt = (F_drive - F_brake_at_wheel - F_drag - F_roll - F_grade) / m_veh
- Blocks: Integrator (lower limit 0), Product, Gain, Trigonometric Function, Sum, Constant

#### 1.4 ConvectionCalculator
- Input: v_vehicle (m/s)
- Output: h_conv (W/m²K)
- Implementation:
  - Re = ρ_air × v × D / μ_air
  - h_forced = 0.70 × (k_air/D) × Re^0.55
  - h_conv = max(h_forced, h_nat)
- Blocks: Product, Gain, Math Function (power), Max, Constant

#### 1.5 HeatPartition
- Inputs: P_brake
- Outputs: Q_rotor, Q_pad
- Implementation:
  - Q_rotor = γ × P_brake
  - Q_pad = (1-γ) × P_brake
- Blocks: Gain ×2

#### 1.6 RotorThermalNode
- Inputs: Q_rotor_in, T_pad, h_conv, T_amb
- Output: T_rotor
- State: T_rotor (Integrator, IC = T_amb)
- Implementation:
  - Q_conv = h_conv × A_rotor × (T_rotor - T_amb)
  - Q_rad = ε_r × σ × A_rotor × ((T_rotor+273)⁴ - (T_amb+273)⁴)
  - Q_cond_rp = (k_p × A_contact / t_pad) × (T_rotor - T_pad)
  - dT/dt = (Q_rotor_in - Q_conv - Q_rad - Q_cond_rp) / (m_r × c_r)
- Blocks: Integrator, Sum, Product, Gain, Add (273), Math Function (u^4), Subtract

#### 1.7 PadThermalNode
- Inputs: Q_pad_in, T_rotor, T_backing, T_amb
- Output: T_pad
- State: T_pad (Integrator, IC = T_amb)
- Implementation:
  - Q_cond_from_rotor = (k_p × A_contact / t_pad) × (T_rotor - T_pad)
  - Q_cond_to_backing = (k_b × A_backing / t_b) × (T_pad - T_backing)
  - Q_conv_pad = h_pad × A_pad_exposed × (T_pad - T_amb)
  - dT/dt = (Q_pad_in + Q_cond_from_rotor - Q_cond_to_backing - Q_conv_pad) / (m_p × c_p)

#### 1.8 BackingPlateNode
- Inputs: T_pad, T_amb
- Output: T_backing
- State: T_backing (Integrator, IC = T_amb)
- Implementation:
  - Q_cond_from_pad = (k_b × A_backing / t_b) × (T_pad - T_backing)
  - Q_conv_back = h_nat × A_backing × (T_backing - T_amb)
  - dT/dt = (Q_cond_from_pad - Q_conv_back) / (m_b × c_b)

**Checkpoint 1:** Each subsystem responds correctly to step inputs with physically reasonable output.

---

### Phase 2: Integration & Open-Loop Validation
**Goal:** Wire real subsystems together, verify signal flow, run basic sanity check.

| Step | Operation |
|------|-----------|
| 2.1 | Replace stubs with implemented subsystems |
| 2.2 | Wire all connections per architecture diagram |
| 2.3 | Run single emergency stop scenario (Scenario 1) as smoke test |
| 2.4 | Verify energy conservation: ∫P_brake dt ≈ ∫(Q_conv + Q_rad) dt + ΔE_stored |

**Checkpoint 2:** Rotor temperature rise for 100→0 km/h emergency stop is 80–130°C. Energy balance closes within 5%.

---

### Phase 3: Scenario Validation
**Goal:** Run all 4 operating scenarios from system spec and verify against acceptance criteria.

Run Gherkin-based tests per test plan below.

**Checkpoint 3:** All scenarios pass acceptance criteria.

---

## 5. Test Plan

### 5.1 Overview

**Validation Stages:**
1. **Subsystem open-loop** — Step response of individual thermal nodes
2. **Integrated open-loop** — Complete plant with known brake power inputs
3. **Scenario validation** — Full driving maneuvers

### 5.2 Subsystem Open-Loop Validation

#### 5.2.1 BrakeHydraulics

| Test | Input | Expected Output | Acceptance | Basis |
|------|-------|-----------------|------------|-------|
| Full pedal | brake_cmd=1.0, v=27.8 m/s | P_line=120 bar, tau_brake = 2×0.40×120e5×0.002×0.11 = 211 N·m, F_brake_at_wheel = 4×211/0.32 = 2638 N, P_brake_front = 211×27.8/0.32 = 18334 W | Within 5% of manual calculation | Definition |
| Zero pedal | brake_cmd=0 | All outputs = 0 | Exact | No braking |
| Half pedal | brake_cmd=0.5, v=27.8 m/s | All outputs = 50% of full pedal values | Within 1% | Linear system |

#### 5.2.2 SimpleDrive

| Test | Input | Expected Output | Acceptance | Basis |
|------|-------|-----------------|------------|-------|
| Full throttle | accel_cmd=1.0 | F_drive = F_drive_max | Exact | Definition |
| Zero throttle | accel_cmd=0 | F_drive = 0 | Exact | No drive force |
| Half throttle | accel_cmd=0.5 | F_drive = 0.5 × F_drive_max | Exact | Linear system |

#### 5.2.3 Vehicle Longitudinal

| Test | Input | Expected Output | Acceptance | Basis |
|------|-------|-----------------|------------|-------|
| Constant brake, flat road | brake_cmd=1.0 (full pedal), accel_cmd=0, v0=27.8 m/s, θ=0 | Vehicle stops in ~2.8 s; v reaches 0 and stays at 0 | Stop time within 10% | Newton's 2nd law |
| Constant speed downhill | brake_cmd adjusted to hold speed on 7% grade, accel_cmd=0, v0=22.2 m/s | Speed stays approximately constant (~22.2 m/s) | Speed drift < 1 m/s over 100 s | Force equilibrium |
| Coasting (no brake), flat | brake_cmd=0, accel_cmd=0, v0=27.8 m/s, θ=0 | Slow deceleration from drag + rolling resistance | Speed decreases; deceleration < 0.5 m/s² | Drag + rolling only |
| Grade descent, no brake | brake_cmd=0, accel_cmd=0, v0=22.2 m/s, θ=-0.07 rad | Speed increases due to gravity component | Speed increases monotonically | Gravity > drag + rolling at moderate speed |

#### 5.2.4 Convection Calculator

| Test | Input | Expected Output | Acceptance | Basis |
|------|-------|-----------------|------------|-------|
| Zero speed | v=0 | h = h_nat = 8 W/m²K | Exact | Natural convection floor |
| Highway speed | v=30 m/s (108 km/h) | h ≈ 50–100 W/m²K | Within range | Limpert correlation |
| High speed | v=55 m/s (200 km/h) | h ≈ 100–180 W/m²K | Within range | Limpert correlation |

#### 5.2.5 Rotor Thermal Node (isolated)

| Test | Input | Expected | Acceptance | Basis |
|------|-------|----------|------------|-------|
| Adiabatic heating | Q_in = 50 kW constant, no cooling (h=0, ε=0) for 3 s | ΔT = Q×t/(m×c) = 150000/(6×449) = 55.7°C | Within 1% | Energy conservation |
| Cooling from 300°C | Q_in = 0, h = 80, T_amb = 25°C | Exponential decay, τ = m×c/(h×A) = 6×449/(80×0.12) = 280 s | τ within 10% | Lumped analysis |

#### 5.2.6 Heat Partition

| Test | Input | Expected | Acceptance | Basis |
|------|-------|----------|------------|-------|
| Nominal partition | P_brake = 100 kW | Q_rotor = 95 kW, Q_pad = 5 kW | Exact (γ=0.95) | Definition |

### 5.3 Integrated Open-Loop Validation

#### 5.3.1 Single Emergency Stop (Scenario 1)

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| brake_cmd | Step | 1.0 (full pedal) at t=0, released to 0 when v=0 | 63 s total |
| accel_cmd | Constant | 0 | 63 s |
| theta_grade | Constant | 0 rad (flat road) | 63 s |
| T_amb | Constant | 25°C | 63 s |
| v0 | Initial condition | 27.8 m/s (100 km/h) | — |

**Note:** BrakeHydraulics converts brake_cmd=1.0 to F_brake_at_wheel ≈ 2638 N. The vehicle stops in ~2.8 s.

**Expected Outputs:**

| Signal | Expected | Acceptance | Basis |
|--------|----------|------------|-------|
| v_vehicle | Reaches 0 in ~2.8 s, stays at 0 | Stop time within 10% | Newton's 2nd law |
| T_rotor peak | 105–150°C | Within this range | Analytic: ΔT_adiabatic = E/(m×c) = ½×1700×27.8²×0.7/2 / (6×449) ≈ 97°C; with cooling slightly less |
| T_pad peak | 30–60°C | Physically reasonable (much less than rotor) | 5% heat partition, lower mass but lower conductivity |
| T_rotor at t=63s | Decreasing from peak | Below peak temperature | Cooling has begun |

#### 5.3.2 Repeated Braking — Fade Test (Scenario 2)

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| brake_cmd | Periodic pulse | 15 pulses of ~0.4 (moderate braking for 0.4g) applied when v > 1 m/s, released when v ≈ 0 | ~480 s total |
| accel_cmd | Periodic pulse | Pulses to accelerate back to 27.8 m/s between braking events | ~480 s total |
| theta_grade | Constant | 0 rad (flat road) | 480 s |
| T_amb | Constant | 25°C | 480 s |
| v0 | Initial condition | 27.8 m/s | — |

**Note:** Between braking events, accel_cmd drives the vehicle back to 100 km/h via SimpleDrive. The vehicle subsystem handles the speed integration naturally.

**Expected Outputs:**

| Signal | Expected | Acceptance | Basis |
|--------|----------|------------|-------|
| v_vehicle | 15 complete stop-and-go cycles | Vehicle reaches 0 and returns to 27.8 m/s each cycle | Vehicle model correctness |
| T_rotor after stop 15 | 350–550°C | Within this range | Literature: fade tests typically reach 400–500°C |
| T_rotor trend | Monotonically increasing peak temperatures | Each peak > previous | Insufficient cooling between stops |
| T_rotor rate of rise | Decreasing (approaching equilibrium) | Incremental ΔT per stop decreases | Convection increases with temperature |

#### 5.3.3 Sustained Downhill Braking (Scenario 3)

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| brake_cmd | Constant | Adjusted to hold constant speed on 7% grade (~0.44) | 144 s descent, then 0 for 120 s cooling |
| accel_cmd | Constant | 0 | 264 s |
| theta_grade | Step profile | -0.070 rad (7% downhill) for 144 s, then 0 rad (flat) for 120 s | 264 s |
| T_amb | Constant | 25°C | 264 s |
| v0 | Initial condition | 22.2 m/s (80 km/h) | — |

**Note:** BrakeHydraulics converts brake_cmd to the brake force needed to balance the grade force. During cooling, brake_cmd = 0 and grade = 0; vehicle coasts and slows from drag/rolling.

**Expected Outputs:**

| Signal | Expected | Acceptance | Basis |
|--------|----------|------------|-------|
| v_vehicle during descent | Approximately constant at 22.2 m/s | ±2 m/s | Force equilibrium |
| T_rotor at end of descent | 250–450°C | Within this range | Limpert downhill brake analysis |
| T_rotor trend during descent | Rising, approaching steady-state | Temperature curve is concave-down | Convective equilibrium |

#### 5.3.4 City Driving (Scenario 4)

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| brake_cmd | Periodic pulse | 10 pulses of ~0.3 (0.3g braking) applied when v > 1 m/s | ~350 s |
| accel_cmd | Periodic pulse | Pulses to accelerate back to 13.9 m/s (50 km/h) between stops | ~350 s |
| theta_grade | Constant | 0 rad (flat road) | 350 s |
| T_amb | Constant | 25°C | 350 s |
| v0 | Initial condition | 13.9 m/s (50 km/h) | — |

**Expected Outputs:**

| Signal | Expected | Acceptance | Basis |
|--------|----------|------------|-------|
| v_vehicle | 10 stop-and-go cycles, 0→13.9 m/s | Correct speed profile | Vehicle model |
| T_rotor peak | < 200°C | Must not exceed 200°C | Moderate braking, adequate cooling |
| T_rotor at end | Near ambient (< 80°C) | Must cool toward ambient | 30 s intervals allow significant cooling |

---

### 5.4 Gherkin Scenario Templates

#### 5.4.1 Emergency Stop

```gherkin
Feature: Disk Brake Thermal - Emergency Stop

  Scenario: Single panic stop from 100 km/h
    Given the model "DiskBrakeThermal.slx" is loaded
    And the solver is "ode45" with relative tolerance 1e-6
    And parameter "v0" is set to 27.8
    And the simulation stop time is 63

    When the simulation runs with:
      | Signal      | Type     | Parameters                                 |
      | brake_cmd   | Step     | 1.0 at t=0, 0 after vehicle stops          |
      | accel_cmd   | Constant | 0                                          |
      | theta_grade | Constant | 0 rad                                      |
      | T_amb       | Constant | 25 °C                                      |

    Then "v_vehicle" shall reach 0 within 3.5 s
    And the peak value of "T_rotor" shall be between 105 and 150 °C
    And at t=63s, "T_rotor" shall be less than the peak value
    And at t=63s, "T_pad" shall be less than 80 °C
```

#### 5.4.2 Fade Test

```gherkin
Feature: Disk Brake Thermal - Fade Test

  Scenario: 15 repeated stops from 100 km/h
    Given the model "DiskBrakeThermal.slx" is loaded
    And parameter "v0" is set to 27.8
    And the simulation stop time is 480

    When 15 braking events are applied:
      | brake_cmd: ~0.4 until v ≈ 0, then 0 during acceleration phase                |
      | accel_cmd: 0 during braking, then pulse to accelerate back to 27.8 m/s        |
      | theta_grade: 0 rad throughout                                                 |
      | Cycle time: ~32 s per stop-accelerate cycle                                   |

    Then the final "T_rotor" shall be between 350 and 550 °C
    And each successive "T_rotor" peak shall be greater than the previous
    And "v_vehicle" shall complete 15 stop-and-go cycles
```

#### 5.4.3 Sustained Downhill

```gherkin
Feature: Disk Brake Thermal - Downhill Braking

  Scenario: Constant speed descent on 7% grade
    Given the model "DiskBrakeThermal.slx" is loaded
    And parameter "v0" is set to 22.2
    And the simulation stop time is 264

    When the simulation runs with:
      | Signal      | Type         | Parameters                                         |
      | brake_cmd   | Step profile | ~0.44 for 0–144 s, then 0 for 144–264 s            |
      | accel_cmd   | Constant     | 0                                                  |
      | theta_grade | Step profile | -0.070 rad for 0–144 s, then 0 rad for 144–264 s   |
      | T_amb       | Constant     | 25 °C                                               |

    Then "v_vehicle" shall remain between 20 and 25 m/s during 0–144 s
    And at t=144s, "T_rotor" shall be between 250 and 450 °C
    And at t=264s, "T_rotor" shall be less than the value at t=144s
```

---

### 5.5 Parameter Sensitivity Tests

| Parameter | Nominal | Range | Test Scenario | Acceptance Criterion |
|-----------|---------|-------|---------------|---------------------|
| m_r | 6.0 kg | 4.5 – 8.0 kg | Emergency stop | Peak T_rotor varies inversely with mass; stays within 70–200°C |
| ε_r | 0.40 | 0.28 – 0.55 | Fade test | Final T_rotor varies by < 15% across range |
| h_nat | 8 W/m²K | 5 – 15 | Fade test | Model remains stable; final T_rotor varies < 20% |
| γ | 0.95 | 0.90 – 0.98 | Emergency stop | T_pad increases when γ decreases; T_rotor decreases |

### 5.6 Numerical Robustness Tests

| Test | Variation | Acceptance |
|------|-----------|------------|
| Solver tolerance | RelTol 1e-4 and 1e-8 vs nominal 1e-6 | T_rotor within 1% of baseline |
| MaxStep | 0.01 s and 1.0 s vs nominal 0.1 s | T_rotor within 2% of baseline |
| Different solver | ode23t instead of ode45 | T_rotor within 1% of baseline |

---

### 5.7 Energy Conservation Check

For every integrated test, verify:

```
E_brake = ∫ P_brake dt                          (total braking energy input)
E_stored = Σ (m_i × c_i × (T_i_final - T_i_initial))  (energy stored in thermal masses)
E_dissipated = ∫ (Q_conv + Q_rad) dt              (energy dissipated to environment)

Check: |E_brake - E_stored - E_dissipated| / E_brake < 0.01  (1% tolerance)
```

---

## 6. Simulation Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver | ode45 (variable-step) | Non-stiff thermal ODEs |
| RelTol | 1e-6 | Adequate for thermal dynamics |
| MaxStep | 0.1 s | Thermal time constants > 1 s |
| Stop time | Scenario-dependent (63–480 s) | Per test scenario |
| Initial conditions | T_amb = 25°C for all nodes | Cold start |
| Signal logging | T_rotor, T_pad, T_backing, tau_brake, F_brake_at_wheel, Q_conv, Q_rad | For post-processing and energy balance |

---

## 7. Definition of Done

### Phase 0 Complete
- [ ] Parameter script exists and runs without errors
- [ ] Root model compiles with stub subsystems
- [ ] Port interfaces match architecture spec

### Phase 1 Complete
- [ ] All 8 subsystems implemented with correct equations (BrakeHydraulics, SimpleDrive, Vehicle + 5 thermal)
- [ ] Subsystem open-loop tests pass (§5.2), including vehicle dynamics tests

### Phase 2 Complete
- [ ] All subsystems wired together
- [ ] Emergency stop smoke test passes
- [ ] Energy balance closes within 1%

### Phase 3 Complete
- [ ] All 4 scenarios pass acceptance criteria (§5.3)
- [ ] Parameter sensitivity tests pass (§5.5)
- [ ] Numerical robustness tests pass (§5.6)
- [ ] Energy conservation verified for all tests (§5.7)

---

## 8. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Convection coefficient uncertainty (±50%) | Sensitivity sweep in §5.5; document impact on predictions |
| Radiation at high T makes system mildly stiff | Monitor solver step rejections; switch to ode23t if needed |
| No physical test data for validation | Use analytic predictions and COMSOL reference; clearly state in documentation that model is validated against theory, not experiment |

---

## Appendix A: Related Documents

- [System & Architecture Spec](disk-brake-thermal-system-architecture.md)
