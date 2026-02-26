%% coffee_mug_params.m
% Parameters for the Simscape 1D thermal model of a cooling coffee mug.
% Run this script before simulating to load all variables into the
% base workspace.

%% Materials
m_coffee   = 0.25;    % kg        — mass of coffee (250 mL ≈ 250 g)
cp_water   = 4186;    % J/(kg·K)  — specific heat of water
m_mug      = 0.35;    % kg        — mass of ceramic mug
cp_ceramic = 840;     % J/(kg·K)  — specific heat of ceramic

%% Thermal capacitances
C_coffee = m_coffee * cp_water;    % J/K  ≈ 1047
C_mug    = m_mug    * cp_ceramic;  % J/K  ≈ 294

%% Convective conductances  (G = h * A,  W/K)
% Inner surface: coffee → mug wall  (moderate natural convection in liquid)
h_int  = 50;           % W/(m²·K)
A_int  = 0.025;        % m²
hA_int = h_int * A_int;  % W/K  ≈ 1.25

% Outer surface: mug wall → ambient air  (natural convection)
h_ext  = 10;           % W/(m²·K)
A_ext  = 0.050;        % m²
hA_ext = h_ext * A_ext;  % W/K  ≈ 0.50

% Top surface: coffee → ambient air directly  (open top of mug)
h_top  = 10;           % W/(m²·K)
A_top  = 0.020;        % m²
hA_top = h_top * A_top;  % W/K  ≈ 0.20

%% Radiation parameters
epsilon = 0.9;         % —          emissivity (ceramic / water surface)
sigma   = 5.67e-8;     % W/(m²·K⁴) Stefan-Boltzmann constant

% Radiative coefficient used in Simscape Radiative Heat Transfer block:
%   rad_tr_coeff = epsilon * sigma   [W/(m²·K⁴)]
rad_coeff = epsilon * sigma;   % ≈ 5.1e-8  W/(m²·K⁴)

% Radiating areas
A_rad_mug = 0.040;     % m²  — mug outer surface
A_rad_top = 0.008;     % m²  — exposed coffee top surface

%% Temperatures
T_init = 363;   % K   — initial coffee & mug temperature  (90 °C)
T_amb  = 293;   % K   — ambient air temperature           (20 °C)

%% Display summary
fprintf('--- Coffee Mug Thermal Parameters ---\n')
fprintf('  C_coffee : %.0f J/K\n', C_coffee)
fprintf('  C_mug    : %.0f J/K\n', C_mug)
fprintf('  hA_int   : %.3f W/K\n', hA_int)
fprintf('  hA_ext   : %.3f W/K\n', hA_ext)
fprintf('  hA_top   : %.3f W/K\n', hA_top)
fprintf('  rad_coeff: %.3e W/(m2·K4)\n', rad_coeff)
fprintf('  T_init   : %.0f K  (%.0f degC)\n', T_init, T_init-273.15)
fprintf('  T_amb    : %.0f K  (%.0f degC)\n', T_amb,  T_amb -273.15)
