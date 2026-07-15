---
block: First Stage Regulator
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/First Stage Regulator
categories:
  - control
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# First Stage Regulator

## Summary

Reduces HP tank pressure to intermediate pressure. Maintains outlet (B) at P_amb + IP_offset, limited by supply press.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/First Stage Regulator
- MaskType: First Stage
Regulator
- BlockType: SimscapeBlock

## Use When

- user needs reduces hp tank pressure to intermediate pressure. maintains outlet (b) at p_amb + ip_offset, limited by s...
- The user asks for a validated first stage regulator.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
