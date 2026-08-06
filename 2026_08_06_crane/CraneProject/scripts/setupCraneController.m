function ctrl = setupCraneController()
%SETUPCRANECONTROLLER Generate and load controller data for the crane demo.

p = craneParameters();
ctrl = struct();
ctrl.K = designLQRCatchController(p);
ctrl.forceMax = p.forceMax;
ctrl.pendulumLength = p.pendulumLength;
ctrl.wallX = p.wallX;
ctrl.wallTop = p.wallBaseY + p.wallHeight;
ctrl.clearanceMargin = p.clearanceMargin;
ctrl.transferClearance = p.transferClearance;
ctrl.pumpControlAmplitude = p.pumpControlAmplitude;
ctrl.pumpControlDuration = p.pumpControlDuration;
ctrl.pumpControlPhase = p.pumpControlPhase;
ctrl.pumpFrequency = p.pumpFrequencyScale * sqrt(p.gravity / p.pendulumLength);
ctrl.centerGain = p.centerGain;
ctrl.centerDamping = p.centerDamping;
ctrl.transferForce = p.transferForce;
ctrl.transferDamping = p.transferDamping;
ctrl.postClearGain = p.postClearGain;
ctrl.postClearDamping = p.postClearDamping;
ctrl.targetX = p.targetX;
ctrl.lqrScale = p.lqrScale;

root = fileparts(fileparts(mfilename("fullpath")));
matFile = fullfile(root, "data", "craneControllerData.mat");

ctrl_K = ctrl.K;
ctrl_forceMax = ctrl.forceMax;
ctrl_pendulumLength = ctrl.pendulumLength;
ctrl_wallX = ctrl.wallX;
ctrl_wallTop = ctrl.wallTop;
ctrl_clearanceMargin = ctrl.clearanceMargin;
ctrl_transferClearance = ctrl.transferClearance;
ctrl_pumpControlAmplitude = ctrl.pumpControlAmplitude;
ctrl_pumpControlDuration = ctrl.pumpControlDuration;
ctrl_pumpControlPhase = ctrl.pumpControlPhase;
ctrl_pumpFrequency = ctrl.pumpFrequency;
ctrl_centerGain = ctrl.centerGain;
ctrl_centerDamping = ctrl.centerDamping;
ctrl_transferForce = ctrl.transferForce;
ctrl_transferDamping = ctrl.transferDamping;
ctrl_postClearGain = ctrl.postClearGain;
ctrl_postClearDamping = ctrl.postClearDamping;
ctrl_targetX = ctrl.targetX;
ctrl_lqrScale = ctrl.lqrScale;

save(matFile, "ctrl_*");
load(matFile, "ctrl_*");
assignin("base", "ctrl_K", ctrl_K);
assignin("base", "ctrl_forceMax", ctrl_forceMax);
assignin("base", "ctrl_pendulumLength", ctrl_pendulumLength);
assignin("base", "ctrl_wallX", ctrl_wallX);
assignin("base", "ctrl_wallTop", ctrl_wallTop);
assignin("base", "ctrl_clearanceMargin", ctrl_clearanceMargin);
assignin("base", "ctrl_transferClearance", ctrl_transferClearance);
assignin("base", "ctrl_pumpControlAmplitude", ctrl_pumpControlAmplitude);
assignin("base", "ctrl_pumpControlDuration", ctrl_pumpControlDuration);
assignin("base", "ctrl_pumpControlPhase", ctrl_pumpControlPhase);
assignin("base", "ctrl_pumpFrequency", ctrl_pumpFrequency);
assignin("base", "ctrl_centerGain", ctrl_centerGain);
assignin("base", "ctrl_centerDamping", ctrl_centerDamping);
assignin("base", "ctrl_transferForce", ctrl_transferForce);
assignin("base", "ctrl_transferDamping", ctrl_transferDamping);
assignin("base", "ctrl_postClearGain", ctrl_postClearGain);
assignin("base", "ctrl_postClearDamping", ctrl_postClearDamping);
assignin("base", "ctrl_targetX", ctrl_targetX);
assignin("base", "ctrl_lqrScale", ctrl_lqrScale);
end
