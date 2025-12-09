% stepSim.m
% Simulate BasicModelingSimpleSystem with a step input and plot logged signal 'x'

% Simulation end time (seconds)
tEnd = 10;

% Create a step timeseries: 0 for t < 1, 1 for t >= 1
t = linspace(0, tEnd, 1001)';
u = double(t >= 1);
stepTS = timeseries(u, t);

% Package into a dataset for external input
ds = Simulink.SimulationData.Dataset;
ds{1} = stepTS;

% Create SimulationInput using the model name (Simulink will load the model automatically)
in = Simulink.SimulationInput('BasicModelingSimpleSystem');
in = in.setModelParameter('StopTime', num2str(tEnd));
in = in.setExternalInput(ds);

% Run simulation
out = sim(in);

% Plot the logged signal 'x'
plot(out.logsout.get('x').Values);
title('Logged signal: x');
xlabel('Time (s)');
grid on;
