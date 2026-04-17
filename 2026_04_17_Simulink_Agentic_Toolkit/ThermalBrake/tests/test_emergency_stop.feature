# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal"
[inputs]
brake_cmd = "brake_cmd"
accel_cmd = "accel_cmd"
theta_grade = "theta_grade"
T_amb = "T_amb"
[outputs]
T_rotor = "T_rotor"
T_pad = "T_pad"
v_vehicle = "v_vehicle"
# --- end front-matter ---

Feature: Emergency Stop - Single panic stop from 100 km/h
  Full brake applied from 100 km/h on flat road.
  Vehicle should stop in ~3 s, rotor temperature should peak 105-150 degC.
  After 60 s cooling at standstill, temperatures should decrease.

Scenario: Full braking from 100 km/h then cooling
  Initial speed v0=27.8 m/s. Full brake at t=0, released at t=4s.
  Given inputs
    * brake_cmd = step(1.0 -> 0 @ 4s)
    * accel_cmd = const(0)
    * theta_grade = const(0)
    * T_amb = const(25)
  When simulate for 63s in Normal mode
  Then outputs
    * VehicleStops: v_vehicle == 0 when t > 4s
    * RotorHeatsUp: T_rotor > 60 when t > 2s
    * RotorPeakHigh: T_rotor < 160
    * PadReasonable: T_pad < 80
    * RotorCooling: T_rotor < 90 when t > 50s
