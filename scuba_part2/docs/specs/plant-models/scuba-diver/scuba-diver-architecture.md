# Scuba Diver Plant Model — Architecture Spec

## Status: Draft
**Last Updated:** 2026-06-14  
**Author:** Guy Rouleau  
**Parent Spec:** [System Spec](scuba-diver-system.md)

---

## 1. Overview

This document specifies the architecture of the Scuba Diver plant model (`models/Scuba_Diver.slx`) — a medium-fidelity, 1-DOF vertical buoyancy model using a custom Simscape gas domain and Simscape translational mechanics. The plant shall interface with an external controller through 3 Simulink inports and 2 outports. Solver: ode23t (variable-step implicit trapezoidal for stiff DAE).

---

## 2. Goals, Non-Goals & Constraints

### 2.1 Design Goals

| ID | Goal |
|----|------|
| G1 | Pressure-driven gas flow — all mass transfer driven by physical pressure differentials, not command signals |
| G2 | Modular gas circuit — components are interchangeable library blocks with standard gas/translational ports |
| G3 | Local P_amb computation — each component independently senses depth via its own translational port |
| G4 | Single-file plant — reusable as Model Reference or standalone |

### 2.2 Non-Goals

| ID | Non-Goal | Rationale |
|----|----------|-----------|
| NG1 | Real-time execution | Variable-step solver; not HIL-targeted |
| NG2 | Code generation | Simscape components use symbolic equations |
| NG3 | Multi-diver interaction | Single plant instance |

### 2.3 Constraints

| Constraint | Description |
|------------|-------------|
| C1 | Custom Simscape domain (`+scuba/+gas/underwaterGas.ssc`) — library must be rebuilt after any .ssc change |
| C2 | ode23t solver required — DAE index-1 system from Simscape formulation; explicit solvers fail |
| C3 | All components need translational port for depth sensing — architectural invariant |
| C4 | Controller interface fixed: 3 inports (inflate, purge, breath), 2 outports (depth, vel) |

---

## 3. Architecture

### 3.1 Subsystem Diagram

```
                    ┌─────────────────────────────────────────────────────────┐
                    │  Scuba_Diver.slx (Plant)                                │
                    │                                                          │
  u₁ (inflate) ────┤──→ [BCDInflateValve] ──→ [BCDBladder] ──→ [PurgeValve]  │
  u₂ (purge) ──────┤──────────────────────────────────────────→ [PurgeValve]  │
                    │                                                          │
                    │  [GasTank]──→[1stStage]──→[GasVolume(IP)]               │
                    │                                ├──→[2ndStage]──→[Lungs]  │
  u₃ (breath) ─────┤────────────────────────────────────────────→ [Lungs]     │
                    │                                    [Lungs]──→[ExhaleValve]│
                    │                                                          │
                    │  [AmbientRef] ←── exhale & purge gas sinks              │
                    │  [OPRV] ←── BCD overpressure relief                     │
                    │                                                          │
                    │  ═══ Translational Domain ═══                            │
                    │  [DiverBody]──[Weights]──[GasTank(force)]                │
                    │  [Lungs(buoy)]──[BCDBladder(buoy)]                       │
                    │  [Surface stop]──[Bottom stop]                           │
                    │  [Initial Depth]──[World]──[MechProps(g,β)]              │
                    │  [MotionSensor] ─────────────────────────────→ y₁ (depth)│
                    │                  ─────────────────────────────→ y₂ (vel) │
                    └─────────────────────────────────────────────────────────┘
```

### 3.2 Component Catalog

