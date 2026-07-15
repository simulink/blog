---
block: Overpressure Relief Valve (OPRV)
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Overpressure Relief Valve (OPRV)
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Overpressure Relief Valve (OPRV)

## Summary

Passive dump valve that vents gas when BCD internal pressure exceeds ambient by the cracking threshold (typically 2.5.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Overpressure Relief Valve (OPRV)
- MaskType: Overpressure Relief
Valve (OPRV)
- BlockType: SimscapeBlock

## Use When

- user needs passive dump valve that vents gas when bcd internal pressure exceeds ambient by the cracking threshold (ty...
- The user asks for a validated overpressure relief valve (oprv).

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
