# Scuba Diver Plant Model — System Spec

## Status: Draft
**Last Updated:** 2026-06-14  
**Author:** Guy Rouleau  
**Reviewers:** —

---

## 1. Executive Summary

The Scuba Diver plant model (`models/Scuba_Diver.slx`) shall be a 1-DOF vertical buoyancy simulation of a recreational scuba diver. It will model breath-by-breath gas consumption through realistic equipment topology (tank → regulators → lungs/BCD → water) using a custom Simscape gas domain with molar flow conservation. The plant closes the loop with external depth/buoyancy controllers that command BCD inflation/purge and drive the breathing effort signal.

Two test harnesses are planned:
1. **`descent_test.slx`** — Simple drop-and-hold with a Stateflow chart for initial validation
2. **`full_dive_test.slx`** — Full-dive-profile harness to validate the plant across realistic recreational and technical diving scenarios including descent, bottom time, staged ascent, safety stops, and gas management

---

## 2. Problem Statement

### Current Situation

No plant model or test harness exists yet. The project needs:
1. A reusable plant model (`Scuba_Diver.slx`) with clean input/output interface
2. A simple initial harness (`descent_test.slx`) for basic descent/hold validation
3. A full-dive harness (`full_dive_test.slx`) with realistic breathing, complete dive profiles, and gas consumption tracking

### Opportunity

Building the plant model and harnesses enables:
- Validation of gas consumption against known SAC rates (12–25 L/min surface equivalent)
- Demonstration of buoyancy stability through depth changes (Boyle expansion/compression)
- Testing of BCD control strategies across full dive envelopes
- Multi-scenario regression (square profile, multi-level, deep bounce, cold water)

---

## 3. Goals & Success Metrics

### Goals

| Goal | Description |
|------|-------------|
| **G1: Realistic gas consumption** | Tank pressure drop over a 30-min dive at 20m matches theoretical SAC × depth factor within 10% |
| **G2: Stable depth control** | Depth oscillation < ±0.5m during bottom time at any depth 5–40m |
| **G3: Safe ascent rate** | Ascent rate never exceeds 10 m/min (0.167 m/s) during controlled ascent |
| **G4: Full-dive completion** | Simulation runs a complete 30+ minute dive without solver failure or unphysical states |
| **G5: Multi-scenario** | At least 3 distinct dive profiles execute successfully with same plant model |

### Success Metrics

- **Gas consumption accuracy**: Simulated SAC within ±15% of target (15 L/min for relaxed diver)
- **Depth tracking RMS error**: < 0.3m during steady-state bottom time
- **BCD volume range**: Stays within [0, 15L] at all times; no clamp violations
- **Tank never goes negative**: n_tank > 0 at end of simulation

---

## 4. Non-Goals (v1)

| Non-Goal | Rationale |
|----------|-----------|
| **Decompression modeling** | No tissue compartment or bubble model — purely mechanical/gas simulation |
| **Thermal effects** | Isothermal assumption; water temperature does not affect gas dynamics |
| **Wetsuit compression** | Deferred to v2 |
| **Multi-gas switching** | Single tank, single gas mix for v1 |
| **Horizontal motion** | 1-DOF vertical only |
| **Buddy/team dynamics** | Single diver |
| **Equipment failure modes** | No free-flow, no flooded mask, no regulator freeze |

---

## 5. Operating Scenarios

### Scenario 1: Recreational Square Profile (18m, 45 min)

**Operating Conditions:** Saltwater (1025 kg/m³), 20°C, air, AL80 tank (200 bar), 5mm wetsuit, 4 kg weights

**Maneuver/Excitation:**
1. Start at surface (1m depth), near-empty BCD, diver slightly negatively buoyant
2. Controlled descent to 18m at 0.5 m/s (~34s) — BCD partially inflated for neutral buoyancy
3. Hold at 18m for 40 minutes — breathing at 15 bpm, SAC ~15 L/min
4. Ascent to 5m at 9 m/min (0.15 m/s) — BCD venting to maintain rate
5. Safety stop at 5m for 3 minutes
6. Final ascent to surface at 3 m/min (0.05 m/s)

**Controller Behavior:** BCD inflated during descent to establish neutral buoyancy at target depth; during bottom time, breathing trim handles fine depth-keeping (BCD idle); continuous BCD venting during ascent to counteract Boyle expansion.

### Scenario 2: Multi-Level Profile (30m → 20m → 10m)

**Operating Conditions:** Same as Scenario 1

**Maneuver/Excitation:**
1. Descent to 30m at 0.5 m/s
2. Hold at 30m for 10 minutes
3. Ascent to 20m at 9 m/min, hold for 15 minutes
4. Ascent to 10m at 9 m/min, hold for 15 minutes
5. Ascent to 5m, 3-min safety stop
6. Surface at 3 m/min

