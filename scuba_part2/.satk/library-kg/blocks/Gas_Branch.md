---
block: Gas Branch
library: scuba_lib
referenceBlock: scuba_lib/gas/Gas Branch
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Gas Branch

## Summary

Two-port gas branch base class. Provides ports A and B with pressure difference and molar flow.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/Gas Branch
- MaskType: Gas Branch
- BlockType: SimscapeBlock

## Use When

- user needs two-port gas branch base class. provides ports a and b with pressure difference and molar flow..
- The user asks for a validated gas branch.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
