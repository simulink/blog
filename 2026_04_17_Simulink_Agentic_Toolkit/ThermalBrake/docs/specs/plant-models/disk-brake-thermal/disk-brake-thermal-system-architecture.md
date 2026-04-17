# Disk Brake Thermal Model — System & Architecture Spec

## Status: Draft
**Last Updated:** 2026-04-14  
**Author:** Amp  

---

## 1. Executive Summary

This specification defines a lumped-parameter thermal model of a single front disk brake assembly for a typical mid-size sedan (~1700 kg), coupled with a simple longitudinal vehicle dynamics model. The plant accepts driver brake and accelerator pedal commands (0–1), road grade, and ambient temperature. A BrakeHydraulics subsystem converts the brake pedal command to hydraulic line pressure, clamping force, and braking torque, which feeds back to the vehicle as a retarding force. A SimpleDrive subsystem converts the accelerator pedal command to a traction force. The vehicle model computes speed, and the resulting per-brake heat power feeds the thermal model, which predicts transient temperatures of the rotor, brake pad, and backing plate during braking and cooling periods. It is intended for use as a standalone plant model to evaluate brake thermal behavior during standard driving maneuvers — not closed-loop with a specific controller.

The model captures the dominant heat transfer mechanisms: frictional heat generation at the pad–rotor interface, conduction between components, convective cooling to ambient air (speed-dependent), and radiative heat loss at elevated temperatures. The integrated vehicle model eliminates the need for pre-computed speed and braking power profiles, allowing scenarios to be defined by driver pedal commands and grade alone.

---

## 2. Problem Statement

### Current Situation

No brake thermal model exists for this project. Engineers need to predict rotor and pad temperatures during repeated braking, sustained downhill braking, and emergency stops to ensure temperatures remain within safe operating limits (rotor < 600°C, pad < 300°C).

### Opportunity

A validated thermal model enables:
1. Prediction of brake fade onset during aggressive driving
2. Evaluation of cooling adequacy between braking events
3. Sensitivity analysis on rotor mass, pad material, and convection coefficient
4. Input to future closed-loop ABS/brake controller development

---

## 3. Goals & Success Metrics

| Goal | Description |
|------|-------------|
| **G1: Physically reasonable thermal response** | Rotor temperature rise in a single emergency stop from 100 km/h matches analytic prediction within 15% |
| **G2: Correct cooling dynamics** | Cooling time constant matches lumped-analysis prediction (τ = mCp/(hA)) within 20% |
| **G3: Fade test temperature build-up** | Repeated braking shows monotonic temperature increase with correct trend toward thermal equilibrium |
| **G4: Real-time capable** | Simulation runs at ≥10× real-time with variable-step solver |

### Success Metrics

- **Single-stop ΔT**: Rotor temperature rise from a 100→0 km/h panic stop ≈ 80–120°C (per Limpert, COMSOL reference: ~85°C for 1800 kg car at 25 m/s)
- **Cooling time constant**: τ_rotor ≈ 60–120 s depending on vehicle speed during cooling
- **Heat partition**: ~95% of braking energy goes to rotor, ~5% to pads (validated against Limpert Eq. 3-17)

---

## 4. Non-Goals (v1)

| Non-Goal | Rationale |
|----------|-----------|
| Spatial temperature distribution within rotor | Lumped model assumes uniform temperature; FEA not needed for system-level analysis |
| Brake fluid temperature / vapor lock prediction | Requires additional caliper and piston thermal nodes — deferred to v2 |
| Pad wear modeling | Mechanical wear is a separate concern from thermal behavior |
| Tire–road friction model | Braking force is an input; no tire slip or μ-slip curve modeled |
| Rear brake modeling | Front brakes handle ~70% of braking energy; rear can be added by parameterization |
| Lateral / yaw dynamics | Vehicle modeled as point mass in longitudinal direction only |
| Detailed drivetrain / engine model | SimpleDrive provides a basic traction force from accel_cmd; no engine map, transmission, or drivetrain inertia |

---

## 5. Operating Scenarios

### Scenario 1: Single Emergency Stop (Panic Braking)

**Operating Conditions:** Dry road, ambient 25°C, vehicle at 1700 kg, initial brake temperature at ambient.

