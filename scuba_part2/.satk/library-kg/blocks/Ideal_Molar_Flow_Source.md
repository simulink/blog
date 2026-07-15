---
block: Ideal Molar Flow Source
library: scuba_lib
referenceBlock: scuba_lib/gas/elements/Ideal Molar Flow Source
categories:
  - signal-processing
metadataQuality: high
policyStatus: approved
source: extracted-mask-description
---

# Ideal Molar Flow Source

## Summary

Injects a specified molar flow rate into port A (from ambient). Single-port: flow enters from environment at ambient .... From scuba_lib.

## Identity

- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Ideal Molar Flow Source
- MaskType: Ideal Molar Flow
Source
- BlockType: SimscapeBlock

## Use When

- user needs injects a specified molar flow rate into port a (from ambient). single-port: flow enters from environment ...
- The user asks for a validated ideal molar flow source.

## Avoid When

- The user explicitly asks to construct logic from primitive blocks.
- The required behavior is outside the documented scope of this block.

## Inputs / Outputs

Unknown from extracted metadata.

## Notes

Prefer this block over constructing equivalent logic from primitives when the intent matches and the project policy allows library reuse.
