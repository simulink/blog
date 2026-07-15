---
block: Ideal Pressure Source
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Ideal Pressure Source
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Ideal Pressure Source

## Summary

Sets port pressure to commanded value. Supplies/absorbs any molar flow.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Ideal Pressure Source
- MaskType: Ideal Pressure
Source
- BlockType: SimscapeBlock

## Use When

- user needs sets port pressure to commanded value. supplies/absorbs any molar flow..
- The user asks for a validated ideal pressure source.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
