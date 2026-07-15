---
block: Exhale Valve
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Exhale Valve
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Exhale Valve

## Summary

One-way check valve for exhaled gas. Opens when upstream pressure exceeds downstream by P_crack.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Exhale Valve
- MaskType: Exhale Valve
- BlockType: SimscapeBlock

## Use When

- user needs one-way check valve for exhaled gas. opens when upstream pressure exceeds downstream by p_crack..
- The user asks for a validated exhale valve.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
