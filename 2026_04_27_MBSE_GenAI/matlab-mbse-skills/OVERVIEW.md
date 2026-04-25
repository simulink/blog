# MBSE Capability Suite for MATLAB

A family of reusable Claude skills that encode the complete MBSE workflow in MATLAB — from stakeholder needs through verified test cases, with traceability at every step.

---

## The RFLP Workflow

MBSE projects in this suite follow the RFLP methodology, with Verification as the closing step:

```
R — Requirements   Stakeholder Needs → System Requirements
F — Functional     What the system does — functions + abstract flows
L — Logical        What kind of element solves each function — design-agnostic principles
P — Physical       How it is built — concrete components, interfaces, stereotypes
                   ──────────────────────────────────────────────────
V — Verification   TC requirements (.slreqx) — testable shall-statements
                   linked to System Requirements via Verify links
```

Each layer implements or is allocated to the layer above; traceability links run back up. The **Logical** layer is the key addition over classic RFLP — design-agnostic solution principles (e.g., `SensingUnit`, `ControlUnit`) that sit between what the system *does* and how it is *built*, so the physical decomposition can change without invalidating the logical one.

---

## Guided Project Setup

The primary interaction model is a conversational, phase-by-phase guided workflow driven by the `mbse-workflow` skill. Users don't need to know the MATLAB APIs or script patterns — Claude handles all of that.

```
Phase 0 — Interview
  System name, location, description, engineering concerns, analysis needs,
  simulation model availability. Creates the MATLAB project and folder structure.

For each subsequent phase (1–9):
  1. Propose  — draft the content in plain language
  2. Approve  — user reviews and requests changes
  3. Generate — write the build script
  4. Run      — execute the script via MATLAB MCP
  5. Confirm  — show output and ask before continuing
```

Every script is idempotent, so rejecting a checkpoint means revise and re-run — no state to undo.

**Starting a session:**
> *"I want to set up a new MBSE project for an eVTOL propulsion system"*

The `mbse-workflow` skill activates automatically and begins the interview. The end state is a complete MATLAB project with a `.prj` file, idempotent build scripts for each phase, all generated artifacts, and a single `buildAll()` entry point.

---

## Skills

Five skills live in `skills/`. `mbse-workflow` drives the conversation; the others provide the technical API patterns it draws on. `matlab-project` is the generic foundation that `mbse-workflow` builds on for `.prj` mechanics — it is also useful on its own for any MATLAB Project work.

| Skill | Purpose |
|---|---|
| `matlab-project` | MATLAB Project foundation — `.prj` setup, file tracking, path management, build-script idempotency, runChecks health checks |
| `mbse-workflow` | Guided MBSE setup and phase orchestration — interview, propose, generate, run, confirm. Builds on `matlab-project`. Useful for new projects and resuming existing ones mid-workflow |
| `mbse-architecture` | F/L/P models, three-level interface dictionaries, stereotype profiles, F→L and L→P allocation sets, roll-up analysis |
| `simulink-requirements` | slreq API — creation, links, traceability, coverage, link health (incl. TC requirements) |
| `system-composer` | System Composer API reference — ports, connections, profiles, variant components, sequence diagrams, gotchas |

---

## Workflow by Phase

Each phase is a separate idempotent build script. Requirements-to-architecture Implement links are created immediately after each architecture layer is built (via per-phase allocation scripts), so traceability is reviewable at every step rather than deferred to a single late-stage pass.

### Phase 1 — Requirements

- Write **Stakeholder Needs** (operator perspective)
- Derive **System Requirements**, linked with `Derive`
- Budget constraints live in requirements; analysis reads them at run time so values are never hard-coded
- Artifacts: `StakeholderNeeds.slreqx`, `SystemRequirements.slreqx`

### Phase 2 — Functional Architecture

- **Functional Analysis first:** SR → Function derivation table — every SR must map to at least one function. Seeds the mandatory SR→Function Implement links created in the paired allocation script.
- Build a System Composer model for the logical functions, independent of any physical implementation
- Create a **functional interface dictionary** with abstract interfaces — no physical units or implementation detail
- Create **Function → SR Implement links** in a paired allocation script generated and run right after the model — so traceability is immediately reviewable
- Artifacts: `Functional.slx`, `FunctionalInterfaces.sldd`
- Scripts: `buildFunctional.m`, `buildFunctionalAllocation.m`