**Controller Behavior:** BCD adjusted at each level change to re-establish neutral buoyancy at new ambient pressure. Between adjustments, breathing trim maintains depth. Gas consumption is higher at 30m (4 ATA) than at 10m (2 ATA).

### Scenario 3: Deep Bounce (40m, 5 min bottom)

**Operating Conditions:** Saltwater, 20°C, air, steel 12L tank (200 bar), 7mm wetsuit, 6 kg weights

**Maneuver/Excitation:**
1. Descent to 40m at 0.5 m/s (rapid, ~78s)
2. Hold at 40m for 5 minutes only (no-deco limit)
3. Ascent to 20m at 9 m/min — critical BCD management (large Boyle expansion)
4. Hold at 20m for 2 minutes (deep stop)
5. Ascent to 5m at 9 m/min, 3-min safety stop
6. Surface

**Controller Behavior:** Large BCD volume changes between 40m and surface. BCD actively managed during ascent (vent Boyle expansion); breathing trim during short bottom hold. Tests OPRV behavior if venting is too slow. High gas consumption at depth.

### Scenario 4: Relaxed Shallow Dive (10m, 60 min)

**Operating Conditions:** Tropical saltwater (1025 kg/m³), 27°C, air, AL80, 3mm wetsuit, 3 kg weights

**Maneuver/Excitation:**
1. Gentle descent to 10m at 0.3 m/s
2. Hold at 10m for 55 minutes — low SAC (12 L/min), low breathing rate (12 bpm)
3. Direct ascent to 5m at 9 m/min, 3-min safety stop
4. Surface

**Controller Behavior:** BCD set once at 10m for neutral buoyancy, then idle for entire bottom time. Breathing trim alone maintains depth for 55 minutes. Tests long-duration stability of breath-only control and gas endurance.

---

## 6. Physical Model Requirements

### 6.1 States & Governing Equations

