%% Disk Brake Thermal Model - Parameter Initialization Script
% Parameters from architecture spec §A7

%% Rotor Parameters
m_r     = 6.0;      % Rotor mass [kg]
c_r     = 449;      % Rotor specific heat [J/(kg·K)]
k_r     = 50;       % Rotor thermal conductivity [W/(m·K)]
rho_r   = 7200;     % Rotor density [kg/m³]
R_outer = 0.14;     % Rotor outer radius [m]
t_rotor = 0.012;    % Rotor thickness [m]
A_rotor = 0.12;     % Rotor cooling surface area [m²]
eps_r   = 0.40;     % Rotor emissivity [-]

%% Pad Parameters
m_p     = 0.30;     % Pad mass (one pad) [kg]
c_p     = 935;      % Pad specific heat [J/(kg·K)]
k_p     = 8.7;      % Pad thermal conductivity [W/(m·K)]
rho_p   = 2000;     % Pad density [kg/m³]
t_pad   = 0.012;    % Pad thickness [m]
A_contact = 0.004;  % Pad contact area [m²]

%% Backing Plate Parameters
m_b     = 0.25;     % Backing plate mass [kg]
c_b     = 490;      % Backing plate specific heat [J/(kg·K)]
k_b     = 45;       % Backing plate conductivity [W/(m·K)]
t_b     = 0.005;    % Backing plate thickness [m]
A_backing = 0.004;  % Backing plate area [m²]

%% Physical Constants
sigma   = 5.67e-8;  % Stefan-Boltzmann constant [W/(m²·K⁴)]

%% Convection Parameters
h_nat   = 8;        % Natural convection coefficient [W/(m²·K)]
D       = 0.28;     % Rotor diameter for Re calculation [m]
k_air   = 0.026;    % Air thermal conductivity [W/(m·K)]
rho_air = 1.17;     % Air density for convection [kg/m³]
mu_air  = 1.8e-5;   % Air viscosity [Pa·s]
c_air   = 1005;     % Air specific heat [J/(kg·K)]

%% Heat Partition
% Limpert Eq. 3-17 gives gamma ~0.95 for typical cast iron / semi-metallic
% pad combinations. Override computed value to match literature.
gamma   = 0.95;

%% Conductive Coupling
k_cond_rp = k_p * A_contact / t_pad;   % Rotor-pad conductive coupling [W/K]
k_cond_pb = k_b * A_backing / t_b;     % Pad-backing conductive coupling [W/K]

%% Brake Hydraulics Parameters
P_line_max = 120e5;   % Max hydraulic line pressure [Pa] (120 bar)
A_piston   = 0.0012;  % Piston area [m²] (~12 cm², sized for ~1g max decel)
mu_pad     = 0.40;    % Pad friction coefficient [-]
R_eff      = 0.11;    % Effective friction radius [m]

%% Simple Drive Parameters
F_drive_max = 7000;   % Max traction force [N]

%% Vehicle Parameters
m_veh       = 1700;   % Vehicle mass [kg]
R_wheel     = 0.32;   % Wheel radius [m]
Cd_A        = 0.72;   % Drag coefficient x frontal area [m²]
rho_air_drag = 1.225; % Air density for drag [kg/m³]
Cr          = 0.012;  % Rolling resistance coefficient [-]
g           = 9.81;   % Gravitational acceleration [m/s²]
v0          = 27.8;   % Initial vehicle speed [m/s] (100 km/h)

%% Initial Conditions
T_amb_init  = 25;     % Initial/ambient temperature [°C]