### Phase 3 — Logical Architecture

- Build a System Composer model for **design-agnostic solution principles** — the "what kind of element" layer between functions and hardware
- Components are nouns describing a solution role: `SensingUnit`, `ControlUnit`, `ActuationUnit` — no hardware brand names or part numbers
- Create a **logical interface dictionary** with typed, semantically-named fields but without datasheet-level specifics
- Create **Logical → SR Implement links** for non-functional requirements (timing, performance, safety, security) in a paired allocation script
- Artifacts: `Logical.slx`, `LogicalInterfaces.sldd`
- Scripts: `buildLogical.m`, `buildLogicalAllocation.m`

### Phase 4 — Physical Architecture + Profile + Views

- Build a System Composer model with concrete hardware/software components and typed ports
- Create a **physical interface dictionary** with implementation-level interfaces — concrete field names, specific types, physical units
- Define a **profile** with a component properties stereotype capturing the engineering attributes that drive design decisions (mass, power, cost, reliability, latency, throughput, supplier, safety level, …) and apply it with initial estimates. Profile creation sits at the end of the architecture script so estimates travel with the model and survive every rebuild. When the decomposition has composite assemblies, apply the stereotype to **leaf components only** by default — this keeps `prop == 0` review views (`ZeroedEstimate_Flag` etc.) meaningful and matches the recursive-sum analysis driver. Apply to composites too only if you need the Analysis Viewer to display rolled-up values at every hierarchy level (tradeoff: zero-value views false-positive on composites until an analysis runs).
- **Optional:** convert a composite (e.g. a cooking line, a battery pack, a sensor array) into a **variant component** with alternative internal architectures when you want to compare candidate designs side-by-side. See Trade Studies below.
- Define **architecture views** — named stereotype-query lenses on the physical model (cost drivers, high-power consumers, zeroed-estimate flags, supplier-partition views). Views live *inside* the `.slx` (in `archViews.xml`), so `buildViews.m` runs **after** `buildPhysical.m` as a decoration step and is itself idempotent. Views and stereotype properties are co-designed: every property a view filters on must be on the stereotype.
- Create **Physical → SR Implement links** for hardware-specific requirements and system-level budget caps that roll up across components
- Artifacts: `Physical.slx`, `PhysicalInterfaces.sldd`, `Profile.xml` (views are inside the `.slx`)
- Scripts: `buildPhysical.m`, `buildPhysicalAllocation.m`, `buildViews.m`

### Phase 5 — Functional→Logical Allocation

- Allocation set mapping each function to the logical element(s) that realize it
- Artifact: `FunctionalToLogical.mldatx`

### Phase 6 — Logical→Physical Allocation

- Allocation set mapping each logical element to the physical component(s) that implement it
- Artifact: `LogicalToPhysical.mldatx`

### Phase 7 — Analysis (optional)

- Compute system-level roll-ups and per-component margins from the architecture profile
- Budget caps are read from requirements at run time — `parseBudgetValue` accepts both `"not exceed X <unit>"` and `"not exceed <unit> X"` (currency-first), and a companion `parseMinValue` handles `">= X <unit>"` / `"at least X <unit>"` / `"support[s] X <unit>"` for floor-style SRs (battery capacity, endurance)
- Rollup pattern follows from the Phase 4 stereotype-scope choice: leaves-only → recursive-sum walker in the driver; leaves-and-composites → canonical `iterate + PostOrder` pattern
- **Topology-dependent rollup:** throughput (MIN for serial, SUM for parallel) and reliability (series vs. parallel) are handled via a per-composite numeric flag on the stereotype (`UseParallelThroughput`, etc.); the callback branches on the flag. See `mbse-architecture/references/analysis.md#topology-dependent-rollup` for the pattern
- Artifact: `Analysis.mat`
- Script: `runAnalysis.m`

### Phase 8 — Test Cases

- One TC requirement per SR, each describing a stimulus and measurable pass criterion
- Link each TC to its SR with a `Verify` link
- Generate a coverage report; SRs verified by analysis (Phase 7) are expected not covered
- Artifact: `TestCases.slreqx`
- Script: `buildTestCases.m`

> **Requirements allocation is not a separate phase.** Function / Logical / Physical → SR Implement links are generated alongside each architecture layer (Phases 2, 3, 4) by paired per-phase allocation scripts that share a `removeImplementLinksToModel` helper. Each script cleans up only its own model-scoped links, so they can be re-run in any order without wiping each other out.

