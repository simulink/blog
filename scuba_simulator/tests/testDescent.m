mdl = 'descent_test';
inflateVector = 0.75:0.01:0.8;
N = length(inflateVector);
in = repmat(Simulink.SimulationInput(mdl),N,1);
in = arrayfun(@(i) in(i).setVariable('InflateDT',inflateVector(i)),1:N);
out = sim(in,'ShowProgress','off','UseFastRestart','on');
figure
plot(out(1).logsout.get('Desired Depth').Values)
hold on
arrayfun(@(i) plot(out(i).logsout.get('Depth').Values),1:N);
hold off
labels = compose("Inflate duration = %d sec", inflateVector);  % string array
xlabel('Time (sec)')
ylabel('Depth (m)')