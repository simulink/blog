# Dive Controller for fullDiveHarness — Design & Implementation Plan

## Context

`models/fullDiveHarness.slx` wraps the `Scuba_Diver` plant (subsystem reference) but currently drives it with constants (Inflate=0, Purge=0, V_lung=2.75 L), so the diver just sinks until the depth>45 m stop trips. The task: design a 1-hour dive trajectory and a closed-loop controller that flies the diver through it using the three plant inputs — **Inflate BCD (0–1)**, **Purge/Deflate BCD (0–1)**, **V_lung (m³)** — with feedback from the five plant outputs: depth, vel, acc, Fbcd, Vbcd.

**Control philosophy (per user direction):** mimic a real diver. The BCD is touched only during depth changes — feedforward-fill it to a known neutral volume for the target depth, then leave it alone. At constant depth, all fine control comes from **breathing modulation** (shifting mean lung volume). BCD valves stay shut during holds except rare re-trim bursts when breathing authority runs out.

### Plant physics established during exploration

| Item | Value | Source |
|---|---|---|
| Body net buoyancy | +25.6 N (V=0.065 m³, ρ_body=985) | `+scuba/DiverBody.ssc` |
| Weights | 4 kg → −39.2 N | Mass PB block in `Scuba_Diver.slx` |
| Tank gas weight | 98.47 mol × 0.029 kg/mol → −28 N at start, decays with consumption | Gas Tank block |
| Lung buoyancy | ρg·V_lung → +27.7 N at 2.75 L; ±0.75 L trim ⇒ **±7.7 N breathing authority** | `Lungs.ssc` |
| BCD buoyancy | ρg·Vbcd, bladder max 15 L (+150 N) | `BCDBladder.ssc` |
| **Net, empty BCD, start** | **≈ −14 N (sinks)**; **V_bcd ≈ 1.39 L for neutral** at mean lung volume | computed |
| Inflate valve | `n_dot = cmd·ΔP/2e4`, ΔP ≈ 10 bar (IP offset) → **~50 mol/s at cmd=1 — enormous gain; cmd must stay ≪ 1** | `BCDInflateValve.ssc`, 1st-stage IP_offset=10e5 Pa |
| Purge valve | `n_dot = cmd·(P_bcd−P_amb+5000)/1e4` ≈ 0.5 mol/s max, one-way | `PurgeValve.ssc` |
| Harness | initial depth 0.5 m; Stop Simulation when depth<0.1 or >45 m; StopTime=3900 s; ode23t | `fullDiveHarness.slx` |

Key dynamics:
- The plant is **open-loop unstable in depth** (Boyle effect — descend → bladder compresses → buoyancy drops → sink faster), so feedback is mandatory; but a **volume servo on Vbcd inherently neutralizes the Boyle instability** — holding the bladder *volume* constant makes buoyancy depth-independent.
- **Neutral V_bcd is depth-independent in this plant** (no wetsuit compression modeled): the volume needed for zero net force is the same at every depth; only the *moles* required to hold it change. The depth→V_bcd feedforward table will therefore be nearly flat today, but the structure directly supports wetsuit compression later (which makes it genuinely depth-dependent) and makes the diver-like behavior explicit: add air on descent, vent on ascent, to keep bladder volume at the neutral value.
- Tank depletion (~28 N over the dive, ≈0.5 N/min) is a slow disturbance: breathing trim absorbs it between occasional BCD re-trims.
- Terminal sink rate with empty BCD ≈ 0.45 m/s (27 m/min).

### How real divers do it (web research)
- Descent ≤ ~18 m/min; ascent ≤ 9–10 m/min (30 ft/min); 3–5 min safety stop at 5 m.
- BCD used in short bursts during depth changes to re-establish neutral trim; **breath control (lung volume) for all fine adjustments (<1 m)** around neutral buoyancy. Properly trimmed divers rarely touch the inflator at constant depth.