| Component | Implementation | Physics Domain | States | Port Interface | Dependencies |
|-----------|---------------|----------------|--------|----------------|--------------|
| **GasTank** | Simscape library block | Gas + Translational | n_tank [mol] | A(gas out), R(translational) | Domain properties |
| **FirstStageRegulator** | Simscape library block | Gas + Translational | — (algebraic) | A(HP in), B(IP out), R(trans) | P_amb from R.x |
| **GasVolume** | Simscape library block | Gas | n_ip [mol] | A(gas) | — |
| **SecondStageRegulator** | Simscape library block | Gas + Translational | — (algebraic) | A(IP in), B(lung out), R(trans) | P_amb from R.x |
| **Lungs** | Simscape library block | Gas + Translational | n_lungs [mol] | A(gas), R(trans), input: breath_effort | P_amb from R.x |
| **ExhaleValve** | Simscape library block | Gas + Translational | — (algebraic) | A(lung), B(ambient), R(trans) | P_amb from R.x |
| **BCDInflateValve** | Simscape library block | Gas | — (algebraic) | A(IP in), B(BCD out), input: cmd | — |
| **BCDBladder** | Simscape library block | Gas + Translational | n_bcd [mol] | A(gas), R(trans) | P_amb from R.x |
| **OverpressureReliefValve** | Simscape library block | Gas + Translational | — (algebraic) | A(BCD), B(ambient), R(trans) | P_amb from R.x |
| **PurgeValve** | Simscape library block | Gas + Translational | — (algebraic) | A(BCD), B(ambient), R(trans), input: cmd | P_amb from R.x |
| **AmbientReference** | Simscape library block | Gas + Translational | — | A(gas), R(trans) | P_amb from R.x |
| **GasDomainProperties** | Simscape library block | Gas | — | A(gas) | R_gas, T params |
| **DiverBody** | Simscape library block | Translational | v [m/s] | R(trans) | rho_water, mass, V_body, Cd, A |
| **Weights** | Simulink/Simscape | Translational | — | R(trans) | Mass PB block |
| **MotionSensor** | Simscape Foundation | Translational | — | R(trans), C(ref) → x, v | — |
| **Hard Stops (×2)** | Simscape Foundation | Translational | — | R(trans) | Surface/bottom limits |
| **Initial Depth** | Simscape Foundation | Translational | — | Initial Length PB | ic.depth parameter |

### 3.3 Signal Flow

```
u₁ (inflate_cmd) ──→ [BCDInflateValve.cmd]
u₂ (purge_cmd) ───→ [PurgeValve.cmd]
u₃ (breath_effort) → [Lungs.breath_effort]
                                          ┌── Molar flow conservation ──┐
[GasTank] ─gas─→ [1stStage] ─gas─→ [GasVolume(IP)] ─gas─→ [2ndStage] ─gas─→ [Lungs] ─gas─→ [ExhaleValve] ─gas─→ [AmbientRef]
                                         │
                                         └─gas─→ [BCDInflateValve] ─gas─→ [BCDBladder] ─gas─→ [OPRV] ─gas─→ [AmbientRef]
                                                                                        └─gas─→ [PurgeValve] ─gas─→ [AmbientRef]

═══ Translational (all on same mechanical network) ═══
[World] ─── [DiverBody] ─── [Weights] ─── [GasTank(f_weight)] ─── [Lungs(f_buoy)] ─── [BCDBladder(f_buoy)]
         ├── [Surface Stop] ─── [Bottom Stop]
         ├── [Initial Depth]
         └── [MotionSensor] ──→ y₁ (depth = R.x)
                            ──→ y₂ (velocity = R.v)
```

---

## 4. Subsystem Details

### 4.1 Gas Domain

**Purpose:** Custom conserving domain for molar gas flow at constant temperature

**Interface:**
- Across variable: `p` [Pa] — pressure
- Through variable: `n_dot` [mol/s] — molar flow rate (balancing)
- Parameters: `R_gas` = 8.314 J/(mol·K), `T` = 293.15 K

### 4.2 GasTank

**Purpose:** High-pressure gas reservoir with weight force

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | A | gas outlet | Pa, mol/s | Gas connection to first stage |
| Conserving | R | translational | m, N | Mechanical port — applies gas weight force |

**Behavior:**
- Rigid container: P = n·R·T / V_tank
- Mass outflow depletes n_tank → pressure drops
- Applies downward force f = n_tank × M_gas × g (decreases as tank empties)
- No inflow permitted (one-way: tank empties only)

### 4.3 FirstStageRegulator

**Purpose:** Reduces tank pressure to intermediate pressure (P_amb + offset)

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | A | HP input | Pa, mol/s | From tank |
| Conserving | B | IP output | Pa, mol/s | To IP node |
| Conserving | R | translational | m, N | Depth sensing (zero force) |

