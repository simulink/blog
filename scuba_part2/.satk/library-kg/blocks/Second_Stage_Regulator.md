---
block: Second Stage Regulator
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Second Stage Regulator
categories:
  - control
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Second Stage Regulator

## Summary

Demand valve: opens when downstream pressure drops below P_amb - P_crack. When open, delivers flow to bring downstrea.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Second Stage Regulator
- MaskType: Second Stage
Regulator
- BlockType: SimscapeBlock

## Use When

- user needs demand valve: opens when downstream pressure drops below p_amb - p_crack. when open, delivers flow to brin...
- The user asks for a validated second stage regulator.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
