# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/BackingPlateNode"
[inputs]
T_pad = "T_pad"
T_amb = "T_amb"
[outputs]
T_backing = "T_backing"
# --- end front-matter ---

Feature: BackingPlateNode subsystem validation
  Verifies backing plate thermal node with conduction from pad and convection.

Scenario: No temperature difference stays at ambient
  Given inputs
    * T_pad = const(25)
    * T_amb = const(25)
  When simulate for 10s in Normal mode
  Then outputs
    * StaysAtAmbient: T_backing == [24.5 .. 25.5]

Scenario: Hot pad heats backing plate
  Pad at 200 degC should heat the backing plate above ambient.
  Given inputs
    * T_pad = const(200)
    * T_amb = const(25)
  When simulate for 30s in Normal mode
  Then outputs
    * HeatsUp: T_backing > 30 when t > 5s
    * BelowPad: T_backing < 200
