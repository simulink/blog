# Scuba Simulator

[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/TO_BO_FIXED)

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=https://github.com/OWNER/REPO&project=scuba-buyancy.prj)

This repository contains a Simulink&reg; and Simscape&trade; project for modeling the
vertical dynamics and gas-system behavior of a scuba diver. An overview of the
project is available in the accompanying Simulink blog post:
<https://blogs.mathworks.com/simulink/2026/07/02/my-scuba-diving-simulator/>.
The repository is organized around a reusable plant model, custom Simscape
components, supporting simulation harnesses, MATLAB&reg; scripts, and project
documentation.

Use this simulator to:
- Demonstrate custom Simscape domain patterns for pressure-driven gas systems without reducing the scuba equipment topology to signal-only approximations.
- Exercise buoyancy-control algorithms against a physical plant that couples depth, breathing, gas consumption, buoyancy, drag, and equipment behavior. 
- Teach dive physics

The scuba diver model is `models/Scuba_Diver.slx`, which represents a 1-DOF scuba
diver plant with Simulink interfaces for buoyancy-control commands and lung
volume input, and outputs for depth and vertical velocity. The plant combines a
custom gas domain with translational mechanics to represent the interaction
between gas storage, regulation, breathing, BCD inflation and purge behavior,
buoyancy, drag, and diver mass properties.

![Scuba diver plant model](https://blogs.mathworks.com/simulink/files/ScubaSimulator.m-07-02-26_6-1.png)

![Scuba diver plant model](https://blogs.mathworks.com/simulink/files/ScubaSimulator.m-07-02-26_7-1.png)

The custom physical modeling implementation is defined under `+scuba/`. This
includes the diver body component in `+scuba/DiverBody.ssc`, the custom gas
domain in `+scuba/+gas/underwaterGas.ssc`, and the gas-system elements in
`+scuba/+gas/+elements/`, including the tank, gas volume, first-stage and
second-stage regulators, lungs, BCD bladder, inflate and purge valves,
overpressure relief valve, ambient reference, and related assets.

![Scuba diver plant model](https://blogs.mathworks.com/simulink/files/ScubaSimulator.m-07-02-26_5-1.png)

The `models/` directory contains the reusable plant and associated harness
models:

Component tests:
- `models/harnesses/bcd_test.slx`: Buoyancy Control Device test harness
- `models/harnesses/tank_test.slx`: Air tank test harness
- `models/harnesses/lung_test.slx`: Diver lungs test harness
System tests:
- `models/descent_test.slx`: closed-loop harness with Stateflow&reg;-based depth control logic
![Scuba diver plant model](https://blogs.mathworks.com/simulink/files/ScubaSimulator.m-07-02-26_9-1.png)
- `models/breath_test.slx`: harness for breathing and gas-consumption studies
![Scuba diver plant model](https://blogs.mathworks.com/simulink/files/ScubaSimulator.m-07-02-26_11-1.png)

Full simulation:
- `models/fullDiveHarness.slx`: harness for complete hour-long dive profile

Diver model:
- `models/Scuba_Diver.slx`: reusable subystem plant model

Components library:
- `models/scuba_lib.slx`: generated Simscape library built from the `.ssc` source files

The `scripts/` directory contains MATLAB utilities for project support and
library generation:
- `scripts/rebuildScubaLib.m`: rebuilds the Simscape library into
  `models/scuba_lib.slx`

The `tests/` directory contains MATLAB Test classes used to run and plot
selected studies:

- `tests/testDescent.m`: runs `fullDiveHarness` through a one hour dive profile
- `tests/testDepth.m`: runs `breath_test` across multiple depths and plots tank
  pressure behavior
- `tests/testDescent.m`: runs `descent_test` across multiple parameter values
  and plots depth response
- `tests/testBCD.m`:
- `tests/testTank.m`:
- `tests/testLungs.m`:

The `docs/` directory contains project documentation, including specifications
and development notes. In particular,
`docs/specs/plant-models/scuba-diver/` contains system, architecture,
controller, and implementation documents related to the scuba diver plant
model.

## Repository Structure

- [`models/`](models/): plant and harness models
- [`+scuba/`](+scuba/): custom Simscape source code and assets
- [`data/`](data/): Simulink data dictionary
- [`scripts/`](scripts/): MATLAB support scripts
- [`tests/`](tests/): MATLAB simulation-study scripts
- [`docs/`](docs/): specifications and project documentation
- [`.satk/`](.satk/): Simulink Agentic Toolkit custom libraries requirements

## Requirements

- MATLAB&reg; R2026a
- Simulink&reg;
- Simscape&trade;
- Stateflow&trade;


## Getting Started

1. Open `scuba-buyancy.prj` in MATLAB to load the project.
2. Run [`scripts/rebuildScubaLib.m`](scripts/rebuildScubaLib.m) if the custom
   Simscape library needs to be regenerated from source.
3. Open `models/descent_test.slx`, `models/breath_test.slx`, or
   `models/fullDiveHarness.slx` to run a harness model.
4. Open `models/Scuba_Diver.slx` to inspect or reuse the standalone plant.