---

## Review Dashboards via Architecture Views

On a physical model with dozens of components, scrolling the full diagram to answer "which components are driving the cost budget?" gets tedious fast. Architecture views are **named stereotype-property queries** that filter the model to just the matching components, highlighted in a color of your choice. They appear as a dropdown at the top of the SC canvas and open in bulk from the Views Gallery (`openViews(model)`).

Typical set:

| View | Query | What it surfaces |
|---|---|---|
| `CostDrivers` | `Cost > 10% of budget` | First trim targets when a cost SR fails |
| `HighPowerConsumers` | `Power > 10% of cap` | Margin-miss contributors |
| `ZeroedEstimate_Flag` | `Mass == 0` (or any budget property) | Components where someone forgot to set a value — otherwise silent in PostOrder rollup |
| `SafetyCritical` | `SafetyLevel == 'DAL-A'` | Certification-path components |
| `VendorX` | `Supplier == 'VendorX'` | Per-supplier partitions for procurement/ICD reviews |

Because every view is a query over stereotype properties, **the set of views the project wants directly shapes the stereotype**: a safety-critical view requires a `SafetyLevel` property on the stereotype, a supplier view requires `Supplier`, and so on. Phase 0's Q5 interviews both concerns and desired views together for exactly this reason — the two answers have to be consistent.

Views live inside the `.slx` (in an internal `archViews.xml` entry), so a physical-model rebuild wipes them. The paired `buildViews.m` script re-decorates the freshly-rebuilt model on every `buildAll` run.

For groupings that don't fit a single-property query — "all physical components realizing the ControlUnit logical", "all components from supplier X whose mass changed since last build" — views also support explicit element lists (`v.Root.addElement(comp)`).

---

## Trade Studies via Variant Components

When the Phase 7 analysis surfaces a multi-candidate decision — throughput is a bottleneck but could be fixed by parallel vessels OR a larger single unit OR a pipelined split; cost vs. reliability has an open tradeoff — a **variant component** lets all the candidate architectures live inside the same physical model and be compared side-by-side without file duplication.

**Mechanism.** Convert a composite component into a `systemcomposer.arch.VariantComponent` via `comp.makeVariant()`. The baseline content becomes the first auto-created choice; add more choices via `vc.addChoice({'V1_Parallel'})` and populate each choice's internal architecture independently. External boundary ports and wiring are preserved through the conversion, so upstream and downstream components don't need to know about the variant at all.

**Driver.** [`system-composer/code/tradeStudy.m`](skills/system-composer/code/tradeStudy.m) is a generic trade-study driver: given a variant-component name, a list of `{choice, description}` pairs, and a `caps` struct using a `_cap`/`_floor` field-name convention, it:

1. Loops over choices, sets each as active, instantiates, and runs the project's PostOrder rollup callback
2. Collects per-variant rollup totals and SR pass/fail flags
3. Emits a markdown report with a side-by-side comparison table, pass/fail matrix, and the **Pareto-efficient set** (variants not dominated by any other on all lower-better + higher-better metrics)

**Topology-dependent rollup.** Parallel vessels sum throughput; serial stages take the min. A per-composite numeric stereotype flag (`UseParallelThroughput`) tells the callback which aggregation to use; set it per variant choice at build time. Reliability has the same issue and can use a sibling flag when needed. Reference: `mbse-architecture/references/analysis.md#topology-dependent-rollup`.

**Gotchas.** `applyStereotype` on a variant wrapper errors — apply to each choice instead. String stereotype properties set on a choice do NOT propagate to the wrapper's instance at instantiate time (numeric ones do) — encode variant-specific analysis flags as numbers. Generic `arrangeComposites` walkers that follow `.Architecture` only reach the active choice; iterate `getChoices()` explicitly for inactive variants. Full gotcha list + a working build template in `system-composer/SKILL.md#variant-components` + `system-composer/code/buildMyVariantComposite.m`.

---

## Behavioral Views (Sequence Diagrams)

When the structural architecture is stable, a **sequence diagram** adds the "how the components collaborate over time" story for a specific operational scenario (normal production cycle, rocket turnaround, fault handling, startup, recipe switch). Attached to the **logical** model — stable across variant trade studies — via `model.addInteraction(name)`.

