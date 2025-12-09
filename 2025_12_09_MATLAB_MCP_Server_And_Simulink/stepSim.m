% stepSim.m
% Simulate BasicModelingSimpleSystem.slx with a step input and plot logged signal 'x'.
% Place this file in the same folder as BasicModelingSimpleSystem.slx and run by calling `stepSim`.

modelName = 'BasicModelingSimpleSystem';
modelFile = fullfile(pwd, [modelName '.slx']);

if ~exist(modelFile,'file')
    error('Model file "%s" not found in current folder: %s', [modelName '.slx'], pwd);
end

% Simulation parameters
tStop = 10;      % stop time (s)
dt = 0.01;       % sample interval for external input
stepTime = 1;    % time at which step goes from 0 -> 1

% Build external input as a two-column [time, value] matrix
t = (0:dt:tStop)';
u = double(t >= stepTime);
in = [t u];

% Load model (does not open the GUI by default)
load_system(modelFile);

% Run simulation using the external input. Use Dataset save format to capture
% logged signals (logsout) when available.
simOut = sim(modelName, ...
    'ExternalInput','in', ...
    'StopTime', num2str(tStop), ...
    'SaveOutput','on', ...
    'SaveFormat','Dataset');

% Attempt to extract logged signal 'x' from the common output containers
xTime = [];
xData = [];

% 1) Check logsout (SimulationData.Dataset)
if isfield(simOut,'logsout') && ~isempty(simOut.logsout)
    try
        logs = simOut.logsout;
        if isa(logs,'Simulink.SimulationData.Dataset')
            % try to get element named 'x'
            try
                el = logs.getElement('x');
                vals = el.Values;
                xTime = vals.Time;
                xData = vals.Data;
            catch
                % element may not exist; iterate to look for a matching name
                for k = 1:logs.numElements
                    el = logs.get(k-1);
                    if strcmp(el.Name,'x')
                        vals = el.Values;
                        xTime = vals.Time;
                        xData = vals.Data;
                        break
                    end
                end
            end
        end
    catch
    end
end

% 2) Check yout (StructureWithTime-style outputs)
if isempty(xData) && isfield(simOut,'yout')
    try
        yout = simOut.yout;
        if isstruct(yout) && isfield(yout,'signals')
            sigs = yout.signals;
            for i = 1:numel(sigs)
                if (isfield(sigs(i),'label') && strcmp(sigs(i).label,'x')) || (isfield(sigs(i),'name') && strcmp(sigs(i).name,'x'))
                    xTime = yout.time;
                    xData = sigs(i).values;
                    break
                end
            end
        end
    catch
    end
end

% 3) If still not found, give a helpful warning
if isempty(xData)
    warning("Could not find logged signal 'x' in simulation outputs.\n" + ...
        "Ensure the model logs signal 'x' (with Signal Logging or as an Outport),\n" + ...
        "and that the model root Inport accepts external input (used here).\n" + ...
        "You can open the model and enable signal logging for 'x'.");
    return
end

% Plot
figure('Name','Logged signal x','NumberTitle','off');
plot(xTime, xData, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('x');
title('Logged signal: x');
grid on;

% Close the model without saving changes
try
    close_system(modelName, 0);
catch
end
