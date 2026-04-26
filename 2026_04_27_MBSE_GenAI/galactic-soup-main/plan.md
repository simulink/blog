# GalacticSoup — Project Plan

Living overview of this MBSE project. Updated at the end of each phase and whenever scope or constraints change. Treat this as the canonical "where we are and where we're going" document for both human reviewers and future Claude sessions.

## Overview

GalacticSoup is an intergalactic vegan soup factory that takes earthling vegetables as raw input, produces galactic soups through an automated production line, and ships the finished soups to customers across the universe via rockets. The project is exploratory — the intent is to study architecture options for the factory-plus-delivery system, not to commit a final design up front.

## Source artifacts

- **Requirements:** Imported from `requirements/source/StakeholderNeeds.xlsx` and `requirements/source/SystemRequirements.xlsx` (in-project; Path B — editable imports).
- **Project folder:** `D:\dev\that\GalacticSoup`
- **Other inputs:** (none yet)

## Engineering concerns (Phase 0 Q5)

Properties that will become stereotype fields on physical components and drive analysis roll-ups:

- `Mass_kg` (double, kg) — rocket-payload-constrained; rollup vs. payload cap
- `Power_W` (double, W) — factory-floor + life-support draw; rollup vs. power cap
- `Cost_credits` (double, credits) — build/procurement cost; rollup vs. total budget
- `Throughput_soupsPerHr` (double, soups/hr) — line capacity; pipeline min for bottleneck analysis
- `Reliability_MTBF_hr` (double, hr) — mean time between failures
- `Supplier` (string) — vendor identity, for partition views
- `SafetyLevel` (enum: FoodSafe / CrewSafe / Critical) — food-contact vs. life-support vs. flight-critical

Planned views (each must filter on a property above, or be allocation-driven):

- `CostDrivers` — `Cost_credits > 10% of budget`
- `HighPowerConsumers` — `Power_W > 10% of cap`
- `HeavyPayload` — `Mass_kg > threshold`
- `Bottlenecks` — `Throughput_soupsPerHr < line target`
- `SafetyCritical` — `SafetyLevel == 'Critical'`
- `ZeroEstimate_Flag` — any budget prop `== 0` (forgotten-input catch)

## Analysis scope (Phase 0 Q6)

Quantitative work planned for Phase 8:

- **Mass rollup** vs. rocket payload cap (SR-driven)
- **Power rollup** vs. factory power cap (SR-driven)
- **Cost rollup** vs. total budget cap (SR-driven)
- **Throughput analysis** — min across the production pipeline as effective factory rate; flag bottlenecks
- Margins written back to the analysis instance; Pareto across alternatives optional

## Decision context (Phase 0 Q7)

Backstory, constraints, incidents, and stakeholder considerations that aren't visible from the SRs alone but shape how decisions should be made:

- Sandbox project: the goal is **to study architecture options**, not to ship a product. Prefer reasoning that keeps options open (multiple candidate decompositions) over premature commitment. Record the "why" for each selected option in `decisions.md` so trade studies remain legible.

## Phase status

| Phase | Description | Status |
|---|---|---|
| 0 | Project setup | completed — 2026-04-22 |
| 1 | Requirements | completed — 2026-04-22 |
| 2 | Functional architecture | completed — 2026-04-22 |
| 3 | Logical architecture | completed — 2026-04-22 |
| 4 | Physical architecture + stereotype | completed — 2026-04-22 |
| 5 | F→L allocation set | completed — 2026-04-22 |
| 6 | L→P allocation set | completed — 2026-04-22 |
| 7 | Consolidated SR Implement links | completed — 2026-04-22 |
| 8 | Analysis | completed — 2026-04-22 (Throughput FAIL expected — single vessel; see note below) |
| 9 | Test cases | completed — 2026-04-22 |
| 10 | Build all + final summary | completed — 2026-04-22 |

### Phase 8 finding — throughput bottleneck

Rollup analysis results with current estimates (after SR-028 addition):

| Metric | Value | Target | Verdict |
|---|---|---|---|
| Mass | 12 600 kg | ≤ 15 000 | PASS (margin 16.0%) |
| Power | 255.9 kW | ≤ 500 | PASS (margin 48.8%) |
| Cost | 1 947 000 cr | ≤ 2 000 000 | PASS (margin 2.7% — tighter) |
| Throughput (min positive) | 50 sph | ≥ 200 | **FAIL** |
| System MTBF (series) | 2 496 hr | — | informational (down from 2 957 hr — two new series components) |

The throughput FAIL is the primary architecture-options signal: a single `CookingVessel` at 50 sph cannot satisfy SR-002 (200 sph). `PrepStation` at 250 sph (Chopper 250, Scale 500) does **not** bottleneck. Candidate next studies:

- **Parallel vessels.** Change composite throughput rollup for `CookingLine` from MIN to SUM-of-parallel-branches (rollup rule becomes topology-dependent — see Phase 4 decision entry).
- **Higher-capacity vessel.** Single larger unit at ≥ 200 sph; re-estimate Mass / Power / Cost and re-run analysis.
- **Vessel + pipelined stages.** Separate prep/cook/finish stages, each at the line rate.

### Change log

| Date | Change | Notes |
|---|---|---|
| 2026-04-23 | Added SR-GS-028 (ingredient preparation zone) + `PrepareIngredients` function + logical and physical `PrepStation` composites (Chopper/Scale sub-components). See `decisions.md` 2026-04-23 entry. | 27→28 SRs; pipeline now has an explicit prep stage; cost margin tightened from 5.3% to 2.7%. |

Mark each as `pending`, `in-progress`, or `completed — YYYY-MM-DD`.

## Open questions

Things we punted on or flagged for later. Close them or promote them to decisions as they resolve.

- ~~xlsx column mapping~~ — resolved at Phase 1: 1–4 = Id/Summary/Description/Rationale, column 5 `DerivedFrom` preserved and used for SN→SR Derive links
- Whether stereotype applies to leaves only or leaves + composites — decide at Phase 4b based on whether hierarchical Analysis Viewer display is needed
- **Ingredient inbound flow has no SR coverage.** Phase 2 introduced `ReceiveIngredients` as a function but no imported SR governs inbound receipt rate, shipment size, cold-chain, or unloading time. Likely a gap in the upstream requirements. Revisit at Phase 10; options: (a) add SRs for inbound flow and re-derive, (b) accept as known gap, (c) fold `ReceiveIngredients` behavior under `HandleRocket` coverage of SR-017/018.

## Known risks

Items that could invalidate earlier work if they change:

- (none identified yet)
