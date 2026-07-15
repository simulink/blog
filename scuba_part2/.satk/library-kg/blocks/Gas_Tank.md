---
block: Gas Tank
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Gas Tank
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Gas Tank

## Summary

High-pressure gas reservoir (rigid tank) with weight force output. Pressure follows ideal gas law: P = n*R*T/V Applie.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Gas Tank
- MaskType: Gas Tank
- BlockType: SimscapeBlock

## Use When

- user needs high-pressure gas reservoir (rigid tank) with weight force output. pressure follows ideal gas law: p = n*r...
- The user asks for a validated gas tank.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