**Behavior:**
- Regulates downstream pressure to P_target = min(P_A, P_amb + IP_offset)
- Flow: n_dot = max(0, (P_target - P_B) / R_open)
- Fails gracefully when tank pressure drops below IP setpoint (flow limited by available pressure)

### 4.4 SecondStageRegulator (Demand Valve)

**Purpose:** Delivers gas only when diver's breathing effort creates suction

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | A | IP input | Pa, mol/s | From IP node |
| Conserving | B | Lung output | Pa, mol/s | To lungs |
| Conserving | R | translational | m, N | Depth sensing (zero force) |

**Behavior:**
- Opens when lung pressure drops below ambient minus cracking pressure
- Flow: n_dot = max(0, (P_amb - P_B - P_crack) / R_open)
- One-way: gas flows only from IP to lungs
- Demand-proportional: flow rate increases with deeper inhale effort

### 4.5 Lungs

**Purpose:** Variable-volume gas chamber representing diver's lungs, with buoyancy force

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | A | gas | Pa, mol/s | Breathing gas connection |
| Conserving | R | translational | m, N | Depth sensing + buoyancy force |
| Input | — | breath_effort | Pa | Muscular pressure (Simulink→PS) |

**Behavior:**
- Internal pressure: P_lung = P_amb + breath_effort
- Volume: V_lungs = n_lungs × R×T / P_amb
- Buoyancy force: f = -ρ_water × g × V_lungs (upward)
- Negative breath_effort (inhale) → P_lung < P_amb → 2nd stage opens → gas flows in
- Positive breath_effort (exhale) → P_lung > P_amb → exhale valve opens → gas flows out

### 4.6 BCDBladder

**Purpose:** Flexible gas accumulator with volume limit and buoyancy

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | A | gas | Pa, mol/s | Gas connection |
| Conserving | R | translational | m, N | Depth sensing + buoyancy force |

**Behavior:**
- Flexible walls: P_internal = P_amb (when V < V_max)
- Volume: V_free = n_bcd × R×T / P_amb, clamped to V_max
- When overfilled: P_internal = P_amb + K_wall × (V_free - V_max)
- Buoyancy: f = -ρ_water × g × min(V_free, V_max)
- Moles clamped: n_bcd ≥ 0 (prevents unphysical reverse depletion)

### 4.7 DiverBody

**Purpose:** Combined mass + body displacement buoyancy + quadratic drag

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Conserving | R | translational | m, N | Single mechanical port |

**Behavior:**
- Force balance: f = m×a − m×g + ρ_water×g×V_body + 0.5×ρ_water×Cd×A×v×|v|
- Combines inertia, weight, Archimedes buoyancy, and drag in one component
- Drag opposes motion (velocity-squared with sign preservation)

---

## 5. Equations of Motion

### 5.1 Gas Circuit (Molar Conservation)

**State Variables:**

| Symbol | Description | Unit | Initial Value |
|--------|-------------|------|---------------|
| n_tank | Tank gas moles | mol | 98.47 |
| n_ip | IP volume gas moles | mol | 0.445 |
| n_lungs | Lung gas moles | mol | 0.0624 |
| n_bcd | BCD gas moles | mol | 0.298 |

**Differential Equations:**

```
dn_tank/dt = -n_dot_1st_stage
dn_ip/dt   = n_dot_1st_stage - n_dot_2nd_stage - n_dot_inflate
dn_lungs/dt = n_dot_2nd_stage - n_dot_exhale
dn_bcd/dt  = n_dot_inflate - n_dot_purge - n_dot_oprv    (clamped: dn_bcd/dt ≥ 0 when n_bcd ≤ 0)
```

**Algebraic Equations (flow rates):**

```
P_amb = P_atm + ρ_water × g × x

% First stage
P_target = min(P_tank, P_amb + IP_offset)
n_dot_1st_stage = max(0, (P_target - P_ip) / R_1st)

% Second stage (demand)
n_dot_2nd_stage = max(0, (P_amb - P_lung - P_crack_2nd) / R_2nd)

% Exhale valve
n_dot_exhale = max(0, (P_lung - P_amb - P_crack_exh) / R_exh)

% BCD inflate
n_dot_inflate = cmd_inflate × max(0, (P_ip - P_bcd) / R_inflate)

% BCD purge
n_dot_purge = cmd_purge × max(0, (P_bcd - P_amb + P_dump) / R_purge)

% OPRV
P_gauge_bcd = P_bcd - P_amb
n_dot_oprv = max(0, (P_gauge_bcd - P_crack_oprv) / R_oprv)
```

