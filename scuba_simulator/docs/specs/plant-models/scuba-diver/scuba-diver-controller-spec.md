# Scuba Diver Closed-Loop Controller Specification

## Status: Proposed
**Last Updated:** 2026-06-30  
**Author:** Gemini CLI  
**Parent Specs:** [System Spec](scuba-diver-system.md), [Architecture Spec](scuba-diver-architecture.md)

---

## 1. Executive Summary

This document specifies the design, state logic, and parameterization of the closed-loop controller for the `fullDiveHarness.slx` simulation model. The goal of this model is to simulate a full **1-hour vertical dive** where the diver's depth is regulated through a coordinated dual-loop controller implemented entirely in Stateflow:
1. **Coarse Depth Controller (BCD)**: Infrequent inflation and purging of the BCD to handle large depth transitions (descent, ascent, and massive drifts).
2. **Fine Depth Controller (Lungs/Breathing)**: Continuous, breath-by-breath lung volume adjustment by modulating a 4-phase rectangular breathing waveform (Inhale, Inhale Hold, Exhale, Exhale Hold) to maintain stable buoyancy without BCD activity.

To match physical reality and the requested operational profile, the simulation **skips the surface prep phase** and starts directly with the **descent** phase at $t=0$, with the **BCD completely empty** (0 initial moles). All control parameters are mapped to workspace variables, making them fully tunable for future optimization.

---

## 2. Dynamic Control Hierarchy

The closed-loop architecture consists of the **Supervisory Dive Controller** and the **Breathing Controller**, both implemented in Stateflow.

```
                               ┌────────────────────────────────────────────────────────┐
                               │             Supervisory Dive Controller                │
                               │                   (Stateflow)                          │
                               │                                                        │
                      ┌────────┼─► Current State: DESCENT | BOTTOM_HOLD | ASCEND...     │
                      │        │                                                        │
                      │        │   [ BCD Control Logic ]                                │
                      │        │   - Descends naturally (initially empty BCD)           │
                      │        │   - BCD brake pulses if vel > max_descent_rate         │
                      │        │   - BCD neutral burst near target depth                │
                      │        │   - Large drift corrections on hold (> deadband)       │
                      │        │   - Preemptive Boyle-venting during ascent             │
                      │        │                                                        │
                      │        │   Outputs: inflate_cmd, purge_cmd, depth_target        │
                      │        └────────────┬─────────────┬─────────────┬───────────────┘
                      │                     │             │             │
                      │         depth_target│             │             │
                      │                     ▼             │             │
                      │        ┌────────────────────────┐ │             │
                      │        │  Breathing Controller  │ │             │
                      │        │      (Stateflow)       │ │             │
                      │        │                        │ │             │
                      │        │  Modulates 4-phase:    │ │             │
                      │        │  Inhale -> Hold ->     │ │             │
                      │        │  Exhale -> Hold        │ │             │
                      │        │                        │ │             │
                      │        │  Outputs: breath_effort│ │             │
                      │        └────────────┬───────────┘ │             │
                      │                     │             │             │
                      │        breath_effort│  inflate_cmd│    purge_cmd│
                      │                     ▼             ▼             ▼
               ┌──────┴─────────────────────────────────────────────────────────────────┐
               │                               Scuba_Diver Plant                        │
               │                                                                        │
               │    Inputs:  1. inflate_cmd, 2. purge_cmd, 3. breath_effort            │
               │    Outputs: 1. depth [m],   2. velocity [m/s]                          │
               └────────────────────────────┬───────────────────────────────────────────┘
                                            │
                                            └─ depth, velocity
```

---

## 3. Supervisory Controller (BCD & Dive Profile)

The Supervisory Controller runs as a Stateflow chart. It calculates the active `depth_target` as a ramp over time, monitors diving constraints, and outputs BCD control actions (`inflate_cmd` and `purge_cmd`).

### 3.1 Dive Profile Timeline (65 Minutes Total)

The dive profile skips the surface phase and begins descent immediately at $t=0$ with an empty BCD:

| Chronological State | Start Time | End Time | Target Depth / Ramp | BCD Behavior |
|---------------------|------------|----------|---------------------|--------------|
| **1. `DESCENT`** | $t = 0\text{ s}$ | $t = 120\text{ s}$ | Ramps $0\text{ m} \rightarrow 20\text{ m}$ @ $10\text{ m/min}$ | Purge is $0$. If sinking rate exceeds limit, apply BCD braking. Near bottom, apply a one-time neutral-offset burst. |
| **2. `BOTTOM_HOLD`** | $t = 120\text{ s}$ | $t = 3120\text{ s}$ | $20.0\text{ m}$ (constant) | BCD remains completely idle ($0$) unless depth drifts beyond the BCD deadband ($\pm 2.0\text{ m}$). |
| **3. `ASCEND`** | $t = 3120\text{ s}$ | $t = 3300\text{ s}$ | Ramps $20\text{ m} \rightarrow 5\text{ m}$ @ $5\text{ m/min}$ | Purges BCD preemptively to vent expanding gas. Purges fully if ascent velocity exceeds safety limits. |
| **4. `SAFETY_STOP`** | $t = 3300\text{ s}$ | $t = 3600\text{ s}$ | $5.0\text{ m}$ (constant) | BCD idle. Re-establishes neutral buoyancy via BCD, then relies on breathing fine-control. |
| **5. `FINAL_ASCENT`** | $t = 3600\text{ s}$ | $t = 3750\text{ s}$ | Ramps $5\text{ m} \rightarrow 1\text{ m}$ @ $1.6\text{ m/min}$ | Purges BCD preemptively to maintain slow, safe rate. |
| **6. `SURFACED`** | $t \ge 3750\text{ s}$ | End | $1.0\text{ m}$ (constant) | Keep BCD fully inflated to float safely on surface. |

---

### 3.2 Tunable Supervisory Control Logic & Parameters

All BCD control parameters are loaded into the MATLAB workspace and can be modified for future optimization:

| Workspace Variable | Nominal Value | Description |
|-------------------|---------------|-------------|
| `ctrl_max_descent_rate` | $0.5\text{ m/s}$ ($30\text{ m/min}$) | Speed limit for sinking |
| `ctrl_max_ascent_rate` | $0.167\text{ m/s}$ ($10\text{ m/min}$) | Speed limit for ascending |
| `ctrl_K_brake` | $10.0\text{ s/m}$ | Proportional gain for BCD braking during descent |
| `ctrl_K_p` | $2.0\text{ 1/m}$ | Proportional BCD gain during hold if drift exceeds deadband |
| `ctrl_K_ascent` | $0.5\text{ (dimensionless)}$ | Preemptive purging gain during ascents |
| `ctrl_bcd_deadband` | $2.0\text{ m}$ | Allowable depth deviation during holds before BCD is triggered |
| `ctrl_bottom_depth` | $20.0\text{ m}$ | Target bottom depth |
| `ctrl_safety_depth` | $5.0\text{ m}$ | Target safety stop depth |
| `ctrl_ascent_rate` | $0.083\text{ m/s}$ ($5\text{ m/min}$) | Standard ascent rate |
| `ctrl_descent_rate` | $0.167\text{ m/s}$ ($10\text{ m/min}$) | Standard descent rate |
| `ctrl_neutral_burst_duration` | $3.5\text{ s}$ | Duration of the initial inflation burst upon reaching bottom |

#### Descent Braking Formulation
During descent, the BCD is initially empty. The diver sinks naturally under gravity:
$$\text{If } \text{velocity} > \text{ctrl\_max\_descent\_rate}: \quad \text{inflate\_cmd} = \text{ctrl\_K\_brake} \cdot (\text{velocity} - \text{ctrl\_max\_descent\_rate})$$

#### Neutral Buoyancy Arrest
When the target depth is within $2.0\text{ m}$ of the bottom ($18\text{ m}$ during descent), the BCD is inflated for `ctrl_neutral_burst_duration` to arrest the descent and establish initial neutral buoyancy.

#### BCD Deadband Enforcer (During Holds)
During `BOTTOM_HOLD` and `SAFETY_STOP`:
$$\text{depth\_error} = \text{depth\_target} - \text{depth}$$
$$\begin{cases} 
\text{purge\_cmd} = \text{ctrl\_K\_p} \cdot (\text{depth\_error} - \text{ctrl\_bcd\_deadband}), & \text{if } \text{depth\_error} > \text{ctrl\_bcd\_deadband} \quad (\text{Too Deep}) \\
\text{inflate\_cmd} = \text{ctrl\_K\_p} \cdot (|\text{depth\_error}| - \text{ctrl\_bcd\_deadband}), & \text{if } \text{depth\_error} < -\text{ctrl\_bcd\_deadband} \quad (\text{Too Shallow}) \\
\text{inflate\_cmd} = 0, \quad \text{purge\_cmd} = 0, & \text{otherwise}
\end{cases}$$

