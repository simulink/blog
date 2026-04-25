# MATLAB MBSE Skills

A collection of Claude skills for Model-Based Systems Engineering in MATLAB — from stakeholder needs through verified test cases, with full bidirectional traceability.

---

## The RFLP Workflow

MBSE projects in this suite follow the RFLP methodology, with Verification as the closing step:

```
R — Requirements   Stakeholder Needs → System Requirements (.slreqx)
F — Functional     What the system does — functions + abstract flows
L — Logical        What kind of element solves each function — design-agnostic principles
P — Physical       How it is built — concrete components, interfaces, stereotypes
                   ──────────────────────────────────────────────────
V — Verification   TC requirements (.slreqx) — testable shall-statements
                   linked to System Requirements via Verify links
```

Each layer implements or is allocated to the layer above; traceability links run back up. The **Logical** layer is the key addition over classic RFLP — design-agnostic solution principles (e.g., `SensingUnit`, `ControlUnit`) that sit between what the system *does* and how it is *built*.

---

## Getting Started

Tell Claude what you want to build:

> *"I want to set up a new MBSE project for a [your system]"*

The `mbse-workflow` skill interviews you, then walks through each phase one at a time — proposing content, waiting for approval, generating the build script, running it, and only moving on once you confirm. The interview covers engineering concerns *and* the review views you'll want on the architecture: the two answers jointly shape the component stereotype (you can only filter views on properties you put on the stereotype). The result is a runnable MATLAB project with idempotent scripts and a single `buildAll()` entry point that rebuilds everything from scratch.

---

## Prerequisites

| Toolbox | Used for |
|---|---|
| System Composer | Architecture modeling, profiles, stereotypes, analysis instances |
| Requirements Toolbox | Requirement sets; Derive / Implement / Verify links |

MATLAB R2023a or later for the core RFLP workflow. Variant components require R2024b+; programmatic sequence diagrams require R2024b+ (mature on R2025b).

---

## Skills

| Skill | Role |
|---|---|
| `matlab-project` | MATLAB Project foundation — `.prj` setup, file tracking, path/health rules, build-script conventions |
| `mbse-workflow` | Orchestrator — interview, propose, generate, run, confirm. Builds on `matlab-project` |
| `mbse-architecture` | F/L/P models, interface dictionaries, stereotypes, allocation sets, roll-up analysis, review-dashboard views |
| `simulink-requirements` | slreq API — creation, links, traceability, coverage (incl. TC requirements) |
| `system-composer` | System Composer API reference — ports, connections, profiles, variant components, sequence diagrams, gotchas |

`mbse-workflow` drives the conversation; the others provide the API patterns it draws on. `matlab-project` is reusable for any MATLAB Project work, MBSE or otherwise.

---

## Beyond the core RFLP workflow

Two capabilities extend the base workflow when a project needs them:

- **Variant components + trade studies** — turn a physical composite into a System Composer Variant Component, add candidate architectures as choices (parallel vessels, larger single unit, pipelined stages), and compare them side-by-side on mass / power / cost / throughput / MTBF with a generic `tradeStudy` driver. Emits a markdown comparison table, pass/fail matrix, and Pareto-efficient set. See [`skills/system-composer/SKILL.md#variant-components`](skills/system-composer/SKILL.md#variant-components) and [`skills/system-composer/code/tradeStudy.m`](skills/system-composer/code/tradeStudy.m). Topology-dependent rollup (MIN vs. SUM for throughput, series vs. parallel for reliability) is covered in [`skills/mbse-architecture/references/analysis.md#topology-dependent-rollup`](skills/mbse-architecture/references/analysis.md).
- **Sequence diagrams** — attach a programmatic System Composer `Interaction` to the logical model for a specific operational scenario. Each message is bound to a real port pair, so structural changes surface as build errors rather than silent drift. See [`skills/system-composer/SKILL.md#sequence-diagrams`](skills/system-composer/SKILL.md#sequence-diagrams). slreq has a known limitation around persisting Verify links from an Interaction — documented in [`skills/simulink-requirements/SKILL.md`](skills/simulink-requirements/SKILL.md) Common Pitfalls.

Both features are optional; the core RFLP workflow runs end-to-end without either.

---

## Repository Structure

```
matlab-mbse-skills/
└── skills/
    ├── matlab-project/        MATLAB Project foundation (.prj, tracking, health)
    ├── mbse-workflow/         Guided end-to-end setup, phase orchestration (start here)
    ├── mbse-architecture/     Architecture, allocation, analysis
    ├── simulink-requirements/ slreq API — requirements and traceability
    └── system-composer/       System Composer API reference
```

---

## Traceability

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

All links are bidirectional.