**Pressure equations:**

```
P_tank = n_tank × R_gas × T / V_tank
P_ip   = n_ip × R_gas × T / V_ip
P_lung = P_amb + breath_effort
P_bcd  = P_amb + max(0, K_wall × (V_free_bcd - V_max))
```

### 5.2 Mechanical (Newton's 2nd Law, Vertical)

**State Variables:**

| Symbol | Description | Unit | Initial Value |
|--------|-------------|------|---------------|
| x | Depth (position) | m | ic.depth |
| v | Velocity | m/s | 0 |

**Differential Equations:**

```
dx/dt = v
m_total × dv/dt = F_gravity + F_body_buoy + F_lung_buoy + F_bcd_buoy + F_drag + F_gas_weight + F_stops
```

**Force terms:**

```
F_gravity    = +m_total × g                          (downward, positive)
F_body_buoy  = -ρ_water × g × V_body                (upward)
F_lung_buoy  = -ρ_water × g × V_lungs               (upward)
F_bcd_buoy   = -ρ_water × g × V_bcd                 (upward)
F_drag       = -0.5 × ρ_water × Cd × A × v × |v|   (opposes motion)
F_gas_weight = +n_tank × M_gas × g                   (downward, decreases over dive)
F_stops      = hard-stop contact forces at x=0 and x=max_depth
```

Where:
```
V_lungs = n_lungs × R_gas × T / P_amb
V_bcd   = min(n_bcd × R_gas × T / P_amb, V_max)
m_total = m_diver + m_weights + m_gear = 89 kg
```

---

## 6. Nonlinearities & Constraints

| Nonlinearity | Type | Location | Parameters | Physical Basis |
|-------------|------|----------|------------|----------------|
| 2nd stage demand valve | Dead zone + one-way | SecondStageRegulator | P_crack = 100 Pa | Cracking pressure of diaphragm spring |
| Exhale valve one-way | Dead zone + one-way | ExhaleValve | P_crack = 50 Pa | Check valve opens only on exhale |
| BCD moles clamp | Saturation (lower) | BCDBladder | n_bcd ≥ 0 | Cannot extract gas that isn't there |
| BCD volume limit | Saturation (upper) | BCDBladder | V_max = 0.015 m³ | Physical bladder capacity |
| BCD wall stiffness | Stiffening spring | BCDBladder | K_wall = 1e7 Pa/m³ | Bladder resists over-inflation |
| OPRV cracking | Dead zone + one-way | OverpressureReliefValve | P_crack = 20684 Pa (3 psi) | Safety valve spring preload |
| Purge dump bias | Offset | PurgeValve | P_dump = 5000 Pa | Hydrostatic head of dump valve location |
| Hard stops | Contact (stiff spring) | Surface/Bottom stops | x ∈ [0, 45] m | Physical boundaries |
| Quadratic drag | Nonlinear damping | DiverBody | Cd=1.1, A=0.12 m² | Turbulent drag (Re > 10⁵) |
| Inflate/purge command clamp | Saturation [0,1] | BCDInflateValve, PurgeValve | — | Valve can only be 0-100% open |

---

## 7. Cross-Cutting Concerns

### 7.1 Numerical Considerations

| Concern | Approach |
|---------|----------|
| **Solver selection** | ode23t — implicit trapezoidal rule, L-stable for stiff DAE; required by Simscape |
| **Stiffness** | Stiff due to fast regulator dynamics (R_open = 1e3) vs slow mechanical (seconds); ode23t handles this |
| **Algebraic loops** | GasVolume at IP node provides algebraic equation separating 1st/2nd stage; prevents singular Jacobian |
| **Zero-crossing detection** | Simscape handles `max(0,...)` and saturation internally; no explicit ZC blocks needed |
| **DAE index** | Index-1 after Simscape auto-reduction; no manual index reduction needed |

