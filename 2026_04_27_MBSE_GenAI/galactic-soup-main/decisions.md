# GalacticSoup — Decision Log

Append-only log of non-obvious design decisions made while building this project. Each entry captures enough context that a future reader — another engineer, another Claude session — can understand *why* a choice was made without reverse-engineering the code.

## Format

Each entry follows this shape:

    ## YYYY-MM-DD — Phase N — <short decision title>
    **Context:** Why this decision point came up; what prompted the choice.
    **Options considered:** A / B / C (omit if only one was seriously on the table)
    **Chosen:** <selected option>
    **Rationale:** Tradeoff that settled it, or the stakeholder preference that drove it.
    **Revisit if:** Condition under which this decision should be reopened.

## When to append

- At any phase checkpoint where the selected approach **was not forced by the requirements** — naming conventions, decomposition granularity, scope trims, stereotype property choices, how to handle budget-SR verification, etc.
- When the user **rolls back or redirects** a phase — record both the original choice and the reason for the change. Don't silently overwrite earlier entries; add a new one.
- When scope expands or contracts mid-project.

Skip entries for:
- Mechanical steps (e.g. "created the .prj file")
- Decisions fully determined by the SRs (no judgment was required)
- Bug fixes or API-level iteration (those go in commit messages, not decisions)

---

## 2026-04-22 — Phase 0 — Initial project scoping

**Context:** Phase 0 interview established system identity, folder layout, requirements source, engineering concerns, and analysis scope.

