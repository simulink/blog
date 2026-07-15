---
block: BCD Inflate Valve
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/BCD Inflate Valve
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# BCD Inflate Valve

## Summary

Commanded valve for BCD inflation. Opens when cmd > 0.5, allowing IP gas to flow into bladder.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/BCD Inflate Valve
- MaskType: BCD Inflate Valve
- BlockType: SimscapeBlock

## Use When

- user needs commanded valve for bcd inflation. opens when cmd > 0.5, allowing ip gas to flow into bladder..
- The user asks for a validated bcd inflate valve.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
