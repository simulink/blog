---
block: Gas Domain Properties
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Gas Domain Properties
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Gas Domain Properties

## Summary

Sets domain-wide parameters (R_gas, T) for the connected gas network.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Gas Domain Properties
- MaskType: Gas Domain
Properties
- BlockType: SimscapeBlock

## Use When

- user needs sets domain-wide parameters (r_gas, t) for the connected gas network..
- The user asks for a validated gas domain properties.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