**Maneuver/Excitation:**
1. Vehicle traveling at 100 km/h (27.8 m/s)
2. Full braking at 10 m/s² deceleration for ~2.78 s
3. Brakes released, vehicle stationary, cooling for 60 s
4. Observe peak rotor temperature and cooling curve

**Expected Behavior:** Rotor peaks at ~105–130°C above ambient, then cools exponentially.

### Scenario 2: Repeated Braking (Fade Test, per SAE J1247 / FMVSS 135 S7.14)

**Operating Conditions:** 15 consecutive stops from 100 km/h at 0.4g deceleration, 1 km acceleration interval between stops.

**Maneuver/Excitation:**
1. Brake from 100 km/h to rest at ~4 m/s² (each stop ~6.9 s)
2. Accelerate back to 100 km/h over ~1 km (~25 s cooling interval)
3. Repeat 15 times
4. Observe cumulative temperature build-up

**Expected Behavior:** Temperature rises with each stop, approaching thermal equilibrium at ~400–500°C for front rotor. Demonstrates fade potential.

### Scenario 3: Sustained Downhill Braking

**Operating Conditions:** 7% grade, 3.2 km descent at constant 80 km/h, steady brake application.

**Maneuver/Excitation:**
1. Constant speed downhill, continuous brake power = m·g·sin(θ)·v ≈ 26 kW total, ~9 kW per front brake
2. Duration: ~144 s
3. Cooling period: 120 s at 50 km/h after descent

**Expected Behavior:** Rotor temperature rises steadily, reaching 300–450°C range. Cooling is slow due to sustained heat input.

### Scenario 4: City Driving Cycle

**Operating Conditions:** Series of moderate stops from 50 km/h, 0.3g deceleration, 30 s intervals.

**Maneuver/Excitation:**
1. 10 stops from 50 km/h at 3 m/s² deceleration
2. 30 s driving interval between stops
3. Observe temperature profile

**Expected Behavior:** Moderate temperature excursions (< 200°C), temperatures remain well within safe limits.

---

## 6. Physical Model Requirements

### 6.1 States & Governing Equations

