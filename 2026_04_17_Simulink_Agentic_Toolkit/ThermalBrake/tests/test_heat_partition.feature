# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/HeatPartition"
[inputs]
P_brake_front = "P_brake_front"
[outputs]
Q_rotor = "Q_rotor"
Q_pad = "Q_pad"
# --- end front-matter ---

Feature: HeatPartition subsystem validation
  Verifies that braking power is split by gamma=0.95 to rotor and 0.05 to pad.

Scenario: 100 kW input is partitioned 95/5
  Given inputs
    * P_brake_front = const(100000)
  When simulate for 100ms in Normal mode
  Then outputs
    * RotorHeat: Q_rotor == [94500 .. 95500]
    * PadHeat: Q_pad == [4500 .. 5500]

Scenario: Zero input gives zero outputs
  Given inputs
    * P_brake_front = const(0)
  When simulate for 100ms in Normal mode
  Then outputs
    * RotorZero: Q_rotor == 0
    * PadZero: Q_pad == 0