#### Ascent Venting Formulation
During `ASCEND` and `FINAL_ASCENT`:
$$\text{purge\_cmd} = \text{ctrl\_K\_ascent} \cdot \max(0, -\text{velocity})$$
$$\text{If } |\text{velocity}| > \text{ctrl\_max\_ascent\_rate}: \quad \text{purge\_cmd} = 1.0 \quad (\text{Emergency Dump})$$

---

## 4. Fine-Control Breathing Generator (Stateflow)

The Breathing Generator is implemented as a secondary Stateflow chart. It uses a **four-phase rectangular waveform** with **timing and pressure-amplitude modulation** driven by the diver's depth error.

### 4.1 Nominally Symmetric 8-Second Breathing Cycle ($T_0 = 8\text{ s}$ / $7.5\text{ bpm}$)

The state machine cycles through four states sequentially:

```
  ┌─────────┐   after(t_inh, sec)   ┌──────────────┐
  │ Inhale  ├──────────────────────►│ Inhale Hold  │
  └────┬────┘                       └──────┬───────┘
       ▲                                   │ after(t_ihld, sec)
       │ after(t_ehld, sec)                ▼
  ┌────┴───────┐                    ┌──────────────┐
  │Exhale Hold │◄───────────────────┤    Exhale    │
  └────────────┘ after(t_exh, sec)  └──────────────┘
```

1.  **`Inhale`**: `breath_effort = -A_inhale` (suction draws gas from regulator).
2.  **`Inhale Hold`**: `breath_effort = 0` (lungs are fully expanded; maximum buoyancy).
3.  **`Exhale`**: `breath_effort = +A_exhale` (positive pressure vents gas to ambient).
4.  **`Exhale Hold`**: `breath_effort = 0` (lungs are at residual volume; minimum buoyancy).

---

### 4.2 Workspace Tunable Breathing Controller Parameters

| Workspace Variable | Nominal Value | Description |
|-------------------|---------------|-------------|
| `bc_base_rate` | $7.5\text{ bpm}$ | Base breathing frequency (defines base period $T_0 = 8.0\text{ s}$) |
| `bc_t_inh_0` | $3.0\text{ s}$ | Nominal inhalation phase duration |
| `bc_t_ihld_0` | $1.0\text{ s}$ | Nominal inhalation hold phase duration |
| `bc_t_exh_0` | $3.0\text{ s}$ | Nominal exhalation phase duration |
| `bc_t_ehld_0` | $1.0\text{ s}$ | Nominal exhalation hold phase duration |
| `bc_A_base` | $200.0\text{ Pa}$ | Peak respiratory muscular effort at surface |
| `bc_deadzone` | $0.3\text{ m}$ | Width of depth error deadband (no breathing modulation below this) |
| `bc_saturation` | $1.5\text{ m}$ | Position error at which breathing modulation saturates at $\pm 1.0$ |
| `bc_K_vel` | $0.8\text{ s/m}$ | Velocity damping coefficient to prevent depth overshoot / "yo-yo" |
| `bc_duty_shift_inh` | $0.20$ | Maximum relative increase in inhalation duration |
| `bc_duty_shift_exh` | $0.20$ | Maximum relative increase in exhalation duration |
| `bc_hold_shift_max` | $2.0\text{ s}$ | Maximum expansion of the breath-hold phases |
| `bc_amplitude_gain` | $0.30$ | Maximum breathing effort adjustment ($\pm 30\%$) |

---

### 4.3 Phase Duration Modulation Logic

The input `bias` is calculated dynamically to stabilize depth with damping:
$$\text{bias\_input} = (\text{depth} - \text{depth\_target}) + \text{bc\_K\_vel} \cdot \text{velocity}$$
$$\text{bias} = \text{deadzone\_and\_saturate}(\text{bias\_input}, \text{bc\_deadzone}, \text{bc\_saturation})$$

