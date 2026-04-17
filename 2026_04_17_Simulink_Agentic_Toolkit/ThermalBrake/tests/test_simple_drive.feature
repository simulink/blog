# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/SimpleDrive"
[inputs]
accel_cmd = "accel_cmd"
[outputs]
F_drive = "F_drive"
# --- end front-matter ---

Feature: SimpleDrive subsystem validation
  Verifies accelerator pedal command maps linearly to drive force.

Scenario: Full throttle produces maximum drive force
  accel_cmd=1.0 should produce F_drive_max = 7000 N.
  Given inputs
    * accel_cmd = const(1.0)
  When simulate for 100ms in Normal mode
  Then outputs
    * FullThrottle: F_drive == 7000

Scenario: Zero throttle produces zero drive force
  Given inputs
    * accel_cmd = const(0)
  When simulate for 100ms in Normal mode
  Then outputs
    * ZeroThrottle: F_drive == 0

Scenario: Half throttle produces half drive force
  Given inputs
    * accel_cmd = const(0.5)
  When simulate for 100ms in Normal mode
  Then outputs
    * HalfThrottle: F_drive == 3500
