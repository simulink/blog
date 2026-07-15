# Customer Library Reuse Index

This project has declared reusable Simulink libraries. Prefer these blocks when they match the modeling intent.

## Policy

The active policy mode is defined in `.satk/block-policy.json`.

- Always use customer library blocks when available. 
- Do NOT make domain-level judgments about library relevance.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared customer library after your search.
- Do not invent customer block names.
- If uncertain, inspect the relevant category page or ask the user.
- CRITICAL: Before using ANY block, search this index and the category pages for that specific block type first

## Libraries

- scuba_lib: Scuba buoyancy physical modeling blocks

## Commonly Used Blocks

- [[blocks/First_Stage_Regulator]] — Reduces HP tank pressure to intermediate pressure. Maintains outlet (B) at P_amb + IP_offset, limited by supply press... from scuba_lib
- [[blocks/Second_Stage_Regulator]] — Demand valve: opens when downstream pressure drops below P_amb - P_crack. When open, delivers flow to bring downstrea... from scuba_lib
- [[blocks/Ideal_Molar_Flow_Source]] — Injects a specified molar flow rate into port A (from ambient). Single-port: flow enters from environment at ambient ... from scuba_lib
- [[blocks/Diver_Body]] — Combined mass, buoyancy, and hydrodynamic drag for a human body on a position-based translational port. Weight, Archi... from scuba_lib
- [[blocks/Gas_Branch]] — Two-port gas branch base class. Provides ports A and B with pressure difference and molar flow. from scuba_lib
- [[blocks/Ambient_Reference]] — Ambient pressure reference (infinite source/sink). Computes ambient pressure from depth via translational port position. from scuba_lib
- [[blocks/BCD_Bladder]] — Flexible variable-volume accumulator with buoyancy force output. Internal pressure equals ambient (flexible walls). V... from scuba_lib
- [[blocks/BCD_Inflate_Valve]] — Commanded valve for BCD inflation. Opens when cmd > 0.5, allowing IP gas to flow into bladder. from scuba_lib

## Categories

- [[uncategorized]] — blocks with insufficient metadata for confident categorization
- [[control]] — PID controllers, regulators, feedback components
- [[signal-processing]] — filters, scaling, interpolation, signal conditioning
