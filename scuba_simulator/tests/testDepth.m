breathTestDepthV = 5:5:30;
N = length(breathTestDepthV);
in = repmat(Simulink.SimulationInput('breath_test'),N,1);
in = arrayfun(@(i) in(i).setVariable('breathTestDepth',breathTestDepthV(i)),1:N);
% simulate
out = sim(in,'ShowProgress','off','UseFastRestart','on');
% plot results
figure
hold on
for i = 1:N
    ts = out(i).logsout.get('Tank Pressure').Values;   % timeseries
    plot(ts.Time/60, ts.Data)                          % plot minutes vs data
end
hold off
labels = compose("Depth = %dm", breathTestDepthV);  % string array
legend(labels)
xlabel('Time (min)')
ylabel('Tank Pressure (PSI)')
title('Air consumption at different depths');