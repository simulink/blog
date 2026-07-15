---
block: BCD Bladder
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/BCD Bladder
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# BCD Bladder

## Summary

Flexible variable-volume accumulator with buoyancy force output. Internal pressure equals ambient (flexible walls). V.... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/BCD Bladder
- MaskType: BCD Bladder
- BlockType: SimscapeBlock

## Use When

- user needs flexible variable-volume accumulator with buoyancy force output. internal pressure equals ambient (flexibl...
- The user asks for a validated bcd bladder.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
