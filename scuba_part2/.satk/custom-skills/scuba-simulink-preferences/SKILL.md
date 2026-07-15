---
name: scuba-simulink-preferences
description: Modeling and simulation preferences for the Scuba project. Use when designing, building, or writing unit tests for Simscape-based systems or custom physical domains in the scuba repository.
---

# Scuba Simulink & Simscape Modeling Preferences

This skill provides expert instructions and mandates for creating test harnesses, constructing physical layouts, and writing MATLAB unit tests for the Scuba project.

---

## 1. Simscape Selective Logging Mandate

Do **NOT** configure Simscape logging by changing block properties like `SimscapeLogType`. Instead, always manage variable instrumentation programmatically using the modern `simscape.instrumentation` package.

### Recommended Workflow:
1.  **Retrieve:** Fetch the default variable table for the block path.
2.  **Configure:** Programmatically set `Logging = true` for target internal variables.
3.  **Apply:** Set the updated table back on the block.
4.  **Extract:** Run the simulation and access the variables directly from the `out.logsout` Dataset. This avoids adding redundant physical sensors and converters in the model, keeping the harness visual layout completely clean.

### Code Pattern:
```matlab
% 1. Get the default variable table
tbl = simscape.instrumentation.defaultVariableTable('tank_test/GasTank');

% 2. Select variables to log programmatically
tbl("n_tank").Logging = true;
tbl("f").Logging = true;
tbl("A.p").Logging = true;

% 3. Apply the modified table
simscape.instrumentation.setVariableTable('tank_test/GasTank', tbl);

% 4. Simulate and retrieve
out = sim(Simulink.SimulationInput('tank_test'));
n_tank_ts = out.logsout.get('n_tank').Values;
```

---

## 2. Translational Physical Domain Mapping

When connecting translational mechanical parts, match the exact domain declared in the source files. 

*   **Avoid Mismatch:** Do **not** mix blocks from `fl_lib/Mechanical/Translational Elements` (domain: `foundation.mechanical.translational.translational`) with blocks from custom elements declaring `foundation.translational.translational`.
*   **The Right Blocks:** Use blocks from the **`fl_lib/Translational/Elements`** library (which are marked with the **`(PB)`** suffix).
    *   *Translational Spring (PB)*: `'fl_lib/Translational/Elements/Translational Spring (PB)'`
    *   *Translational World (PB)*: `'fl_lib/Translational/Elements/Translational World (PB)'`
*   **Position Reference Constraint:** Always ensure physical translational components that measure or rely on position (e.g., `AmbientReference.ssc` using `R.x`) have a fixed, well-defined mechanical reference (e.g., connected to a `Translational World (PB)` block) to prevent unconstrained position variables from causing initial condition convergence failures.

---

## 3. Physical Signal Connection Rules

*   In custom Simscape files, left-side ports (`LConn`) are usually mapped to inputs (e.g. `flow_cmd` on `IdealMolarFlowSource`) and right-side ports (`RConn`) are mapped to output physical nodes.
*   **Always connect physical signals correctly:**
    ```matlab
    % Connect SP_Converter physical signal outlet to the FlowSource physical signal input:
    add_line(modelName, 'SP_Conv/RConn1', 'FlowSource/LConn1');
    ```

---

## 4. Class-Based Unit Tests

*   Always write unit tests as MATLAB class-based tests inheriting from `matlab.unittest.TestCase` & `handle`.
*   Simulate using `Simulink.SimulationInput` and `Simulink.SimulationOutput` via `sim()`.
*   **Redundancy Rule:** You **never** need to call `load_system` before calling `sim()`. The `sim()` command automatically loads and opens the model behind the scenes, making manual `load_system` calls entirely redundant.
*   Verify outcomes using `verifyEqual` or `verifyLessThan` with explicit `AbsTol` bounds on physical float values.

---

## 5. MATLAB Project Registration Requirement

Whenever you create a new model (`.slx`), test suite (`.m`), or helper script/function (`.m`), you **must** register it directly within the active MATLAB Project so it is tracked correctly under source control and available for project pipelines.

### Code Pattern:
```matlab
% Retrieve active project and register files
proj = currentProject;
proj.addFile(fullfile(proj.RootFolder, 'models', 'my_new_harness.slx'));
proj.addFile(fullfile(proj.RootFolder, 'tests', 'testMyComponent.m'));
```

---

## 6. Visual Block Layout & Orientation Preferences

When building or updating models, adhere to the following visually clean and structured layout pattern:

### 1. Control & Input Signal Flow (Left-to-Right)
*   **Constant Inputs & Converters:** Positioned on the left side of the diagram (e.g., `ConstantFlow` at `[50, 210, 80, 240]` and `SPConv` at `[121, 210, 151, 240]`). This allows control signals to feed cleanly from left-to-right into Simscape actuator ports.
*   **Flow/Pressure Sources:** Positioned immediately after the converter (e.g., `FlowSource` at `[205, 194, 365, 256]`) to receive the input signal gracefully.

### 2. Domain Support Core (Stacked Vertically)
*   **Solver Configuration & Domain Properties:** Align them compactly near the physical nodes (e.g., `Solver` at `[220, 288, 265, 312]` and `GasProps` at `[190, 328, 275, 382]`, with `GasProps` oriented **`left`** to route its physical port nicely into the central junction line).

### 3. Component Under Test & Mechanical Loads (Top-to-Bottom Stack)
*   **Component Under Test:** Positioned prominently below or next to the sources (e.g., `GasTank` at `[340, 385, 440, 445]`).
*   **Mechanical & Gravity Load Line:**
    *   Route mechanical outputs (such as translational port `R`) **straight down** to represent gravity weight force.
    *   Orient the **`Spring`** to **`down`** (e.g., `[293, 435, 327, 490]`) and align it directly below the port.
    *   Orient the **`World Reference`** to **`up`** (e.g., `[294, 510, 326, 530]`) to terminate the spring cleanly at the bottom.

