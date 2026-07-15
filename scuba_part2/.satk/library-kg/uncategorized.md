# Uncategorized Blocks

Use these blocks for uncategorized blocks.

## Recommended Blocks

### Diver Body

- Block: [[blocks/Diver_Body]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/Diver Body
- Description: Combined mass, buoyancy, and hydrodynamic drag for a human body on a position-based translational port. Weight, Archi...
- Use when: user needs combined mass, buoyancy, and hydrodynamic drag for a human body on a position-based translational port. we...
- Avoid when: user asks only for a primitive diver body experiment.
- Metadata quality: high

### Gas Branch

- Block: [[blocks/Gas_Branch]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/Gas Branch
- Description: Two-port gas branch base class. Provides ports A and B with pressure difference and molar flow.
- Use when: user needs two-port gas branch base class. provides ports a and b with pressure difference and molar flow..
- Avoid when: user asks only for a primitive gas branch experiment.
- Metadata quality: high

### Ambient Reference

- Block: [[blocks/Ambient_Reference]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Ambient Reference
- Description: Ambient pressure reference (infinite source/sink). Computes ambient pressure from depth via translational port position.
- Use when: user needs ambient pressure reference (infinite source/sink). computes ambient pressure from depth via translational ...
- Avoid when: user asks only for a primitive ambient reference experiment.
- Metadata quality: high

### BCD Bladder

- Block: [[blocks/BCD_Bladder]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/BCD Bladder
- Description: Flexible variable-volume accumulator with buoyancy force output. Internal pressure equals ambient (flexible walls). V...
- Use when: user needs flexible variable-volume accumulator with buoyancy force output. internal pressure equals ambient (flexibl...
- Avoid when: user asks only for a primitive bcd bladder experiment.
- Metadata quality: high

### BCD Inflate Valve

- Block: [[blocks/BCD_Inflate_Valve]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/BCD Inflate Valve
- Description: Commanded valve for BCD inflation. Opens when cmd > 0.5, allowing IP gas to flow into bladder.
- Use when: user needs commanded valve for bcd inflation. opens when cmd > 0.5, allowing ip gas to flow into bladder..
- Avoid when: user asks only for a primitive bcd inflate valve experiment.
- Metadata quality: high

### Exhale Valve

- Block: [[blocks/Exhale_Valve]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Exhale Valve
- Description: One-way check valve for exhaled gas. Opens when upstream pressure exceeds downstream by P_crack.
- Use when: user needs one-way check valve for exhaled gas. opens when upstream pressure exceeds downstream by p_crack..
- Avoid when: user asks only for a primitive exhale valve experiment.
- Metadata quality: high

### Gas Domain Properties

- Block: [[blocks/Gas_Domain_Properties]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Gas Domain Properties
- Description: Sets domain-wide parameters (R_gas, T) for the connected gas network.
- Use when: user needs sets domain-wide parameters (r_gas, t) for the connected gas network..
- Avoid when: user asks only for a primitive gas domain properties experiment.
- Metadata quality: high

### Gas Tank

- Block: [[blocks/Gas_Tank]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Gas Tank
- Description: High-pressure gas reservoir (rigid tank) with weight force output. Pressure follows ideal gas law: P = n*R*T/V Applie...
- Use when: user needs high-pressure gas reservoir (rigid tank) with weight force output. pressure follows ideal gas law: p = n*r...
- Avoid when: user asks only for a primitive gas tank experiment.
- Metadata quality: high

### Gas Volume

- Block: [[blocks/Gas_Volume]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Gas Volume
- Description: Small rigid gas volume providing pressure state for intermediate nodes. P = n*R*T/V (ideal gas in rigid container)
- Use when: user needs small rigid gas volume providing pressure state for intermediate nodes. p = n*r*t/v (ideal gas in rigid co...
- Avoid when: user asks only for a primitive gas volume experiment.
- Metadata quality: high

### Ideal Pressure Source

- Block: [[blocks/Ideal_Pressure_Source]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Ideal Pressure Source
- Description: Sets port pressure to commanded value. Supplies/absorbs any molar flow.
- Use when: user needs sets port pressure to commanded value. supplies/absorbs any molar flow..
- Avoid when: user asks only for a primitive ideal pressure source experiment.
- Metadata quality: high

### Lungs

- Block: [[blocks/Lungs]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Lungs
- Description: Variable-volume lung chamber. Directly constrains lung volume to the commanded input. Calculates internal pressure us...
- Use when: user needs variable-volume lung chamber. directly constrains lung volume to the commanded input. calculates internal ...
- Avoid when: user asks only for a primitive lungs experiment.
- Metadata quality: high

### Overpressure Relief Valve (OPRV)

- Block: [[blocks/Overpressure_Relief_Valve__OPRV_]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Overpressure Relief Valve (OPRV)
- Description: Passive dump valve that vents gas when BCD internal pressure exceeds ambient by the cracking threshold (typically 2.5...
- Use when: user needs passive dump valve that vents gas when bcd internal pressure exceeds ambient by the cracking threshold (ty...
- Avoid when: user asks only for a primitive overpressure relief valve (oprv) experiment.
- Metadata quality: high

### Purge Valve

- Block: [[blocks/Purge_Valve]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Purge Valve
- Description: Commanded dump valve for BCD purge. Opens when cmd > 0.5, vents gas from bladder to ambient. P_dump bias models hydro...
- Use when: user needs commanded dump valve for bcd purge. opens when cmd > 0.5, vents gas from bladder to ambient. p_dump bias m...
- Avoid when: user asks only for a primitive purge valve experiment.
- Metadata quality: high

## Related Categories

- [[control]]
- [[signal-processing]]
