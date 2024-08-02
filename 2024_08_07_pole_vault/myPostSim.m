function simOut = myPostSim(simOut,simIn)
% Transfer input variables to SimulationOutput object
for i = 1:length(simIn.Variables)
    simOut.(simIn.Variables(i).Name) = simIn.Variables(i).Value;
end
% Compute key performance indicators
simOut.maxHeight = max(simOut.logsout.get('y').Values.Data);
simOut.distance = abs(simOut.logsout.get('x').Values.Data(end));