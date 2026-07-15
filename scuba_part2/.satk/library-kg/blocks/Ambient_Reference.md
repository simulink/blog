---
block: Ambient Reference
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Ambient Reference
categories:
  - uncategorized
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Ambient Reference

## Summary

Ambient pressure reference (infinite source/sink). Computes ambient pressure from depth via translational port position.. From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Ambient Reference
- MaskType: Ambient Reference
- BlockType: SimscapeBlock

## Use When

- user needs ambient pressure reference (infinite source/sink). computes ambient pressure from depth via translational ...
- The user asks for a validated ambient reference.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
