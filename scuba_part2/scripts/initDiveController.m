% initDiveController - Workspace parameters for the Dive Trajectory and
% Dive Controller subsystems in fullDiveHarness.slx.
%
% Trajectory: multilevel 1-hour recreational profile (18 m -> 12 m ->
% 5 m safety stop -> surface). Controller: feedforward BCD volume table
% plus breathing-primary depth regulation (see docs/dive_controller_plan.md).

%% Dive profile: time (s) -> depth reference (m), linear interpolation
profile_t     = [0    120  1500 1620 2700 2880 3180 3480];
profile_depth = [0.5  18   18   12   12   5    5    0];

% Velocity feedforward: piecewise-constant profile slope (m/s, +down).
% Breakpoints are segment start times; lookup uses flat interpolation.
vff_t = profile_t(1:end-1);
vff_v = diff(profile_depth) ./ diff(profile_t);
% Hold zero after the profile ends (flat interp extrapolates last value)
vff_t(end+1) = profile_t(end);
vff_v(end+1) = 0;

%% Plant constants used by the controller design
rho_water = 1025;        % kg/m^3
g         = 9.81;        % m/s^2

%% Feedforward BCD neutral-volume table: depth (m) -> V_bcd (m^3)
% Analytic force balance at mean lung volume (start-of-dive tank load):
%   0 = F_body_net - W_weights - W_tankgas + rho*g*V_mean + rho*g*V_bcd
% Depth-independent today (no wetsuit compression modeled); tabulated over
% depth so wetsuit compression can be added later without restructuring.
V_body     = 0.065;              % m^3
rho_body   = 985;                % kg/m^3
m_weights  = 4;                  % kg
n_tank0    = 98.47;              % mol (full tank)
M_gas      = 0.029;              % kg/mol
V_mean     = 2.75e-3;            % m^3, mean lung volume

F_body_net = g * V_body * (rho_water - rho_body);          % +25.5 N up
W_weights  = m_weights * g;                                % 39.2 N down
W_tankgas  = n_tank0 * M_gas * g;                          % 28.0 N down
F_lung     = rho_water * g * V_mean;                       % 27.7 N up

V_bcd_neutral = (W_weights + W_tankgas - F_body_net - F_lung) / (rho_water * g);

ff_depths = [0 45];                          % m
ff_Vbcd   = V_bcd_neutral * [1 1];           % m^3 (flat: ~1.40e-3)

%% Breathing controller (primary fine control at constant depth)
Kp_b       = 1.5e-3;     % m^3 lung trim per m depth error
Kd_b       = 3e-3;       % m^3 lung trim per m/s velocity error
trim_max   = 0.75e-3;    % m^3, breathing trim authority (+-0.75 L)
V_tidal    = 0.25e-3;    % m^3, tidal sine amplitude (0.5 L peak-to-peak)
w_breath   = 2*pi*0.2;   % rad/s, 12 breaths/min
V_lung_min = 1.5e-3;     % m^3, residual volume
V_lung_max = 4.5e-3;     % m^3, total lung capacity
tau_lung   = 0.5;        % s, lung volume response lag (also breaks the
                         % algebraic loop between V_lung and plant outputs)

%% BCD volume reference shaping
K_vff    = 1e-3;         % m^3 per m/s: less volume descending, more ascending
V_bcd_max = 15e-3;       % m^3, bladder capacity (reference saturation)

clear V_body rho_body m_weights n_tank0 M_gas F_body_net W_weights W_tankgas F_lung
