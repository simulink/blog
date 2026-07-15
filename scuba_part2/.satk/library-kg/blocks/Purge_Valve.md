---
block: Purge Valve
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Purge Valve
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Purge Valve

## Summary

Commanded dump valve for BCD purge. Opens when cmd > 0.5, vents gas from bladder to ambient. P_dump bias models hydro.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Purge Valve
- MaskType: Purge Valve
- BlockType: SimscapeBlock

## Use When

- user needs commanded dump valve for bcd purge. opens when cmd > 0.5, vents gas from bladder to ambient. p_dump bias m...
- The user asks for a validated purge valve.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
