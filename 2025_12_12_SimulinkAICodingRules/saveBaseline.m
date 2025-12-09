% saveBaseline.m
% Simulate BasicModelingSimpleSystem with a step input and save signal 'x' to MAT-file for baseline validation

tEnd = 10;
t = linspace(0, tEnd, 1001)';
u = double(t >= 1);
stepTS = timeseries(u, t);
ds = Simulink.SimulationData.Dataset;
ds{1} = stepTS;

in = Simulink.SimulationInput('BasicModelingSimpleSystem');
in = in.setModelParameter('StopTime', num2str(tEnd));
in = in.setExternalInput(ds);

out = sim(in);

x_baseline = out.logsout.get('x').Values;
save('x_baseline.mat', 'x_baseline');
