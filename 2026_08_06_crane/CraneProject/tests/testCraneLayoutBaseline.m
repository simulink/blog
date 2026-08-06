function tests = testCraneLayoutBaseline()
%TESTCRANELAYOUTBASELINE Regression test for crane_sm layout refactors.

tests = functiontests(localfunctions);
end

function testCraneSmMatchesLayoutBaseline(testCase)
root = fileparts(fileparts(mfilename("fullpath")));
baselineFile = fullfile(root, "data", "baselines", ...
    "crane_sm_layout_baseline.mat");

verifyTrue(testCase, isfile(baselineFile), ...
    "Missing crane_sm layout baseline MAT file.");

data = load(baselineFile, "baseline");
baseline = data.baseline;

modelName = baseline.model;
modelFile = fullfile(root, "models", modelName + ".slx");
wasLoaded = bdIsLoaded(modelName);
if ~wasLoaded
    load_system(modelFile);
end
cleanup = onCleanup(@() closeIfTestLoaded(modelName, wasLoaded));

simOut = sim(modelName, ...
    "StopTime", baseline.stopTime, ...
    "ReturnWorkspaceOutputs", "on");

verifyEqual(testCase, simOut.tout, baseline.tout, "AbsTol", 1e-10);

for k = 1:numel(baseline.signalNames)
    signalName = char(baseline.signalNames{k});
    actual = getLoggedSignal(simOut.logsout, signalName);
    verifyTrue(testCase, isfield(baseline.signals, signalName), ...
        "Missing baseline data for " + string(signalName) + ".");
    expected = baseline.signals.(signalName);

    verifyEqual(testCase, actual.Time, expected.Time, "AbsTol", 1e-10, ...
        "Baseline time mismatch for " + string(signalName) + ".");
    verifyEqual(testCase, actual.Data, expected.Data, "AbsTol", 1e-7, ...
        "Baseline data mismatch for " + string(signalName) + ".");
end
end

function signal = getLoggedSignal(logsout, signalName)
index = find(strcmp(logsout.getElementNames, signalName), 1);
if isempty(index)
    error("testCraneLayoutBaseline:MissingSignal", ...
        "Signal '%s' was not found in logsout.", signalName);
end

element = logsout.getElement(index);
signal = element.Values;
end

function closeIfTestLoaded(modelName, wasLoaded)
if ~wasLoaded && bdIsLoaded(modelName)
    close_system(modelName, 0);
end
end
