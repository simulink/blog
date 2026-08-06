function tests = testCraneValidation()
%TESTCRANEVALIDATION Basic executable checks for the crane project.

tests = functiontests(localfunctions);
end

function testParametersLoad(testCase)
p = craneParameters();
verifyGreaterThan(testCase, p.pendulumLength, 0);
verifyGreaterThan(testCase, p.payloadMass, 0);
verifyGreaterThanOrEqual(testCase, p.contactStiffness, 0);
end

function testLqrGain(testCase)
p = craneParameters();
K = designLQRCatchController(p);
verifySize(testCase, K, [1 4]);
verifyTrue(testCase, all(isfinite(K)));
end

function testPumpProfile(testCase)
p = craneParameters();
[forceCmd, result] = tunePumpManeuver(p);
verifyGreaterThan(testCase, numel(forceCmd.Time), 100);
verifyLessThanOrEqual(testCase, max(abs(forceCmd.Data)), p.forceMax + 1e-9);
verifyTrue(testCase, isfield(result, "peakForce"));
end

function testControllerData(testCase)
ctrl = setupCraneController();
root = fileparts(fileparts(mfilename("fullpath")));
verifyTrue(testCase, isfile(fullfile(root, "data", "craneControllerData.mat")));
verifySize(testCase, ctrl.K, [1 4]);
end