**Key feature:** every message is bound to a real port pair on the components underlying the lifelines. The 5-argument `operand.addMessage(srcLifeline, srcPortName, dstLifeline, dstPortName, guard)` requires port names that resolve on the source and destination components, so a port rename upstream surfaces as a build error on the sequence diagram rather than silent drift. Unlike Mermaid/PlantUML diagrams, the behavioral view stays consistent with the structural model by construction.

Fragments (`Alt`, `Loop`, `Opt`, `Par`), guards, and duration constraints are all supported. Messages live on *fragment operands* (not on fragments or the interaction directly) — `interaction.RootFragment.Operands(1).addMessage(...)` for the straight-line sequence; `fragment.Operands(i).addMessage(...)` inside an `Alt`/`Loop`. Full API patterns + template in `system-composer/SKILL.md#sequence-diagrams` and `system-composer/code/buildMySequenceDiagram.m`.

**Requirement traceability caveat (R2025b).** `slreq.createLink` does not accept an `Interaction` object as source. The struct workaround (`domain='linktype_sc_interaction'`, `id=diagram.UUID`) creates the link in memory but the `LinkSetManager` refuses to reload it alongside `linktype_rmi_simulink` Implement links on the same `.slx` — "Artifact type mismatch" error, silent drop. Workarounds: convention-based trace (name the interaction clearly; reference it from SR descriptions), or a companion TC whose description is "Execute the `<interactionName>` sequence and verify message ordering" with a normal TC→SR Verify link. Documented in `simulink-requirements/SKILL.md` Common Pitfalls.

Build step typically runs LAST in `buildAll` — a rebuild of the logical model wipes attached interactions, so the sequence diagram must be (re-)created after.

---

## Verification

`TestCases.slreqx` contains testable shall-statements with Verify links to SRs — one TC per SR, each describing stimulus, measurement, and pass criterion in prose. Standalone artifact that provides full requirements traceability on its own. Budget-cap SRs are verified by the analysis script and are expected to show as "NOT COVERED" in the coverage report.

---

## Traceability Chain

Every artifact is traceable up and down the chain:

```
Requirements links:
  Stakeholder Need  (StakeholderNeeds.slreqx)
      └─[Derive]─▶  System Requirement  (SystemRequirements.slreqx)
                        ◀─[Implement]──  Function           (Functional.slx)   mandatory
                        ◀─[Implement]──  Logical Component  (Logical.slx)      non-functional reqs
                        ◀─[Implement]──  Physical Component (Physical.slx)     hardware reqs
                        └─[Verify]─▶  TC Requirement     (TestCases.slreqx)

Architecture chain (allocation):
  Function  (Functional.slx)
      └─[F→L Allocate]─▶  Logical Element  (Logical.slx)
                               └─[L→P Allocate]─▶  Physical Component  (Physical.slx)
```

All links are bidirectional and navigable from either end in the Requirements Editor or programmatically via `req.outLinks()` / `req.inLinks()`.

---

## MATLAB Project Integration

Each project uses a MATLAB project file (`.prj`) created once via the `matlab-project` skill — `setupProject.m` is the generic helper, with `setupMBSEProject.m` as the MBSE-shaped wrapper that pins the standard RFLPV folder set. All `.prj` mechanics — folder layout, file tracking, the `removeFile`-before-`delete` rule, derived/cache wiring, and `runChecks` health checks — live in `matlab-project`. See that skill for the conventions; `mbse-workflow` calls into them.

Capabilities provided:

- **Path management** — project folders are on the MATLAB path, so System Composer resolves models by name and tools find artifacts without absolute paths
- **Derived folders** — Simulink cache and codegen outputs are kept out of source control
- **File tracking** — build scripts register the artifacts they create; the project stays in sync with the file system automatically
- **Health checks** — `buildAll.m` runs project checks at the end and surfaces any issues immediately

---

## Design Principles

- **Idempotent scripts** — every script deletes and recreates its artifacts on each run; safe to re-run without accumulating stale data
- **Project-integrated** — build scripts keep the MATLAB project in sync; health checks run automatically on every full build
- **Skills are organized by API domain** — each skill covers one MATLAB toolbox or API surface (`slreq`, System Composer). When an operation spans domains, it lives in the skill that owns the primary API, with a pointer from the other
- **`mbse-workflow` orchestrates; domain skills are reference** — the workflow skill handles phase sequencing and user interaction; it draws on the domain skills for API patterns rather than duplicating them. The two concerns can evolve independently