| State | Physical Meaning | Equation Type | Subsystem |
|-------|-----------------|---------------|-----------|
| v_vehicle | Longitudinal vehicle speed | ODE (Newton's 2nd law) | VehicleLongitudinal |
| T_rotor | Bulk rotor temperature | ODE (energy balance) | RotorThermalNode |
| T_pad | Bulk brake pad temperature | ODE (energy balance) | PadThermalNode |
| T_backing | Backing plate temperature | ODE (energy balance) | BackingPlateNode |

### 6.2 Key Assumptions

| Assumption | Justification |
|------------|---------------|
| Lumped thermal capacitance (uniform T per component) | Biot number < 0.1 for rotor thickness ~12 mm with h ≈ 80 W/m²K, k ≈ 50 W/mK → Bi ≈ 0.02 |
| Symmetric braking (both pads identical) | Floating caliper — both sides apply equal pressure |
| No heat storage in caliper or brake fluid | Deferred to v2 — caliper thermal mass is small relative to rotor |
| Speed-dependent convection coefficient | h varies with vehicle speed per empirical correlation (Limpert Eq. 3-40/41) |
| Constant material properties (no temperature dependence) | Valid for cast iron up to ~500°C; pad properties less certain but acceptable for lumped model |
| Heat generated only at pad–rotor interface | Standard assumption for disk brake thermal analysis |
| Point-mass longitudinal vehicle dynamics | Sufficient for computing speed profile and braking power; no suspension, pitch, or weight transfer |
| Aerodynamic drag modeled with constant Cd·A | Standard approximation for sedan at moderate speeds |
| Rolling resistance modeled with constant coefficient | Valid on hard surfaces at moderate speeds |

### 6.3 Fidelity Level

**Chosen fidelity:** Medium (lumped 3-node thermal network + point-mass vehicle)

**Justification:** A lumped model with 3 thermal nodes (rotor, pad, backing plate) captures the dominant thermal dynamics for system-level analysis. The lumped approach is validated by the low Biot number of the rotor. Higher fidelity (FEA, spatial distribution) is not needed for predicting bulk temperatures and fade onset, and cannot be validated without thermocouple data from a specific vehicle.

### 6.4 Sign Conventions

| Convention | Definition |
|------------|------------|
| Heat flow positive | Heat flowing INTO a thermal node is positive |
| Temperature | Absolute temperature in Kelvin for radiation calculations, Celsius for display |
| Braking power | Positive when brakes are applied (energy dissipated) |
| Vehicle speed | Positive forward; speed clamped to ≥ 0 (no reverse) |
| Brake command | 0 = no braking, 1 = maximum braking (full pedal) |
| Accelerator command | 0 = no throttle, 1 = full throttle (maximum drive force) |
| Road grade | Positive uphill (gravity assists braking); negative downhill (gravity opposes braking) |

---

## 7. Plant Interface

### 7.1 Plant Inputs

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| Brake pedal command | brake_cmd | 0–1 | double | continuous | Normalized brake pedal position (0 = released, 1 = full pedal) |
| Accelerator pedal command | accel_cmd | 0–1 | double | continuous | Normalized accelerator pedal position (0 = released, 1 = full throttle) |
| Road grade angle | theta_grade | rad | double | continuous | Road grade angle (positive = uphill, negative = downhill). For a 7% grade, θ ≈ atan(0.07) ≈ 0.070 rad |
| Ambient temperature | T_amb | °C | double | continuous | Environmental air temperature |

### 7.2 Plant Outputs

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| Rotor temperature | T_rotor | °C | double | continuous | Bulk rotor temperature |
| Pad temperature | T_pad | °C | double | continuous | Bulk pad material temperature |
| Vehicle speed | v_vehicle | m/s | double | continuous | Longitudinal vehicle speed |
| Brake torque | tau_brake | N·m | double | continuous | Braking torque at one front brake |

### 7.3 Exogenous Inputs (Disturbances)

| Signal | Symbol | Unit | Source | Description |
|--------|--------|------|--------|-------------|
| Ambient temperature | T_amb | °C | Scenario-dependent | Environmental temperature (typically constant per scenario) |
| Road grade angle | theta_grade | rad | Scenario-dependent | Grade profile (constant or varying per scenario) |

### 7.4 Truth Outputs (Debug/Validation Only)

| Signal | Symbol | Unit | Description |
|--------|--------|------|-------------|
| Backing plate temperature | T_backing | °C | Backing plate temperature (not measurable in practice without instrumentation) |
| Per-brake power | P_brake | W | Braking power at one front brake (for energy balance verification) |
| Heat into rotor | Q_rotor | W | Heat partition to rotor (for energy balance verification) |
| Convective heat loss | Q_conv | W | Total convective cooling (for energy balance verification) |
| Radiative heat loss | Q_rad | W | Total radiative cooling |
| Brake torque per front brake | tau_brake | N·m | Braking torque at one front wheel |
| Brake line pressure | P_line | Pa | Hydraulic line pressure from brake command |

---

## 8. Initialization & Operating Points

### 8.1 Nominal Operating Point

| State | Initial Value | Unit | How Determined |
|-------|--------------|------|----------------|
| v_vehicle | 27.8 (100 km/h) | m/s | Scenario-dependent initial speed |
| T_rotor | 25 (ambient) | °C | Cold start assumption |
| T_pad | 25 (ambient) | °C | Cold start assumption |
| T_backing | 25 (ambient) | °C | Cold start assumption |

### 8.2 Operating Range

| Parameter | Min | Nominal | Max | Unit |
|-----------|-----|---------|-----|------|
| Ambient temperature | -10 | 25 | 45 | °C |
| Vehicle speed | 0 | 60 | 200 | km/h |
| Brake command | 0 | 0.3 | 1.0 | — |
| Accelerator command | 0 | 0.3 | 1.0 | — |
| Road grade | -10 | 0 | +10 | % |
| Rotor temperature | -10 | 25 | 700 | °C |

---

## 9. Rate & Timing

| Component | Rate | Type | Notes |
|-----------|------|------|-------|
| Vehicle dynamics | Continuous | ODE | 1 first-order ODE (longitudinal speed) |
| Thermal dynamics | Continuous | ODE | 3 coupled first-order ODEs |
| Solver | Variable-step | ode45 or ode23t | Non-stiff system; ode45 recommended |

---

## 10. Validation Evidence

| Evidence Type | Available? | Description | Covers |
|---------------|-----------|-------------|--------|
| Hardware test data | No | No physical test data available | — |
| Component datasheets | Partial | Cast iron and semi-metallic pad material properties from Limpert Table 3-1 | Material properties |
| Reference model | Yes | COMSOL brake disc example (1800 kg car, panic stop, peak ~415 K) | Single stop temperature profile |
| Analytic expectations | Yes | Lumped energy balance: ΔT = E_brake / (m_rotor × Cp) for adiabatic stop | Single stop peak temperature |
| Standard maneuvers | Yes | FMVSS 135 fade test (15 heating snubs), SAE J1247 simulated mountain brake test | Fade and sustained braking |

---

## 11. Reference Sources

| Source | Type | Used For |
|--------|------|----------|
| Limpert, R., *Brake Design and Safety*, 2nd Ed. | Textbook | Heat partition (Eq. 3-17), convection correlations (Eq. 3-40/41), radiation (Eq. 3-46), lumped analysis (§3.1.5), material properties (Table 3-1) |
| COMSOL, *Heat Generation in a Disc Brake* (Tutorial) | FEA example | Reference temperature profile, material properties, convection formula |
| FMVSS 135, 49 CFR §571.135 | Regulatory standard | Fade test procedure (S7.14), test conditions |
| SAE J1247 | Industry standard | Simulated mountain brake test procedure |
| UTA Thesis, *Thermal Analysis of Disk Brake* (Mavmatrix) | Master's thesis | Governing equations, heat partition validation (~97% to rotor), convection coefficient ~150 W/m²K |

---

## 12. Implementation Recommendation: Simulink vs Simscape

### Recommendation: **Basic Simulink blocks** (signal-flow approach)

### Rationale

| Factor | Simulink Blocks | Simscape Thermal | Verdict |
|--------|----------------|------------------|---------|
| **Model complexity** | 3 integrators, gains, sums, product blocks — straightforward | 3 Thermal Mass blocks, Conductive/Convective HT blocks, radiation source — also straightforward | Tie |
| **Speed-dependent convection** | Easy: multiply h(v) by ΔT directly in signal flow | Requires variable conductance element or custom Simscape component — more complex | **Simulink** |
| **Radiation (T⁴ nonlinearity)** | Math blocks or MATLAB Fcn — direct implementation | Built-in Radiative HT block available | Tie |
| **Multi-domain coupling** | Already signal-based (speed, power are signals from vehicle model) | Requires Simulink-PS / PS-Simulink converters at every boundary | **Simulink** |
| **Transparency / debuggability** | Equations visible as block diagram — easy to verify against spec | Physics hidden inside library blocks — harder to audit equations | **Simulink** |
| **Extensibility to v2 (fluid, caliper)** | Add more integrators and signal paths | Simscape shines for complex thermal networks (many nodes) | Simscape (future) |
| **Code generation / HIL** | No issues | Simscape has some code-gen restrictions | **Simulink** |
| **Solver compatibility** | Works with any solver | Requires Simscape solver (local solver or global DAE) | **Simulink** |

**Conclusion:** For a 3-node lumped thermal model with signal-based inputs (pedal commands, brake power, vehicle speed), **basic Simulink blocks** are the better choice. The model is simple enough that Simscape's physical network approach adds overhead without benefit. The speed-dependent convection coefficient is naturally expressed as a signal-flow computation. If the model later grows to 10+ thermal nodes with complex conduction paths, migrating to Simscape would be justified.

---

# Architecture

## A1. Overview

An integrated simulation combining driver command processing (BrakeHydraulics and SimpleDrive), a simple longitudinal vehicle model, and a 3-node lumped thermal network for a single front disk brake. Top-level inputs are driver brake and accelerator pedal commands (0–1), road grade, and ambient temperature. The BrakeHydraulics subsystem converts brake_cmd to braking torque and force, the SimpleDrive subsystem converts accel_cmd to traction force, and the vehicle subsystem computes speed. Per-brake heat power feeds the thermal subsystem that computes transient temperatures of the rotor, pad, and backing plate using energy balance ODEs with convection, conduction, and radiation heat transfer.

## A2. Subsystem Diagram

```
  brake_cmd ──┐    accel_cmd ──┐   theta_grade ──┐
               │                │                  │
          ┌────▼────┐     ┌────▼────┐              │
          │  Brake  │     │ Simple  │              │
          │Hydraulic│     │  Drive  │              │
          │   s     │     └────┬────┘              │
          └──┬───┬──┘     F_drive                  │
     tau_brake  P_brake_front  │                   │
        │       │              │                   │
   ┌────▼───────│──────────────▼───────────────────▼────┐
   │              VehicleLongitudinal                   │
   │  m·dv/dt = F_drive - F_brake_at_wheel              │
   │            - F_drag - F_roll - F_grade              │
   └──────────────────────┬────────────────────────────┘
                     v_vehicle ──────────────────────────►
                          │
                     ┌────▼────┐
                     │  Heat   │
           ┌────────►│Partition│◄────────┐
           │         └──┬───┬──┘         │
           │       Q_rotor Q_pad         │
           │            │   │            │
      ┌────▼────┐  ┌───▼───▼───┐  ┌─────▼─────┐
T_amb►│  Rotor  │◄─┤ Pad-Rotor │─►│   Pad     │
      │ Thermal │  │ Conduction│  │  Thermal  │
      │  Node   │  └───────────┘  │   Node    │
      └────┬────┘                 └─────┬─────┘
           │                      ┌─────▼─────┐
      T_rotor                     │  Backing  │
           │                      │   Plate   │
      Q_conv, Q_rad               │   Node    │
                                  └─────┬─────┘
                                     T_backing
```

## A3. Component Catalog

| Component | Implementation | Physics Domain | States | Port Interface | Dependencies |
|-----------|---------------|----------------|--------|----------------|--------------|
| **BrakeHydraulics** | Subsystem | Mechanical/Hydraulic | None (algebraic) | In: brake_cmd → Out: tau_brake, F_brake_at_wheel, P_brake_front | Brake params |
| **SimpleDrive** | Subsystem | Mechanical | None (algebraic) | In: accel_cmd → Out: F_drive | F_drive_max |
| **VehicleLongitudinal** | Subsystem | Mechanical | v_vehicle | In: F_brake_at_wheel, F_drive, theta_grade → Out: v_vehicle | Vehicle params |
| **Heat Partition** | Subsystem | Thermal | None (algebraic) | In: P_brake → Out: Q_rotor, Q_pad | Material properties |
| **Rotor Thermal Node** | Subsystem | Thermal | T_rotor | In: Q_rotor, Q_cond_from_pad, T_amb, v_veh → Out: T_rotor | h(v) correlation |
| **Pad Thermal Node** | Subsystem | Thermal | T_pad | In: Q_pad, Q_cond_to_rotor, Q_cond_to_backing → Out: T_pad | — |
| **Backing Plate Node** | Subsystem | Thermal | T_backing | In: Q_cond_from_pad, T_amb → Out: T_backing | — |
| **Convection Calculator** | Subsystem | Fluid/Thermal | None | In: v_veh → Out: h_conv | Empirical correlation |

## A4. Equations of Motion

### A4.1 BrakeHydraulics

Converts normalized brake pedal command to braking torque, force at tire contact, and heat generation at one front brake.

```
P_line = brake_cmd × P_line_max                              [hydraulic line pressure]
F_clamp = P_line × A_piston                                   [clamp force per caliper]
F_friction = 2 × μ_pad × F_clamp                             [friction force per brake, 2 pads]
tau_brake = F_friction × R_eff                                [braking torque per brake]
F_brake_at_wheel = 4 × tau_brake / R_wheel                    [total vehicle braking force, 4 brakes]
P_brake_front = tau_brake × v_vehicle / R_wheel               [heat power at one front brake]
```

Note: v_vehicle is fed back from VehicleLongitudinal to compute heat power.

### A4.2 SimpleDrive

Converts normalized accelerator pedal command to traction force.

```
F_drive = accel_cmd × F_drive_max
```

Where F_drive_max ≈ 7000 N (typical sedan maximum traction force in low gear).

### A4.3 Vehicle Longitudinal Dynamics

**State:** v_vehicle [m/s]

```
m_veh · dv/dt = F_drive - F_brake_at_wheel - F_drag - F_roll - F_grade
```

Where:
- `F_brake_at_wheel` = total braking force from BrakeHydraulics (all 4 wheels combined) [N]
- `F_drive` = traction force from SimpleDrive [N]
- `F_drag = ½ · ρ_air_drag · Cd · A_frontal · v²` (aerodynamic drag) [N]
- `F_roll = Cr · m_veh · g · cos(θ)` (rolling resistance) [N]
- `F_grade = m_veh · g · sin(θ)` (grade resistance; negative when downhill) [N]
- `v_vehicle = max(v, 0)` — speed clamped to non-negative (integrator lower limit = 0)

### A4.4 Heat Generation & Partition

Total braking power at one front brake (computed by BrakeHydraulics):

```
P_brake = P_brake_front  (from BrakeHydraulics subsystem)
```

Heat partition factor (Limpert Eq. 3-17, steady-state approximation):

```
γ = √(k_r · ρ_r · c_r) / (√(k_r · ρ_r · c_r) + √(k_p · ρ_p · c_p))
```

Typically γ ≈ 0.95 for cast iron rotor / semi-metallic pad.

```
Q_rotor_in = γ · P_brake
Q_pad_in   = (1 - γ) · P_brake
```

### A4.5 Rotor Thermal Node

**State:** T_rotor [°C]

```
m_r · c_r · dT_rotor/dt = Q_rotor_in
                          - h_conv(v) · A_rotor · (T_rotor - T_amb)        [convection]
                          - k_cond_rp · (T_rotor - T_pad)                  [conduction to pad]
                          - ε_r · σ · A_rotor · ((T_rotor+273)⁴ - (T_amb+273)⁴)  [radiation]
```

Where:
- `h_conv(v) = 0.037·(k_air/D)·Re^0.8·Pr^0.33` (turbulent flat plate correlation, Limpert/COMSOL)
- `Re = ρ_air · v · D / μ_air`
- `k_cond_rp = k_p · A_contact / t_pad` (conductive coupling between pad and rotor)

### A4.6 Pad Thermal Node

**State:** T_pad [°C]

```
m_p · c_p · dT_pad/dt = Q_pad_in
                        + k_cond_rp · (T_rotor - T_pad)                    [conduction from rotor]
                        - k_cond_pb · (T_pad - T_backing)                  [conduction to backing]
                        - h_conv_pad · A_pad_exposed · (T_pad - T_amb)     [convection, minor]
```

### A4.7 Backing Plate Thermal Node

**State:** T_backing [°C]

```
m_b · c_b · dT_backing/dt = k_cond_pb · (T_pad - T_backing)
                            - h_conv_back · A_backing · (T_backing - T_amb)  [convection]
```

Where:
- `k_cond_pb = k_backing · A_backing / t_backing`

### A4.8 Convection Coefficient Correlation

Speed-dependent convection for the rotor (Limpert Eq. 3-40 for solid disc):

```
h_conv(v) = 0.70 · (k_air / D) · Re^0.55          for solid disc
```

With a minimum (natural convection at v=0):

```
h_conv = max(h_conv(v), h_natural)    where h_natural ≈ 5–10 W/m²K
```

For a ventilated disc, multiply by ~2.

## A5. Nonlinearities & Constraints

| Nonlinearity | Type | Location | Parameters | Physical Basis |
|-------------|------|----------|------------|----------------|
| Radiation T⁴ | Power law | Rotor node | ε = 0.28–0.55, σ = 5.67e-8 | Stefan-Boltzmann radiation from hot rotor surfaces |
| Speed-dependent h | Empirical correlation | Convection calculator | Re^0.55 or Re^0.8 | Forced convection increases with airflow |
| Braking power clamp | Saturation | Heat partition | P_brake ≥ 0 | No negative heat generation |
| Vehicle speed clamp | Integrator lower limit | VehicleLongitudinal | v ≥ 0 | Vehicle cannot travel in reverse from braking |
| Aerodynamic drag v² | Quadratic | VehicleLongitudinal | Cd_A, ρ_air | Drag force proportional to speed squared |
| Brake command saturation | Saturation | BrakeHydraulics | 0 ≤ brake_cmd ≤ 1 | Pedal cannot go beyond physical limits |
| Accel command saturation | Saturation | SimpleDrive | 0 ≤ accel_cmd ≤ 1 | Pedal cannot go beyond physical limits |

## A6. Numerical Considerations

| Concern | Approach |
|---------|----------|
| **Solver** | ode45 (variable-step, non-stiff). System is 4 first-order ODEs — vehicle speed (~1 s dynamics) and thermal (~10–100 s) — not stiff |
| **Algebraic loops** | None — all equations are explicit ODEs with direct feedthrough only for algebraic heat partition |
| **Zero-crossing** | Vehicle speed integrator lower limit (v=0) generates zero-crossings when vehicle stops; handled by Simulink ZC detection |
| **Step size** | Max step 0.1 s (sufficient for vehicle braking dynamics with ~3 s stops and thermal time constants > 1 s) |

## A7. Parameter Table

| Parameter | Symbol | Value | Unit | Source | Uncertainty | Block Path |
|-----------|--------|-------|------|--------|-------------|------------|
| Rotor mass | m_r | 6.0 | kg | Typical mid-size sedan front ventilated disc | ±20% | Plant/Rotor |
| Rotor specific heat | c_r | 449 | J/(kg·K) | Cast iron, COMSOL Table 1 | ±5% | Plant/Rotor |
| Rotor thermal conductivity | k_r | 50 | W/(m·K) | Cast iron (Limpert/COMSOL: 82 for pure iron, 50 for gray cast iron) | ±15% | Plant/Rotor |
| Rotor density | ρ_r | 7200 | kg/m³ | Cast iron | ±3% | Plant/Rotor |
| Rotor outer radius | R_outer | 0.14 | m | Typical 280 mm diameter disc | ±10% | Plant/Rotor |
| Rotor thickness | t_rotor | 0.012 | m | Solid disc; ventilated ~0.024 m total | ±15% | Plant/Rotor |
| Rotor cooling surface area | A_rotor | 0.12 | m² | 2 × π × (R²_outer - R²_inner) for both faces + edge | ±15% | Plant/Rotor |
| Rotor emissivity | ε_r | 0.40 | — | Machined cast iron (Limpert: 0.55 used, new: 0.28) | ±30% | Plant/Rotor |
| Pad mass (one pad) | m_p | 0.30 | kg | Semi-metallic pad | ±20% | Plant/Pad |
| Pad specific heat | c_p | 935 | J/(kg·K) | COMSOL Table 1 | ±10% | Plant/Pad |
| Pad thermal conductivity | k_p | 8.7 | W/(m·K) | COMSOL Table 1 (semi-metallic) | ±20% | Plant/Pad |
| Pad density | ρ_p | 2000 | kg/m³ | COMSOL Table 1 | ±10% | Plant/Pad |
| Pad thickness | t_pad | 0.012 | m | New pad | ±15% | Plant/Pad |
| Pad contact area | A_contact | 0.004 | m² | ~40 cm² per pad | ±15% | Plant/Pad |
| Backing plate mass | m_b | 0.25 | kg | Steel backing | ±20% | Plant/Backing |
| Backing plate specific heat | c_b | 490 | J/(kg·K) | Low-carbon steel | ±5% | Plant/Backing |
| Backing plate conductivity | k_b | 45 | W/(m·K) | Steel | ±10% | Plant/Backing |
| Backing plate thickness | t_b | 0.005 | m | Typical | ±15% | Plant/Backing |
| Backing plate area | A_backing | 0.004 | m² | Same as pad contact area | ±15% | Plant/Backing |
| Stefan-Boltzmann constant | σ | 5.67e-8 | W/(m²·K⁴) | Physical constant | 0 | Plant/Rotor |
| Natural convection coefficient | h_nat | 8 | W/(m²·K) | Free convection from horizontal plate | ±30% | Plant/Convection |
| Rotor diameter (for Re) | D | 0.28 | m | 2 × R_outer | — | Plant/Convection |
| Air thermal conductivity | k_air | 0.026 | W/(m·K) | At 300 K | ±5% | Plant/Convection |
| Air density | ρ_air | 1.17 | kg/m³ | At 300 K, 1 atm | ±5% | Plant/Convection |
| Air viscosity | μ_air | 1.8e-5 | Pa·s | At 300 K | ±5% | Plant/Convection |
| Air specific heat | c_air | 1005 | J/(kg·K) | At 300 K | ±3% | Plant/Convection |
| Max line pressure | P_line_max | 120e5 | Pa | 120 bar, typical sedan brake system | ±15% | Plant/BrakeHydraulics |
| Piston area | A_piston | 0.0020 | m² | ~20 cm², single-piston floating caliper | ±15% | Plant/BrakeHydraulics |
| Pad friction coefficient | μ_pad | 0.40 | — | Semi-metallic pad, typical range 0.35–0.45 | ±15% | Plant/BrakeHydraulics |
| Effective friction radius | R_eff | 0.11 | m | Mean radius of pad contact on 280 mm disc | ±10% | Plant/BrakeHydraulics |
| Max drive force | F_drive_max | 7000 | N | Typical sedan max traction force (low gear) | ±20% | Plant/SimpleDrive |
| Vehicle mass | m_veh | 1700 | kg | Mid-size sedan | ±10% | Plant/Vehicle |
| Wheel radius | R_wheel | 0.32 | m | 205/55R16 tire | ±5% | Plant/Vehicle |
| Drag coefficient × frontal area | Cd_A | 0.72 | m² | Typical sedan: Cd≈0.30, A≈2.4 m² | ±15% | Plant/Vehicle |
| Air density (for drag) | ρ_air_drag | 1.225 | kg/m³ | ISA sea level | ±5% | Plant/Vehicle |
| Rolling resistance coefficient | Cr | 0.012 | — | Typical passenger car tire on asphalt | ±20% | Plant/Vehicle |
| Gravitational acceleration | g | 9.81 | m/s² | Standard gravity | 0 | Plant/Vehicle |
| Initial vehicle speed | v0 | 27.8 | m/s | 100 km/h (scenario-dependent) | — | Plant/Vehicle |

## A8. Uncertainty & Sensitivity Hooks

| Parameter | Nominal | Range | Subsystem | Rationale for Sweep |
|-----------|---------|-------|-----------|---------------------|
| h_nat | 8 W/m²K | 5–15 | Convection | Uncertain natural convection; dominates low-speed cooling |
| ε_r | 0.40 | 0.28–0.55 | Rotor | Depends on surface condition; affects high-temperature cooling |
| m_r | 6.0 kg | 4.5–8.0 | Rotor | Varies by vehicle class; directly affects ΔT |
| k_p | 8.7 W/mK | 4–15 | Pad | Varies with pad composition; affects heat partition and pad temperature |
| γ (heat partition) | 0.95 | 0.90–0.98 | Heat partition | Literature range; affects pad vs rotor temperature split |

## A9. Key Decisions

| # | Decision | Options Considered | Choice | Rationale |
|---|----------|-------------------|--------|-----------|
| 1 | Implementation approach | (a) Simulink blocks, (b) Simscape Thermal | (a) Simulink blocks | 3-node model is simple; signal inputs avoid PS converter overhead; equations transparent for validation |
| 2 | Number of thermal nodes | (a) 1 (rotor only), (b) 3 (rotor+pad+backing), (c) 5+ (add caliper, fluid) | (b) 3 nodes | Good balance: captures pad temperature for fade assessment without excessive complexity |
| 3 | Convection correlation | (a) Constant h, (b) Speed-dependent h | (b) Speed-dependent | Critical for realistic cooling between stops; constant h would over/under-predict at different speeds |
| 4 | Radiation | (a) Ignore, (b) Include | (b) Include | Significant above 300°C; needed for fade test accuracy (Limpert §3.1.7e) |
| 5 | Driver command interface | (a) Force inputs, (b) Pedal commands (0-1) with brake hydraulics model | (b) Pedal commands | More realistic driver interface; brake hydraulics computes torque that feeds back to vehicle; enables future ABS/ESC controller integration |

## A10. Known Limitations

| Item | Description | Rationale for Deferral |
|------|-------------|------------------------|
| No caliper / piston / fluid nodes | Caliper mass ~1 kg absorbs some heat; fluid temperature determines vapor lock risk | Adds 2–3 more states; v1 focuses on rotor/pad temperatures |
| No temperature-dependent material properties | Cast iron specific heat increases ~10% from 25°C to 500°C | Effect is small relative to parameter uncertainty |
| No wheel/hub conduction path | Some heat conducts through wheel hub and bearings | Minor path compared to convection; uncertain contact conductance |

---

## Appendix A: Related Documents

- [Implementation & Test Plan](disk-brake-thermal-implementation-test-plan.md)