**Chosen:**
- System name: GalacticSoup
- Project folder: `D:\dev\that\GalacticSoup`
- Requirements source: `StakeholderNeeds.xlsx` and `SystemRequirements.xlsx` in `D:\dev\that\` (Path B, editable imports)
- Engineering concerns (stereotype scope): Mass_kg, Power_W, Cost_credits, Throughput_soupsPerHr, Reliability_MTBF_hr, Supplier, SafetyLevel
- Analysis scope: mass/power/cost rollups with margins vs. SR caps; throughput bottleneck analysis (pipeline min)

**Rationale / decision context (Q7):** Sandbox project whose goal is to **study architecture options**. Choice of stereotype scope was driven by the review-view wishlist — CostDrivers / HighPowerConsumers / HeavyPayload / Bottlenecks / SafetyCritical each filter on exactly one stereotype property, so every property earns its keep. `Supplier` supports vendor-partition reviews during trade studies. `Reliability_MTBF_hr` is scoped in but has no hard SR cap yet — may or may not feed Phase 8 analysis depending on what the imported SRs call for.

**Revisit if:** The imported SRs introduce concerns not covered by the proposed stereotype (e.g. latency, data rate, EMC class), or if the architecture-options study reveals that a property is never used for filtering or rollup and should be dropped.

---

## 2026-04-22 — Phase 2 — ReceiveIngredients kept as orphan function

**Context:** During the functional analysis, the user flagged that a function is needed for receiving ingredients from inbound rockets. Factory must unload ingredient shipments off incoming rockets and feed them to storage — symmetric to `LoadTransport` on the outbound side. However, none of the 27 imported SRs explicitly govern the inbound flow (receipt rate, shipment size, cold-chain, unloading time cap). The closest SR (SR-017 "3 concurrent rockets for loading or unloading") is about pad concurrency and naturally stays on `HandleRocket`.

**Options considered:**
- A. Omit `ReceiveIngredients` entirely; treat inbound as implicit
- B. Add `ReceiveIngredients` now as a known orphan function (no Implement link)
- C. Fold inbound into `HandleRocket`'s behavior

**Chosen:** B — add `ReceiveIngredients` as an orphan function and flag the SR gap in `plan.md`.

**Rationale:** Modeling the inbound path makes the factory architecture complete and makes the SR gap visible. Hiding it under `HandleRocket` (Option C) would conflate pad coordination with material handling. Omitting it (Option A) would leave `StoreIngredients` with no source of ingredients, which is nonsensical for a factory. Recording the function as an orphan surfaces the requirements gap so it can be addressed by the requirements author.

**Revisit if:** The user adds SRs covering inbound flow (receipt rate, turnaround, cold-chain), at which point the Phase 7 `buildAllocation.m` can attach them to `ReceiveIngredients` and the orphan marker can be removed.

---

## 2026-04-22 — Phase 4 — Stereotype on composites + MIN rollup for throughput

**Context:** Phase 4b originally scoped `ComponentCharacteristics` to leaves only (default, simpler; keeps `ZeroEstimate_Flag` view free of composite false-positives). User preferred stereotype on both leaves and composites so the Analysis Viewer can display rolled-up values at every hierarchy level. User also noted `Throughput_soupsPerHr` is not a sum rollup — a composite's throughput is bounded by its slowest subordinate.

**Options considered:**
- A. Leaves only, composite throughput computed externally (no hierarchical display)
- B. Leaves + composites, Throughput as SUM rollup (wrong semantics; would double-count)
- C. Leaves + composites, Throughput as MIN-over-positive rollup (other numerics SUM)

**Chosen:** C.

**Rationale:** Hierarchical display of rollups is valuable for architecture review; the false-positive on `ZeroEstimate_Flag` until analysis runs is a small, understood tradeoff. MIN-over-positive captures bottleneck semantics correctly — a composite is rate-limited by its slowest throughput-bearing child; zero-throughput children (e.g. `StirringMechanism`, `SpiceDispenser` — structural contributors, not pipeline stages) are excluded so they don't zero out a valid pipeline. Series-reliability rollup for `Reliability_MTBF_hr` deferred to Phase 8 confirmation.

**Revisit if:** The pipeline acquires parallel-path topology (e.g. multiple cooking vessels working concurrently), at which point composite throughput for a parallel branch becomes SUM of sibling rates rather than MIN — the rollup rule becomes topology-dependent and will need a different walker.

---

## 2026-04-23 — SR addition — Ingredient preparation zone (SR-GS-028)

**Context:** New SR added mid-project: the kitchen shall include a separate zone for ingredient preparation including chopping and weighing, sustaining ≥200 bowls/hour equivalent. Parent SN is SN-GS-001 (soup menu — different recipes need different prep). Addition required inserting a new production stage between storage/transfer and cooking at all three architecture layers.

**Options considered:**
- A. New function only; keep logical and physical abstract (no dedicated component) — rejected: doesn't express the "separate zone" part of the SR.
- B. Flat `PrepStation` at both logical and physical — partly satisfies the SR but doesn't surface the chopping-and-weighing decomposition visible in the SR wording.
- C. **Composite `PrepStation` at both logical and physical with `Chopper` and `Scale` sub-components; add a `Prepared` boolean field to `IngredientBatch` (logical) and the two physical ingredient flows; wire internals sequentially (Chopper → Scale).**

**Chosen:** C.

**Rationale:**
- *Composite decomposition* — "chopping and weighing" are two distinct roles that exist inside a single prep zone; a composite captures both the zone boundary and the sub-role structure, mirroring the existing CookingUnit/CookingLine pattern.
- *`Prepared` boolean on existing interfaces* (vs. a new `PreparedIngredientFlow` interface) keeps the interface count steady and expresses "raw → prepared" as a semantic state of the same payload rather than a type change. Same interface instance carries `Prepared=false` upstream of prep and `Prepared=true` downstream.
- *Sequential internal wiring (Chopper → Scale)* reflects realistic prep order — chop first, then weigh the prepared mass. Could be reordered if a later decision calls for it; the rollup rules do not depend on order.
- *Physical prep composite has two parallel internal paths (cold + ambient)*, each sequential through Chopper and Scale, because the physical model carries a cold/ambient distinction (SR-020) that the logical model does not. Each sub-component has 4 ingredient ports (Cold in/out, Ambient in/out) and 6 internal connections. Verbose but avoids introducing a new merged-flow interface.
- *Throughput impact* — Chopper 250 sph, Scale 500 sph; `PrepStation` composite rollup = MIN(250, 500) = 250 sph, well above the 50 sph `CookingVessel` bottleneck, so prep does not worsen the Phase 8 throughput FAIL.
- *Cost margin tightened* from 5.3% to 2.7% — two new priced leaves (Chopper $45k + Scale $8k = $53k). Still PASS. Noted on plan.md.
- *System MTBF reduced* from 2 957 hr to 2 496 hr (series reliability: more positive-MTBF descendants increase the failure rate sum). Informational, no SR cap.

**Revisit if:**
- The user adds a specific prep throughput cap above 500 sph — at that point the Scale would become a candidate bottleneck and need upgrading.
- Cold-chain preservation during prep becomes a requirement — we'd need to split the Chopper/Scale into cold-chain-preserving variants or add a cold-room constraint to the prep zone.
- The order of chopping vs. weighing is regulated (e.g. weigh-before-chop for recipe precision) — internal wiring reorder is a one-line change.