| State | Physical Meaning | Equation Type |
|-------|-----------------|---------------|
| n_tank | Moles of gas in tank | ODE (mass conservation) |
| n_ip | Moles in intermediate pressure volume | ODE (mass conservation) |
| n_lungs | Moles of gas in lungs | ODE (mass conservation) |
| n_bcd | Moles of gas in BCD bladder | ODE (mass conservation, clamped) |
| x | Vertical position (depth) | ODE (Newton's 2nd law) |
| v | Vertical velocity | ODE (force balance) |

### 6.2 Key Assumptions

| Assumption | Justification |
|------------|---------------|
| Isothermal gas (T = 293.15 K) | Water temperature constant; gas exchanges are slow enough for thermal equilibrium (Loske 2013) |
| Ideal gas (PV = nRT) | Pressures < 200 bar; compressibility factor Z ≈ 1.0 at diving pressures (Wienke 2016) |
| 1-DOF vertical motion | Horizontal forces negligible for buoyancy analysis; β = 90° (vertical axis) |
| Rigid body (no flex) | Diver modeled as lumped mass; structural dynamics irrelevant at <1 Hz dynamics |
| No dissolved gas | Gas remains in gas phase; no Henry's law absorption into blood/tissue |
| Demand-driven 2nd stage | Flow only when diver inhales (P_lung < P_amb); no free-flow mode |

### 6.3 Fidelity Level

**Chosen fidelity:** Medium

**Justification:** Sufficient for validating depth control strategies and gas consumption predictions. Component-level physics (regulator demand, BCD Boyle expansion, drag) are modeled with first-principles equations. Validation against SAC rate data and known buoyancy physics (Valenko 2016, Korosec 2003). Higher fidelity (thermal, dissolved gas, wetsuit compression) deferred because validation data for those effects is not available in this project.

### 6.4 Coordinate Frame & Sign Conventions

| Convention | Definition |
|------------|------------|
| Positive x direction | Downward (increasing depth) |
| Positive velocity | Downward (descending) |
| Positive force | Downward (gravity direction) |
| Buoyancy force sign | Negative (upward, opposing gravity) |
| Breath effort sign | Negative = inhale (creates suction), Positive = exhale (creates pressure) |
| BCD inflate command | 1 = open inflate valve, 0 = closed |
| BCD purge command | 1 = open dump valve, 0 = closed |

---

## 7. Controller Interface Contract

### 7.1 Plant Inputs (from Controller)

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| Inflate BCD | u₁ | — | double [0,1] | Continuous | Opens inflate valve (0=closed, 1=fully open) |
| Purge BCD | u₂ | — | double [0,1] | Continuous | Opens dump valve (0=closed, 1=fully open) |
| Breath Effort | u₃ | Pa | double | Continuous | Muscular pressure applied to lungs (−200 to +200 Pa typical) |

### 7.2 Plant Outputs (to Controller)

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| Depth | y₁ | m | double | Continuous | Vertical position below surface (positive down) |
| Velocity | y₂ | m/s | double | Continuous | Vertical velocity (positive = descending) |

### 7.3 Exogenous Inputs (Disturbances)

| Signal | Symbol | Unit | Source | Description |
|--------|--------|------|--------|-------------|
| Water density | w₁ | kg/m³ | Parameter | Constant per scenario (salt=1025, fresh=1000) |
| Water temperature | w₂ | K | Parameter | Constant (affects gas domain T) |
| Initial depth | w₃ | m | Parameter | Starting position |
| Tank start pressure | w₄ | Pa | Parameter | Initial gas charge |

### 7.4 Truth Outputs (Debug/Validation Only)

| Signal | Symbol | Unit | Description |
|--------|--------|------|-------------|
| Tank pressure | z₁ | Pa | Current tank pressure (for gas consumption tracking) |
| Tank moles | z₂ | mol | Remaining gas in tank |
| BCD volume | z₃ | m³ | Current BCD gas volume |
| Lung volume | z₄ | m³ | Current lung gas volume |
| Net buoyancy force | z₅ | N | Sum of all buoyancy forces minus weight |

---

## 8. Initialization & Operating Points

### 8.1 Nominal Operating Point

| State | Initial Value | Unit | How Determined |
|-------|--------------|------|----------------|
| n_tank | 98.47 | mol | P₀V/RT = 200e5 × 0.012 / (8.314 × 293.15) |
| n_ip | 0.445 | mol | (P_atm + 10e5) × 1e-4 / (R×T) |
| n_lungs | 0.0624 | mol | Residual volume at surface |
| n_bcd | 0.298 | mol | Tuned for neutral buoyancy at ic.depth (20m) |
| x | 20 | m | params.ic.depth |
| v | 0 | m/s | At rest |

### 8.2 Operating Range

| Parameter | Min | Nominal | Max | Unit |
|-----------|-----|---------|-----|------|
| Depth | 0 (surface) | 20 | 45 | m |
| Tank pressure | 50e5 (reserve) | 200e5 | 200e5 | Pa |
| BCD volume | 0 | 2.4e-3 | 0.015 | m³ |
| Velocity | -0.5 (ascending) | 0 | 0.5 (descending) | m/s |

### 8.3 Initialization Strategy

Initial conditions shall be set via workspace parameters loaded by `initWorkspace.m`:
- `params.ic.depth` sets Initial Length (PB) block
- `params.bcd.initMoles` computed for neutral buoyancy at `ic.depth`
- Tank moles from `params.tank.startMoles`
- Each Simscape component shall use `{value = param, priority = priority.high}` for state initialization

Two initialization modes:
- **Mid-water start** (descent_test): Begin at depth with BCD filled for neutral buoyancy
- **Surface start** (full_dive_test): Begin at 1m with BCD nearly empty, diver slightly negatively buoyant

---

## 9. Rate & Timing Alignment

| Component | Rate | Type | Notes |
|-----------|------|------|-------|
| Plant dynamics | Continuous | DAE (index-1) | Simscape auto-formulates |
| Controller (new harness) | Continuous or 0.1s discrete | Stateflow/MATLAB Function | TBD by harness design |
| Breathing generator | Continuous | Sinusoidal signal | Period = 60/breathing_rate seconds |
| BCD commands | Event-driven | Boolean/double | Triggered by depth error thresholds |

**Rate transition strategy:** All signals are continuous in the Simscape domain. If controller is discrete (Stateflow with sample time), Rate Transition blocks are not needed because Simscape handles continuous↔discrete at PS-Simulink converter boundaries.

---

## 10. Validation Evidence

| Evidence Type | Available? | Description | Covers |
|---------------|-----------|-------------|--------|
| Hardware test data | No | No physical diver instrumentation | — |
| Component datasheets | Partial | EN 250 regulator specs, tank capacities | Regulator WOB, tank volume |
| Reference model | Partial | Valenko 2016 dynamic buoyancy model | BCD + buoyancy dynamics |
| Analytic expectations | Yes | Boyle's law, ideal gas, drag equation | All gas volumes, drag force |
| Standard maneuvers | Yes | PADI/SSI dive profiles, US Navy tables | Ascent rates, safety stops |
| SAC rate data | Yes | Buzzacott 2014 field measurements | Gas consumption |
| Drag measurements | Yes | Passmore & Rickers 2002 | Drag coefficient, frontal area |

---

## 11. Reference Sources

| Source | Type | Used For |
|--------|------|----------|
| Valenko, Mezgec, Pec, Golob (2016). "Dynamic model of scuba diver buoyancy." *Ocean Engineering* 117:1-8. DOI: 10.1016/j.oceaneng.2016.03.041 | Paper | Primary reference for dynamic buoyancy model equations |
| Korosec, Slavinec, Bernad (2003). "Physical model of buoyancy..." *Eur. J. Phys.* 24(5):499-508. DOI: 10.1088/0143-0807/24/5/305 | Paper | Buoyancy model formulation, parameter values |
| Muskinja, Riznar, Golob (2022). "Optimized fuzzy logic control system for diver's ABCD." *Mathematics* 11(1):22. DOI: 10.3390/math11010022 | Paper | BCD control strategies, plant model validation |
| Buzzacott, Pollock, Rosenberg (2014). "Exercise intensity inferred from air consumption." *Diving Hyperb. Med.* 44(2):74-78 | Paper | SAC rate validation data (12-25 L/min) |
| Passmore, Rickers (2002). "Drag levels and energy requirements on a SCUBA diver." *Sports Eng.* 5. DOI: 10.1046/j.1460-2687.2002.00107.x | Paper | Cd = 1.0-1.2, frontal area measurements |
| Loske (2013). "Fundamentals of SCUBA-diving physics." *Int. J. Sports Sci.* 3(4):110-120 | Paper | Isothermal gas assumption justification |
| Dyer (2001). "Development of an automatic buoyancy device." Thesis | Thesis | ABCD prototype dynamics, control model |
| Riznar, Valenko, Golob, Muskinja (2015). "Optimized Diving Velocity and Depth Control." *MTS Journal* 49(1). DOI: 10.4031/MTSJ.49.1.11 | Paper | Depth control optimization strategies |
| U.S. Navy Diving Manual, Rev 7 (2018). NAVSEA 0910-LP-115-1921 | Standard | Ascent rates (9 m/min), no-deco limits, dive profiles |
| EN 250:2000. Respiratory equipment for diving | Standard | Regulator WOB < 3 J/L, cracking pressure specs |
| Held, Pendergast (2013). "Relative effects of submersion..." *J. Appl. Physiol.* DOI: 10.1152/japplphysiol.00584.2012 | Paper | Breathing mechanics underwater, WOB increase |
| Somers (1992). "Buoyancy and the scuba diver." NOAA Technical Report | Report | Buoyancy principles, AL80 characteristics |
| Wienke (2016). *Biophysics and Diving Decompression Phenomenology*. Bentham Science | Textbook | Gas law assumptions at diving pressures |
| NOAA Diving Manual, 6th Ed (2017). Ed. G. McFall | Manual | Standard dive procedures, safety protocols |

---

## 12. Open Questions

| # | Question | Options | Decision |
|---|----------|---------|----------|
| 1 | Should the new harness use Model Reference to `Scuba_Diver.slx` or copy the plant inline? | (a) Model Reference (cleaner, reusable), (b) Inline copy (simpler debugging) | 🟡 Pending |
| 2 | What controller architecture for the full-dive harness? | (a) Single Stateflow chart (dive phases + BCD + breathing), (b) Separate Stateflow for dive profile + MATLAB Function for BCD/breathing, (c) Simulink subsystems with state logic | 🟡 Pending |
| 3 | Should breathing effort be a smooth sinusoid or a more realistic waveform (fast inhale, slow exhale)? | (a) Sinusoidal (simpler, adequate for buoyancy), (b) Asymmetric (physiologically realistic) | 🟡 Pending |
| 4 | Additional truth outputs needed from plant? | (a) Current set sufficient, (b) Add tank pressure/moles as Simulink outports | 🟡 Pending |

---

## 13. Future Considerations

- **Wetsuit compression model**: Neoprene volume decreases with depth per modified Boyle's law (compression exponent ~0.7). Parameters will be defined in `scuba_params.m` but implementation deferred to v2.
- **Multi-gas / stage bottle**: Switching between back gas and deco gas at predetermined depths.
- **Decompression algorithm**: Tissue compartment model (Bühlmann ZHL-16C) for computing required stops.
- **Current/surge disturbances**: Periodic vertical force disturbance from wave action or current.
- **Equipment failures**: Free-flow regulator, stuck inflate valve, OPRV malfunction.

---

## Appendix A: Related Documents

- [Architecture Spec](scuba-diver-architecture.md)
- [Implementation Plan](scuba-diver-implementation-plan.md)
- [Test Plan](scuba-diver-test-plan.md)
