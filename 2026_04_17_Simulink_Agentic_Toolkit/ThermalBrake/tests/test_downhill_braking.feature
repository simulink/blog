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

Feature: Sustained Downhill Braking on 7% grade
  Constant speed descent at 80 km/h on a 7% downhill grade for 144 s,
  followed by 120 s cooling on flat road.
  * v0 must be set to 22.2 m/s before running.
  Brake command ~0.047 holds speed against gravity.

Scenario: Downhill descent then cooling
  Brake applied for 144 s on downhill, then released on flat.
  Given inputs
    * brake_cmd = step(0.047 -> 0 @ 144s)
    * accel_cmd = const(0)
    * theta_grade = step(-0.070 -> 0 @ 144s)
    * T_amb = const(25)
  When simulate for 264s in Normal mode
  Then outputs
    * SpeedNotExcessive: v_vehicle < 30
    * RotorHeatsUp: T_rotor > 40 when t > 50s
    * RotorBounded: T_rotor < 400
