# Gantry Crane Simscape Multibody Plant

## Status: Draft
Last Updated: 2026-07-31

## Executive Summary

This plant model reproduces Ned Gulley's gantry-crane wall-clearance
scenario using Simscape Multibody. The model simulates a trolley carrying a
swinging payload that must clear a wall, then settle under a catch controller.
Visualization is provided by Mechanics Explorer, and failed maneuvers include
wall contact through a Simscape Multibody contact-force block.

## Goals

| Goal | Description |
|---|---|
| G1 | Simulate planar trolley-pendulum dynamics with rigid bodies and gravity. |
| G2 | Include wall contact/collision so failed clearance attempts are visible and measurable. |
| G3 | Demonstrate pump-and-catch control with direct state measurement. |
| G4 | Package the work as a MATLAB/Simulink Project with reproducible scripts. |

## Non-Goals

| Non-Goal | Rationale |
|---|---|
| Flexible cable or slack cable | v1 targets the blog's rigid pendulum control problem. |
| 3D sway | Planar behavior is enough for the wall-clearance maneuver. |
| Motor/electrical actuator dynamics | The controller commands horizontal force directly. |
| Sensor noise/observer design | The simplest controller interface uses direct state measurement. |

## Operating Scenarios

1. Small-angle catch: initialize near vertical and verify the LQR can settle
   the load.
2. Wall-clearance maneuver: pump the pendulum, clear the wall, and switch to
   catch behavior.
3. Failed maneuver: wall collision produces finite contact force and a
   collision flag.
4. Parameter sweep: vary pump amplitude/duration/phase to reduce peak force.

## Controller Interface Contract

### Plant Input

| Signal | Unit | Description |
|---|---|---|
| forceCmd | N | Horizontal trolley actuator force. |

### Plant Outputs

| Signal | Unit | Description |
|---|---|---|
| xTrolley | m | Trolley travel coordinate. |
| vTrolley | m/s | Trolley travel velocity. |
| theta | rad | Pendulum angle from vertical. |
| omega | rad/s | Pendulum angular velocity. |

### Truth and Debug Outputs

| Signal | Unit | Description |
|---|---|---|
| xBob | m | Payload horizontal coordinate. |
| yBob | m | Payload vertical coordinate. |
| contactFlag | 1 | Contact indicator from the contact-force block. |
| contactForce | N | Contact normal-force magnitude. |

## Validation Evidence

| Evidence | Description |
|---|---|
| Analytical model | Four-state nonlinear trolley-pendulum model in `tunePumpManeuver.m`. |
| Small-angle theory | Pendulum period and LQR linearization near vertical. |
| Contact sanity | Contact force must appear only when payload and wall contact frames overlap. |

## Open Questions

| Question | Default Decision |
|---|---|
| Use exact wall-surface contact geometry? | Defer; v1 uses planar contact force and visual wall geometry. |
| Add a full in-model closed-loop controller? | Defer; v1 computes a force profile from the simplest direct-state controller workflow. |
