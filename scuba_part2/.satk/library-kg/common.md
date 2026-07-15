# Common Customer Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library | Notes |
|---|---|---|---|
| reduces hp tank pressure to intermediate pressure | [[blocks/First_Stage_Regulator]] | scuba_lib | Reduces HP tank pressure to intermediate pressure. Maintains outlet (B) at P_amb + IP_offset, limited by supply press... |
| demand valve: opens when downstream pressure drops below ... | [[blocks/Second_Stage_Regulator]] | scuba_lib | Demand valve: opens when downstream pressure drops below P_amb - P_crack. When open, delivers flow to bring downstrea... |
| injects a specified molar flow rate into port a (from amb... | [[blocks/Ideal_Molar_Flow_Source]] | scuba_lib | Injects a specified molar flow rate into port A (from ambient). Single-port: flow enters from environment at ambient ... |
| combined mass | [[blocks/Diver_Body]] | scuba_lib | Combined mass, buoyancy, and hydrodynamic drag for a human body on a position-based translational port. Weight, Archi... |
| two-port gas branch base class | [[blocks/Gas_Branch]] | scuba_lib | Two-port gas branch base class. Provides ports A and B with pressure difference and molar flow. |
| ambient pressure reference (infinite source/sink) | [[blocks/Ambient_Reference]] | scuba_lib | Ambient pressure reference (infinite source/sink). Computes ambient pressure from depth via translational port position. |
| flexible variable-volume accumulator with buoyancy force ... | [[blocks/BCD_Bladder]] | scuba_lib | Flexible variable-volume accumulator with buoyancy force output. Internal pressure equals ambient (flexible walls). V... |
| commanded valve for bcd inflation | [[blocks/BCD_Inflate_Valve]] | scuba_lib | Commanded valve for BCD inflation. Opens when cmd > 0.5, allowing IP gas to flow into bladder. |
