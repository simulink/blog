# GalacticSoup — MBSE Study

Sandbox MATLAB Model-Based Systems Engineering project for an intergalactic
vegan soup factory that takes earthling vegetables, produces galactic soups,
and ships them across the universe via rockets. The project is built to
**study architecture options**, not to ship a product — the artifacts favor
legibility and traceability over premature commitment to a specific physical
design.

Built with the `mbse-workflow` Claude skill suite (requirements → F/L/P
architectures → allocation → rollup analysis → test cases).

## Quick start

1. Open `GalacticSoup.prj` in MATLAB (R2025b or later; System Composer,
   Requirements Toolbox, and Simulink Test are required).
2. Run `buildAll` from the MATLAB Command Window. A clean rebuild takes
   about 40 s and runs all ten phases end-to-end, finishing with the
   project health check. The last lines of output are the rollup analysis
   table and the Phase 8 verdict summary.
3. Individual phases can be re-run in isolation (each phase script is
   idempotent): `buildRequirements`, `buildFunctional`, `buildLogical`,
   `buildPhysical`, `buildViews`, `buildFunctionalToLogical`,
   `buildLogicalToPhysical`, `buildAllocation`, `runAnalysis`,
   `buildTestCases`.

## Project layout

```
GalacticSoup.prj                 MATLAB Project file
plan.md                          Living overview (phase status, Phase 8 finding)
decisions.md                     Append-only log of non-obvious design decisions
requirements/
  source/                        Source xlsx inputs (15 SNs, 27 SRs)
  StakeholderNeeds.slreqx        Imported SNs + SN→SR Derive link store
  SystemRequirements.slreqx      Imported SRs
  TestCases.slreqx               27 TCs + TC→SR Verify link store
architecture/
  GalacticSoupFunctional.slx     12 functions, 10 abstract interfaces
  GalacticSoupLogical.slx        8 top-level elements + composite CookingUnit
                                 (Stirrer, Seasoner)
  GalacticSoupPhysical.slx       8 top-level components + composite CookingLine
                                 (CookingVessel, StirringMechanism, SpiceDispenser)
  GalacticSoupProfile.xml        ComponentCharacteristics stereotype
  GalacticSoupFunctionalToLogical.mldatx   F→L allocation (12 pairs)
  GalacticSoupLogicalToPhysical.mldatx     L→P allocation (11 pairs)
  *~mdl.slmx                     Implement-link stores (one per model)
analysis/
  galacticSoupRollup.m           PostOrder rollup callback (SUM / MIN / series)
  GalacticSoupRollup.mat         Analysis instance for the Analysis Viewer
scripts/                         20 build / helper .m files (see buildAll.m)
derived/                         Simulink cache + codegen (gitignored)
```

## Traceability

```
SN ─[Derive, 27]─▶ SR ◀─[Implement, 66]─ {Function | Logical element | Physical component}
                  ◀─[Verify, 27]─  TC
```

Counts: 27 SN→SR Derive, 29 F→SR + 9 L→SR + 28 P→SR Implement, 27 TC→SR
Verify. All 27 SRs have at least one Implement link and one Verify link.

## Phase 8 — rollup analysis

Current estimates yield:

| Metric | Value | Target | Verdict |
|---|---|---|---|
| Mass | 12 380 kg | ≤ 15 000 | PASS (margin 17.5%) |
| Power | 252.8 kW | ≤ 500 | PASS (margin 49.4%) |
| Cost | 1 894 000 cr | ≤ 2 000 000 | PASS (margin 5.3%) |
| Throughput | 50 sph | ≥ 200 | **FAIL** — single `CookingVessel` is the bottleneck |
| System MTBF | 2 957 hr (~123 d) | — | informational |

The throughput FAIL is the primary architecture-options signal — see
`plan.md` for candidate next studies (parallel vessels, higher-capacity
vessel, pipelined cook stages).

## Known gaps (logged)

1. `ReceiveIngredients` is an orphan function — no imported SR governs
   ingredient inbound flow. See `decisions.md` Phase 2 entry and
   `plan.md` Open Questions.
2. SR-014 volume cap is not automated in Phase 8 — `Volume_m3` is not
   on the stereotype. `TC-GS-014` is a prose stub.

## Decisions log

Non-obvious choices (stereotype scope, rollup rules, architecture-decisions)
are captured in `decisions.md`. New decisions should be appended, not
rewritten.
