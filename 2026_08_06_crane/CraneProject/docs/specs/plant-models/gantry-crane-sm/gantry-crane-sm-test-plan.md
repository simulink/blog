# Gantry Crane Simscape Multibody Test Plan

## Status: Draft
Last Updated: 2026-07-31

## Validation Stages

1. Parameter/script tests.
2. Analytical controller/tuning tests.
3. Model generation and compile test.
4. Integrated simulation test.

## Tests

| Test | Acceptance Criteria |
|---|---|
| Parameters load | Positive length, mass, and contact stiffness. |
| LQR gain | Gain is finite and has size 1-by-4. |
| Pump profile | Force profile is finite and respects `forceMax`. |
| Model build | `buildCraneSimscapeModel` creates `models/crane_sm.slx`. |
| Simscape compile | Model compiles without unconnected physical ports. |
| Contact sanity | Contact force is logged and finite. |
| Demo run | `runCraneDemo` simulates to stop time and produces logged signals. |

## Numerical Robustness

After baseline success, compare `ode23t` against one tighter relative tolerance
and one looser tolerance. Results should retain the same qualitative behavior:
no collision in the tuned demo and finite contact force in failed cases.
