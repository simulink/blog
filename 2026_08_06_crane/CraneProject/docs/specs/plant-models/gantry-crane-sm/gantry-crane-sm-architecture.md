# Gantry Crane Simscape Multibody Architecture

## Status: Draft
Last Updated: 2026-07-31

## Overview

The model is a single Simscape Multibody plant driven by a Simulink force
profile. The default prismatic joint translates on its local Z axis, so the
model uses global Z as the horizontal travel coordinate and global Y as
vertical height.

## Subsystem Diagram

```text
forceCmd -> Saturation -> Simulink-PS -> Prismatic Joint
                                      |
World/Gravity -> Trolley -> Revolute Joint -> Payload
                                      |
Wall Frame -------------------- Planar Contact Force

Joint/transform/contact sensors -> PS-Simulink -> To Workspace
```

## Component Catalog

| Component | Domain | States | Ports |
|---|---|---|---|
| Trolley Prismatic Joint | Multibody | x, xdot | Force input, base/follower frames, position/velocity sensors |
| Pendulum Revolute Joint | Multibody | theta, omega | Base/follower frames, angle/rate sensors |
| Payload Solid | Multibody | Rigid body | Payload frame |
| Wall Solid | Multibody | Fixed body | Visual wall frame |
| Planar Contact Force | Multibody | Algebraic/contact mode | Payload frame, wall frame, contact sensors |
| Transform Sensor | Multibody | None | World frame, payload frame, y/z outputs |

## Key Equations

The Simscape Multibody plant solves the constrained rigid-body equations. The
analytical model used for pump tuning is the standard nonlinear cart-pendulum
model with states `[x, xdot, theta, thetaDot]` and force input `u`.

## Nonlinearities and Constraints

| Nonlinearity | Location | Parameters |
|---|---|---|
| Pendulum trigonometric dynamics | Multibody joints | Pendulum length, masses, gravity |
| Force saturation | Actuator | `forceMax` |
| Contact spring-damper/friction | Planar Contact Force | Stiffness, damping, transition width, friction |

## Numerical Considerations

| Concern | Approach |
|---|---|
| Solver | Variable-step `ode23t` for Simscape robustness. |
| Contact stiffness | Moderate default stiffness to avoid excessive stiffness in v1. |
| Geometry convention | Horizontal travel is reported as `x*` signals but maps to global Z. |

## Deferred Items

Exact sphere-to-box wall contact, flexible cable, 3D sway, and full closed-loop
in-model control are deferred until the baseline project is reviewed.
