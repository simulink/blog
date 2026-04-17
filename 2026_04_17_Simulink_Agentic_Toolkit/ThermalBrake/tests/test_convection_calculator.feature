# --- front-matter:toml ---
model = "DiskBrakeThermal.slx"
component = "DiskBrakeThermal/ConvectionCalculator"
[inputs]
v_vehicle = "v_vehicle"
[outputs]
h_conv = "h_conv"
# --- end front-matter ---

Feature: ConvectionCalculator subsystem validation
  Verifies speed-dependent convection coefficient from Re^0.55 correlation.

Scenario: Zero speed returns natural convection floor
  At v=0, h_conv should equal h_nat = 8 W/m2K.
  Given inputs
    * v_vehicle = const(0)
  When simulate for 100ms in Normal mode
  Then outputs
    * NaturalConvection: h_conv == [7.5 .. 8.5]

Scenario: Highway speed gives moderate convection
  At v=30 m/s (108 km/h), h should be in 50-100 W/m2K range.
  Given inputs
    * v_vehicle = const(30)
  When simulate for 100ms in Normal mode
  Then outputs
    * HighwayConvection: h_conv == [30 .. 120]

Scenario: High speed gives strong convection
  At v=55 m/s (200 km/h), h should be in 80-200 W/m2K range.
  Given inputs
    * v_vehicle = const(55)
  When simulate for 100ms in Normal mode
  Then outputs
    * HighSpeedConvection: h_conv == [50 .. 200]

Scenario: Convection increases with speed
  Higher speed must produce higher h_conv than natural convection.
  Given inputs
    * v_vehicle = const(30)
  When simulate for 100ms in Normal mode
  Then outputs
    * ConvIncreases: h_conv > 10
