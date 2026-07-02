# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

1D vertical scuba diver buoyancy simulation in Simulink/Simscape. Models breath-by-breath gas consumption through realistic equipment topology (tank → regulators → lungs/BCD → water) using a custom Simscape gas domain with conserving physical connections.

MATLAB R2026a. Requires Simulink, Simscape, Stateflow.

## Common Commands

All commands run in MATLAB (use MCP matlab tools or `! matlab -batch "..."` for CLI):

- **Build Simscape library** (after any `.ssc` change): `sscbuild('scuba','-output','models')`
- **Load workspace parameters**: `initWorkspace` (also runs on project open)
- **Run harness simulation**: open `models/descent_test.slx` and click Play
- **Run open-loop simulation**: `run('scripts/run_simulation.m')`
- **Plot results**: `plot_results(out)`

## Architecture

### Layers

| Layer | Technology | Role |
|-------|-----------|------|
| Plant — Gas | Custom Simscape domain (`+scuba/+gas/`) | Physical gas flow: tank, regulators, lungs, BCD, valves |
| Plant — Mechanical | Simscape Translational (position-based, β=90°) | 1-DOF vertical motion, buoyancy, drag |
| Control | Stateflow chart | Depth controller commands inflate/purge/breath |

### Custom Gas Domain (`+scuba/+gas/underwaterGas.ssc`)

- Across variable: pressure (Pa)
- Through variable: molar flow rate (mol/s)
- Domain parameters: R_gas, T (isothermal assumption)
- P_amb is computed locally by each component from translational port position (`R.x`)

### Primary Model (`models/descent_test.slx`)

Test harness that wraps the `Plant` subsystem (also saved as `models/Scuba_Diver.slx`):
```
root
├── Desired Depth (Constant)
├── Chart (Stateflow) — depth controller outputting inflateBCD, purgeBCD, Breath
├── Plant/
│   ├── Gas Tank, First Stage Regulator, Hose Volume (GasVolume)
│   ├── Regulator/ — SecondStageReg, Lungs, ExhaleValve
│   ├── BCD/ — InflateValve, OPRV, PurgeValve, BCD Bladder
│   ├── AmbientRef — pressure sink at depth
│   ├── Diver Body — combined mass + buoyancy + drag
│   ├── Weights (Mass PB), Surface and Bottom (hard stops)
│   ├── Initial Depth, MechProps, Translational World
│   └── MotionSensor → depth, vel outputs
├── Stop Simulation (depth < 0.1 or > 45)
└── Scopes (Depth, Vel, BCD commands)
```

### Reusable Plant (`models/Scuba_Diver.slx`)

Same content as `Plant` subsystem: 3 inports (Inflate BCD, Purge BCD, Breath), 2 outports (depth, vel). Can be used as a Model Reference or standalone.

### Parameter Flow

`parameters/scuba_params.m` (single source of truth) → `scripts/load_plant_params.m` (flattens struct into named workspace variables) → `scripts/initWorkspace.m` calls both on project open.

## Key Design Decisions

- Gas flow is driven by **pressure differentials**, not command signals. The 2nd stage regulator opens physically when breathing effort creates suction.
- **No deprecated `function setup`** in Simscape — uses `{value = param, priority = priority.high}` for state init, `intermediates` for derived quantities.
- **P_amb computed locally** — each component that needs ambient pressure has a translational port (`R`) and computes `P_amb = P_atm + rho_water * R.gravity * R.x`. No domain-level `p_amb` variable.
- **DiverBody** — single component combining mass, Archimedes buoyancy, and quadratic drag via one translational port. Replaces the earlier 3-block decomposition (AmbientPressure + BuoyancyForceSource + HydrodynamicDrag).
- **Lungs and BCDBladder produce buoyancy force** — each has a translational port and applies `F_buoy = rho_water * g * V` directly. No separate coupling block needed.
- **GasTank applies gas weight** — force = `n_tank * M_gas * g` through translational port.
- **OPRV (Overpressure Relief Valve)** — passive dump valve in BCD circuit cracks at 3 psi gauge.
- **Surface and Bottom hard stops** — spacer + hard-stop pairs limit travel to [0, max_depth].
- **Stateflow depth controller** — simple state machine (drop → float → done) in harness; replaces the earlier two-tier MATLAB Function block approach.

## Numerical Gotchas

- IP node needs a GasVolume (Hose Volume, 100mL) between regulators to avoid singular matrix
- 2nd stage flow uses demand-proportional formulation: `(P_amb - P_lung - P_crack) / R_open`
- BCDBladder clamps moles to non-negative to prevent unphysical reverse depletion
- Solver: ode23t

## File Organization

- `+scuba/` — Simscape component source (`.ssc` files + SVG icons)
  - `+gas/underwaterGas.ssc` — domain definition
  - `+gas/branch.ssc` — unused base class (candidate for removal)
  - `+gas/+elements/` — gas components (14 files, 2 unused: IdealMolarFlowSource, IdealPressureSource)
  - `DiverBody.ssc` — combined mass/buoyancy/drag
- `models/` — `descent_test.slx` (harness), `Scuba_Diver.slx` (plant), `scuba_lib.slx` (compiled library)
- `parameters/` — `scuba_params.m` (master), `gas_properties.m`, `diver_configs.m`
- `scripts/` — `rebuildScubaLib.m`, `run_simulation.m`, `plot_results.m`, `load_plant_params.m`, etc.
- `scuba-buyancy.prj` — MATLAB project file
