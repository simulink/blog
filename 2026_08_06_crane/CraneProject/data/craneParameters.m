function p = craneParameters()
%CRANEPARAMETERS Parameters for the Simscape gantry crane demo.

p.modelName = "crane_sm";

% Plant geometry and mass properties.
p.trolleyMass = 8.0;          % kg
p.payloadMass = 1.5;          % kg
p.pendulumLength = 1.4;       % m
p.payloadRadius = 0.12;       % m
p.trolleySize = [0.35 0.20 0.25]; % m, brick dimensions
p.railSize = [4.8 0.08 0.08];     % m, visual rail along global X

% Wall geometry. The model uses global X as horizontal travel and global Y
% as vertical height.
p.wallX = 1.45;               % m, horizontal travel coordinate (global X)
p.wallBaseY = -p.pendulumLength; % m, wall starts near the hanging payload height
p.wallHeight = 0.40;          % m
p.wallThickness = 0.10;       % m
p.wallWidth = 0.50;           % m

% Environment and contact.
p.gravity = 9.81;             % m/s^2, applied along -Y
% Default nominal demo treats the wall as a visual/clearance obstacle.
% Raise these values to enable physical collision response for failed cases.
p.contactStiffness = 0;       % N/m
p.contactDamping = 0;         % N/(m/s)
p.contactTransition = 1.0e-3; % m
p.contactThreshold = 1.0;     % N

% Actuator and maneuver.
p.forceMax = 60;              % N
p.forceAggressive = 90;       % N
p.pumpAmplitude = 48;         % N
p.pumpFrequencyScale = 0.96;  % multiplier on small-angle natural frequency
p.pumpDuration = 7.0;         % s
p.catchDuration = 10.0;       % s
p.stopTime = p.pumpDuration + p.catchDuration;
p.pumpControlAmplitude = 37.2; % N, default in-model pump command
p.pumpControlDuration = 7.6;   % s
p.pumpControlPhase = pi/5;     % rad
p.centerGain = 18;             % N/m, approach-side trolley centering
p.centerDamping = 10;          % N/(m/s)
p.transferForce = 60;          % N, transfer push after the bob is high
p.transferDamping = 8;         % N/(m/s)
p.transferClearance = 0.65;    % m, required height margin before transfer
p.postClearGain = 8;           % N/m, trolley hold gain after wall clearance
p.postClearDamping = 12;       % N/(m/s)
p.targetX = 3.0;              % m, final trolley coordinate on the far side
p.clearanceMargin = 0.05;     % m

% LQR weights for the analytical catch controller.
p.lqrQ = diag([25 4 90 8]);
p.lqrR = 0.25;
p.lqrScale = 0.12;
end
