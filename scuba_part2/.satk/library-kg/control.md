# Control Blocks

Use these blocks for control blocks.

## Recommended Blocks

### First Stage Regulator

- Block: [[blocks/First_Stage_Regulator]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/First Stage Regulator
- Description: Reduces HP tank pressure to intermediate pressure. Maintains outlet (B) at P_amb + IP_offset, limited by supply press...
- Use when: user needs reduces hp tank pressure to intermediate pressure. maintains outlet (b) at p_amb + ip_offset, limited by s...
- Avoid when: user asks only for a primitive first stage regulator experiment.
- Metadata quality: high

### Second Stage Regulator

- Block: [[blocks/Second_Stage_Regulator]]
- Library: scuba_lib
- ReferenceBlock: scuba_lib/gas/elements/Second Stage Regulator
- Description: Demand valve: opens when downstream pressure drops below P_amb - P_crack. When open, delivers flow to bring downstrea...
- Use when: user needs demand valve: opens when downstream pressure drops below p_amb - p_crack. when open, delivers flow to brin...
- Avoid when: user asks only for a primitive second stage regulator experiment.
- Metadata quality: high

## Related Categories

- [[uncategorized]]
- [[signal-processing]]