### 7.2 Parameter Management

| Approach | Details |
|----------|---------|
| **Storage** | MATLAB base workspace, loaded by `initWorkspace.m` which calls `scuba_params()` |
| **Naming convention** | `category_paramName` — e.g., `tank_V`, `reg2_P_crack`, `bcd_V_max` |
| **Units** | SI throughout; tracked via comments in `load_plant_params.m` |
| **Source of truth** | `parameters/scuba_params.m` shall return complete struct |
| **Flattening** | `scripts/load_plant_params.m` shall unpack struct → individual workspace variables |

### 7.3 Simulation Performance

| Concern | Approach |
|---------|----------|
| **Target speed** | >10× real-time for 36-min dive (target: <3 min wall-clock) |
| **Bottleneck subsystems** | Gas circuit stiffness (fast regulator dynamics) drives small time steps |
| **Optimization opportunities** | Increase R_open on regulators to relax stiffness; reduce max step size tolerance |

---

## 8. Uncertainty & Sensitivity Hooks

| Parameter | Nominal | Range | Subsystem | Rationale for Sweep |
|-----------|---------|-------|-----------|---------------------|
| diver.mass | 80 kg | 60–100 kg | DiverBody | Different diver sizes affect buoyancy balance |
| weightbelt.mass | 4 kg | 2–8 kg | Weights | Weighting strategy directly affects descent/ascent |
| bcd.initMoles | 0.298 mol | 0–0.5 mol | BCDBladder | Starting BCD fill affects initial buoyancy |
| diver.dragCoeff | 1.1 | 0.8–1.5 | DiverBody | Trim quality varies by diver skill (Passmore 2002) |
| secondStage.R_open | 6000 Pa·s/mol | 3000–12000 | SecondStageRegulator | Regulator quality/maintenance |
| breathing.rate | 15 bpm | 10–25 bpm | Controller (harness) | Stress level / exertion |
| tank.startPressure | 200e5 Pa | 150e5–230e5 | GasTank | Partial fill or overfill scenarios |

---

## 9. Key Decisions

| # | Decision | Options Considered | Choice | Rationale |
|---|----------|-------------------|--------|-----------|
| 1 | Gas domain formulation | (a) Mass flow [kg/s], (b) Molar flow [mol/s], (c) Volumetric [m³/s] | (b) Molar | Natural for ideal gas law; moles conserved regardless of pressure; avoids needing density |
| 2 | P_amb computation | (a) Domain-level variable, (b) Each component computes locally | (b) Local | Avoids coupling domain to mechanics; each block is self-contained |
| 3 | Buoyancy force application | (a) Separate BuoyancyForceSource blocks, (b) Each volume component applies own force | (b) Component-local | Reduces block count; co-locates volume and force; simpler wiring |
| 4 | Diver body architecture | (a) Separate mass + buoyancy + drag blocks, (b) Single combined component | (b) Combined | DiverBody encapsulates all three; one translational port; cleaner model |
| 5 | Breathing model | (a) Volume-driven (prescribed V(t)), (b) Pressure-driven (prescribed effort) | (b) Pressure | Physically correct: diver muscles create pressure → gas flows in response |

---

## 10. Known Limitations & Deferred Items

| Item | Description | Rationale for Deferral |
|------|-------------|------------------------|
| Wetsuit compression | Neoprene buoyancy loss with depth not modeled | Parameters exist in scuba_params.m; needs new component or DiverBody extension |
| Gas solubility | No dissolved N₂/O₂ in blood | Purely mechanical model; not needed for buoyancy |
| Regulator free-flow | No failure mode for stuck-open demand valve | Failure analysis out of v1 scope |
| Lung volume limits | No clamping on V_lungs (can go unrealistically large) | Valve resistances tuned to prevent this operationally |
| Non-isothermal expansion | First stage adiabatic cooling not modeled | Effect is transient and small for slow breathing |

---

## Appendix A: Related Documents

- [System Spec](scuba-diver-system.md) — Requirements and operating scenarios
- [Implementation Plan](scuba-diver-implementation-plan.md) — Build phases for new harness
- [Test Plan](scuba-diver-test-plan.md) — Validation maneuvers and criteria
