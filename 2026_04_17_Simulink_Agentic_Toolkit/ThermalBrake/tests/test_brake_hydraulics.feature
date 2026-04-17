# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/BrakeHydraulics"
[inputs]
brake_cmd = "brake_cmd"
v_vehicle = "v_vehicle"
[outputs]
tau_brake = "tau_brake"
F_brake_at_wheel = "F_brake_at_wheel"
P_brake_front = "P_brake_front"
# --- end front-matter ---

Feature: BrakeHydraulics subsystem validation
  Verifies that brake pedal command is converted correctly to
  braking torque, force at wheels, and thermal power.

Scenario: Full brake pedal produces correct torque and force
  Full brake_cmd=1.0 with vehicle at highway speed.
  tau_brake = P_line_max * A_piston * 2 * mu_pad * R_eff
  * = 120e5 * 0.0012 * 2 * 0.40 * 0.11 = 1267.2 N·m
  F_brake_at_wheel = 4 * tau_brake / R_wheel
  * = 4 * 1267.2 / 0.32 = 15840 N
  P_brake_front = tau_brake * v / R_wheel
  * = 1267.2 * 27.8 / 0.32 = 110034 W
  Given inputs
    * brake_cmd = const(1.0)
    * v_vehicle = const(27.8)
  When simulate for 100ms in Normal mode
  Then outputs
    * TauBrakeCheck: tau_brake == [1200 .. 1340]
    * FbrakeCheck: F_brake_at_wheel == [15000 .. 16700]
    * PbrakeCheck: P_brake_front == [104000 .. 116000]

Scenario: Zero brake pedal produces zero outputs
  No braking force or torque with pedal released.
  Given inputs
    * brake_cmd = const(0)
    * v_vehicle = const(27.8)
  When simulate for 100ms in Normal mode
  Then outputs
    * TauZero: tau_brake == 0
    * FbrakeZero: F_brake_at_wheel == 0
    * PbrakeZero: P_brake_front == 0

Scenario: Half brake pedal produces half of full outputs
  Linear system: 50% pedal should give 50% of full values.
  Given inputs
    * brake_cmd = const(0.5)
    * v_vehicle = const(27.8)
  When simulate for 100ms in Normal mode
  Then outputs
    * TauHalf: tau_brake == [600 .. 670]
    * FbrakeHalf: F_brake_at_wheel == [7500 .. 8350]
    * PbrakeHalf: P_brake_front == [52000 .. 58000]

Scenario: Zero vehicle speed produces zero thermal power
  Braking torque exists but no heat generated at zero speed.
  Given inputs
    * brake_cmd = const(1.0)
    * v_vehicle = const(0)
  When simulate for 100ms in Normal mode
  Then outputs
    * TauAtZeroV: tau_brake == [1200 .. 1340]
    * PbrakeAtZeroV: P_brake_front == 0
