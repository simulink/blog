function simOut = runCraneDemo()
%RUNCRANEDEMO Build, tune, simulate, and plot the crane demo.

root = fileparts(fileparts(mfilename("fullpath")));
addpath(fullfile(root, "data"), fullfile(root, "scripts"));
p = craneParameters();
setupCraneController();

modelFile = fullfile(root, "models", p.modelName + ".slx");
if ~isfile(modelFile)
    buildCraneSimscapeModel();
end

open_system(modelFile);
simOut = sim(p.modelName, "StopTime", num2str(p.stopTime));
metrics = analyzeCraneClearance(p, simOut);
fprintf("Simscape clearance: min crossing %.3g m across %d crossing(s); max contact %.3g N\n", ...
    metrics.minCrossingClearance, metrics.crossingCount, metrics.maxContactForce);
plotCraneResults(p, metrics, simOut);
end