On each entry to a state, the timing threshold is calculated based on `bias` ($\in [-1, 1]$):

#### When Diver is Too Deep ($\text{bias} > 0$):
The controller extends the inhale and inhale-hold durations, while reducing exhale and exhale-hold durations:
*   **Inhale Duration ($t_{inh}$):**
    $$t_{inh} = \text{bc\_t\_inh\_0} \cdot (1 + \text{bc\_duty\_shift\_inh} \cdot \text{bias})$$
*   **Inhale Hold Duration ($t_{ihld}$):**
    $$t_{ihld} = \text{bc\_t\_ihld\_0} + \text{bc\_hold\_shift\_max} \cdot \text{bias}$$
*   **Exhale Duration ($t_{exh}$):**
    $$t_{exh} = \text{bc\_t\_exh\_0} \cdot (1 - 0.1 \cdot \text{bias})$$
*   **Exhale Hold Duration ($t_{ehld}$):**
    $$t_{ehld} = \max(0.1, \, \text{bc\_t\_ehld\_0} - 0.9 \cdot \text{bias})$$

#### When Diver is Too Shallow ($\text{bias} < 0$):
The controller shrinks the inhale and inhale-hold durations, while extending exhale and exhale-hold durations:
*   **Inhale Duration ($t_{inh}$):**
    $$t_{inh} = \text{bc\_t\_inh\_0} \cdot (1 - 0.1 \cdot |\text{bias}|)$$
*   **Inhale Hold Duration ($t_{ihld}$):**
    $$t_{ihld} = \max(0.1, \, \text{bc\_t\_ihld\_0} - 0.9 \cdot |\text{bias}|)$$
*   **Exhale Duration ($t_{exh}$):**
    $$t_{exh} = \text{bc\_t\_exh\_0} \cdot (1 + \text{bc\_duty\_shift\_exh} \cdot |\text{bias}|)$$
*   **Exhale Hold Duration ($t_{ehld}$):**
    $$t_{ehld} = \text{bc\_t\_ehld\_0} + \text{bc\_hold\_shift\_max} \cdot |\text{bias}|$$

---

### 4.4 Amplitude Modulation Logic

To assist the volume shift, the muscle pressures applied during active breathing phases are modulated by the same `bias` and scaled by ambient pressure to reflect the rising gas density at depth:

*   **Inhale Pressure Amplitude ($A_{inh}$):**
    $$A_{inh} = \text{bc\_A\_base} \cdot (1 + \text{bc\_amplitude\_gain} \cdot \text{bias}) \cdot \left(1 + \frac{\text{depth}}{40}\right)$$
*   **Exhale Pressure Amplitude ($A_{exh}$):**
    $$A_{exh} = \text{bc\_A\_base} \cdot (1 - \text{bc\_amplitude\_gain} \cdot \text{bias}) \cdot \left(1 + \frac{\text{depth}}{40}\right)$$

---

## 5. Summary of Verification Metrics

To demonstrate that the Stateflow closed-loop controller behaves correctly:
1.  **Skip Surface & BCD Empty:** At $t=0$, the diver must start at `depth = 0.0` with the BCD state variable `bcd_n` at $\approx 0$.
2.  **Autonomous Sinking:** The diver must sink naturally. The BCD must remain deflated (`inflate_cmd = 0`) unless velocity exceeds `ctrl_max_descent_rate` ($0.5\text{ m/s}$).
3.  **Descent Arrest:** Near $20\text{ m}$, the BCD must fire a short inflation burst of duration `ctrl_neutral_burst_duration` ($3.5\text{ s}$) to slow descent and establish approximate neutral buoyancy.
4.  **Quiet BCD during Bottom Time:** During the $50$-minute bottom time, BCD activity (`inflate_cmd` and `purge_cmd`) must be **zero for $>95\%$ of the duration**, indicating that the breathing-bias Stateflow controller is successfully maintaining depth.
5.  **Steady Depth Hold:** The depth tracking error during bottom time must be **$< \pm 0.5\text{ m}$**.
6.  **Controlled Ascent:** During ascent, the BCD must vent expanding gas continuously to keep velocity strictly below the safety limit of $10\text{ m/min}$ ($0.167\text{ m/s}$).
