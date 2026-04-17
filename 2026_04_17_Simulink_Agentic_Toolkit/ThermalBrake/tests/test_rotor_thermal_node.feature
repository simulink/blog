# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/RotorThermalNode"
[inputs]
Q_rotor_in = "Q_rotor_in"
T_pad = "T_pad"
h_conv = "h_conv"
T_amb = "T_amb"
[outputs]
T_rotor = "T_rotor"
# --- end front-matter ---

Feature: RotorThermalNode subsystem validation
  Verifies rotor energy balance ODE with convection, radiation, conduction.

Scenario: Adiabatic heating with 50 kW for 3 seconds
  No cooling (h=0). Expected deltaT = Q*t/(m*c) = 50000*3/(6*449) = 55.7 degC.
  Starting from 25 degC, expect ~80.7 degC after 3 s.
  Given inputs
    * Q_rotor_in = const(50000)
    * T_pad = const(25)
    * h_conv = const(0)
    * T_amb = const(25)
  When simulate for 3s in Normal mode
  Then outputs
    * AdiabaticHeating: T_rotor == [78.0 .. 82.0] when t > 2.9s

Scenario: No heat input stays at ambient
  All inputs at ambient, no heat input. Temperature should stay at 25 degC.
  Given inputs
    * Q_rotor_in = const(0)
    * T_pad = const(25)
    * h_conv = const(8)
    * T_amb = const(25)
  When simulate for 10s in Normal mode
  Then outputs
    * StaysAtAmbient: T_rotor == [24.5 .. 25.5]