Sources: [DAN ascent rates](https://dan.org/alert-diver/article/ascent-rates/), [PADI safety stop history](https://blog.padi.com/history-of-the-safety-stop/), [buoyancy technique](https://www.scoobadiveguide.com/scuba-diving-tips-improve-buoyancy-control/), [scuba-tutor BCD use](https://scuba-tutor.com/diving-skills/bcd/), [breath control](http://divewithmia.com/part-1-bcd-air-inflationdeflation-and-buoyancy-a-balancing-act).

### User decisions
- **Profile:** multilevel 18 m → 12 m (typical recreational dive).
- **Implementation:** standard blocks + one MATLAB Function for valve allocation (no Stateflow).
- **BCD used sparingly:** feedforward depth→V_bcd lookup table; breathing modulation is the primary controller at constant depth.

---

## 1. Dive trajectory (time → depth reference)

1-D Lookup Table driven by a Clock, linear interpolation, followed by a Rate Limiter (rising ≤ 0.3 m/s descent, falling ≤ 0.15 m/s ascent). Breakpoints (t in s, depth in m):

| Phase | t (min) | depth |
|---|---|---|
| Start | 0 | 0.5 |
| Descent (~9 m/min) | 0 → 2 | 0.5 → 18 |
| Bottom 1 | 2 → 25 | 18 |
| Step up (~3 m/min) | 25 → 27 | 18 → 12 |
| Bottom 2 (multilevel) | 27 → 45 | 12 |
| Ascent (~2.3 m/min ≤ 9 m/min limit) | 45 → 48 | 12 → 5 |
| Safety stop | 48 → 53 | 5 |
| Final slow ascent (~1 m/min) | 53 → 58 | 5 → 0 |

The run ends naturally at ~58 min when depth < 0.1 m trips the existing Stop Simulation logic. A second lookup table holds the profile slope (piecewise-constant **v_ff**, desired velocity feedforward), avoiding a Derivative block. v_ff ≠ 0 also serves as the **"transition phase" flag** that arms the BCD.

## 2. Controller architecture — feedforward BCD + breathing-primary feedback

All inside a new **`Dive Controller`** subsystem in `fullDiveHarness.slx`, replacing the three constants:

```
Clock ─→ [Lookup: depth_ref] ─→ Rate Limiter ─→ depth_ref
      └→ [Lookup: v_ff]

── BCD path (coarse, active only in transitions / rare re-trims) ──
[Lookup: depth_ref → V_bcd_neutral]  (feedforward table, calibrated)
V_bcd_ref = V_bcd_neutral(depth_ref)
          + K_vff·v_ff                     (descent bias: less volume going down,
                                            more going up; zero during holds)
          + V_trim_slow                    (slow integrator, see re-trim logic)
[MATLAB Fcn valveAllocation]: e_V = V_bcd_ref − Vbcd
   armed  when  |v_ff| > 0  OR  |depth_ref − depth| > 1 m  OR  re-trim burst requested
   deadband ±0.15 L; inflate = sat(k_inf·e_V, 0, ~0.01); deflate = sat(−k_def·e_V, 0, 1)
   disarmed → both outputs exactly 0 (valves shut through entire holds)

── Breathing path (fine, primary controller at constant depth) ──
trim = −(Kp_b·(depth − depth_ref) + Kd_b·vel)        (PD; deeper than ref → inhale more)
trim saturated to ±0.75e-3 m³
V_lung = V_mean(2.75e-3) + trim + (0.25e-3)·sin(2π·0.2·t)   (12 breaths/min, 0.5 L tidal)
V_lung saturated to [1.5e-3, 4.5e-3] m³

── Re-trim logic (inside valveAllocation MATLAB Fcn) ──
If breathing trim stays > 80 % saturated for > 15 s during a hold
(tank getting lighter, or table miscalibration), integrate V_trim_slow a small step
and request a short BCD burst to re-center the trim — then go silent again.
```

### Why this is stable without a continuous BCD loop
During a hold, the BCD servo has already placed Vbcd at (near-)neutral volume; bladder volume is constant while valves are shut only if depth is constant — and depth is held by the breathing PD loop, whose ±7.7 N authority dominates residual trim errors (deadband ±0.15 L ⇒ ≤ ±1.5 N residual; depletion ≈ 0.5 N/min accumulates slowly). If depth drifts despite breathing (trim saturated), the re-trim logic fires one burst. The Boyle instability only matters when depth moves ≥ metres — exactly when the BCD servo is armed.

### Feedforward table calibration
`V_bcd_neutral(depth)` computed analytically in `scripts/initDiveController.m` from the force balance at mean lung volume:
`V_bcd_neutral = (m_weights·g + n_tank0·M_gas·g − F_body_net − ρg·V_mean) / (ρg)` ≈ 1.39e-3 m³, tabulated over depth breakpoints [0 … 45] m (flat today; placeholder for wetsuit compression). Verify/adjust by simulation trim runs at fixed depths if the analytic value leaves a residual.

### valveAllocation (MATLAB Function block)
Inputs: `V_bcd_ref`, `Vbcd`, `v_ff`, `depth_err`, `trim` (breathing trim, for saturation detection), clock. Outputs: `inflate`, `deflate`, `V_trim_slow` (fed back via Unit Delay or kept as persistent). Discrete logic (arming, burst timer, slow integrator) uses persistent variables; block sample time small but discrete (e.g. 0.1 s) so ode23t doesn't chatter on the switching.
- Never inflate and deflate simultaneously.
- `inf_max ≈ 0.01`: the inflate valve passes ~50 mol/s at cmd=1 (ΔP≈10 bar), so commands must be scaled way down for realistic ~L/s fill rates. Purge authority is much lower; deflate may use full 0–1.

### Initial gain estimates (tune in simulation)
- Breathing PD: Kp_b ≈ 1.5e-3 m³/m, Kd_b ≈ 3e-3 m³/(m/s) (velocity damping is what stabilizes the loop).
- K_vff ≈ 1e-3 m³/(m/s) (≈1 L extra vent at full 0.15 m/s ascent bias — small).
- Valve servo: k_inf ≈ 5 (cmd per m³ error, capped 0.01), k_def ≈ 300.
- Re-trim: step V_trim_slow by 0.1e-3 m³ per event.

## 3. Simulink implementation steps (all edits via `model_edit` on `fullDiveHarness.slx`)

1. **Create `Dive Trajectory` subsystem** (root): Clock → two 1-D Lookup Tables (depth_ref, v_ff) → Rate Limiter on depth_ref. Outputs: `depth_ref`, `v_ff`.
2. **Create `Dive Controller` subsystem** (root): inputs `depth_ref, v_ff, depth, vel, acc, Vbcd, Fbcd`; outputs `Inflate, Deflate, V_lung`.
   - 1-D Lookup Table `V_bcd_neutral(depth_ref)` + Gain(K_vff)·v_ff + Sum → V_bcd_ref, saturated [0, 15e-3] m³.
   - MATLAB Function block `valveAllocation` as in §2 (discrete sample time 0.1 s).
   - Breathing path: Sum/Gain (PD) → Saturation(±0.75e-3) → Sum with V_mean constant and Sine Wave → Saturation [1.5e-3, 4.5e-3] → V_lung.
3. **Rewire harness root**: delete the three Constant blocks (blk_124, blk_125, blk_122); connect Scuba Diver outputs depth/vel/acc/Vbcd/Fbcd to the controller, controller outputs to Inflate_BCD/Purge_BCD/V_lung. Keep existing stop logic and scopes; add scopes/To Workspace for depth vs depth_ref, Vbcd vs V_bcd_ref, valve commands, V_lung/trim.
4. **Parameters**: profile breakpoints, feedforward table, and gains defined as workspace variables in a new `scripts/initDiveController.m` (could later migrate into `data/scubaParams.sldd`).
5. **Validate structure**: `model_check` (unconnected ports/lines) on the harness.

## 4. Verification

1. **Run the full dive**: `sim('fullDiveHarness')` (or Play). Success criteria:
   - Depth tracks the profile: |depth − depth_ref| < 1 m during holds; no stop-condition trip before ~57 min; sim ends via surface stop (~58 min) or StopTime.
   - Ascent ≤ 0.15 m/s sustained; descent ≤ 0.3 m/s.
   - Safety stop held at 5 ± 1 m for 3+ min.
   - **Diver-realism criterion: BCD valves closed (both commands = 0) for > 95 % of each constant-depth hold**; breathing trim visibly doing the fine control; only occasional short re-trim bursts as the tank lightens.
   - Never inflate and deflate simultaneously; Vbcd within [0, 15 L]; V_lung within [1.5, 4.5] L.
2. **Plot results**: depth vs ref, vel, Vbcd vs V_bcd_ref, inflate/deflate commands, V_lung and trim over the hour. Expect: inflate bursts during descent (Boyle), deflate bursts during ascents, silence during holds; breathing trim slowly drifting positive-to-negative as the tank lightens between re-trims.
3. **Robustness spot-checks**: rerun with ±1 kg on Weights — feedforward table is now wrong; confirm re-trim logic converges and holds still work (breathing + occasional bursts).
4. If ode23t struggles with valve switching, smooth the burst edges (first-order filter τ≈0.5 s on commands) — the discrete 0.1 s MATLAB Fcn should already prevent chattering.

## Files touched

| File | Change |
|---|---|
| `models/fullDiveHarness.slx` | Add `Dive Trajectory` + `Dive Controller` subsystems, rewire root (already has uncommitted modifications — build on current state, don't revert) |
| `scripts/initDiveController.m` | New — profile breakpoints, feedforward V_bcd table, controller gains, breathing params |
| `models/Scuba_Diver.slx` | **No changes** (plant untouched) |

## Out of scope
- No changes to Simscape components or the plant model.
- No Stateflow (per user choice); no test-suite work; no dashboard.

---

## As-built notes (implementation deltas)

1. **Inflate valve gain**: the model instance uses `R_open = 5e6 Pa·s/mol` (not the 2e4 default in `BCDInflateValve.ssc`), so cmd=1 gives ~0.2 mol/s (~1.7 L/s at 18 m) — already realistic inflator flow. Allocation uses the full range: `k_inf = 300`, `inf_max = 0.6`, `k_def = 300`.
2. **Lung dynamics lag**: first-order lag (`tau_lung = 0.5 s`, integrator-based with IC = V_mean) between the breathing sum and the V_lung output. Physically motivated (lung volume can't step) and required — it breaks the algebraic loop between the volume-commanded Lungs component and the plant outputs.
3. **Memory blocks on valve commands**: the Simscape DAE reports direct feedthrough from valve commands to outputs, which formed an algebraic loop through the discrete MATLAB Function. Two Memory blocks on inflate/deflate outputs break it.
4. **Re-trim detection filters the trim signal**: raw `trim_frac` oscillates with tidal breathing and kept resetting the saturation timer. The MATLAB Function low-passes it (tau 5 s), triggers at |trimF| > 0.6 sustained 15 s, steps `V_trim_slow` by 0.2 mL (> deadband so the burst acts), valve window 5 s.
5. **Model InitFcn** = `initDiveController` so parameters load automatically.

## Verification results (nominal run)

- Dive completes: surfaces at 57.6 min via the depth < 0.1 m stop; max depth 18.32 m (0.32 m descent overshoot).
- Hold tracking |err|: 18 m mean 0.08 / max 0.19 m; 12 m mean 0.25 / max 0.34 m; 5 m stop mean 0.20 / max 0.41 m.
- Rates: max descent 0.21 m/s (≤ 0.3), max ascent 0.11 m/s (≤ 0.15).
- **BCD valves closed ≥ 99% of every hold** (duty 0 / 0.29 / 0.83 %); never inflate+deflate simultaneously; fine control visibly carried by breathing (V_lung mean drifts down as tank lightens, reset by occasional re-trim bursts at ~36 and ~48 min).
- Vbcd 0.02–1.63 L; V_lung 1.79–3.62 L (within physiological limits).
- Robustness: with the feedforward table deliberately 0.5 L lean, the dive still completes with 18 m hold error mean 0.09 m.
