function create_test_manager_suite()
%CREATE_TEST_MANAGER_SUITE Build Simulink Test Manager .mldatx test file.
%   Reimplements the scenarios from test_scenarios_matlab.m as Test Manager
%   simulation test cases with custom criteria.
%
%   Test suites:
%     1. Thermal Scenarios     - Fade test (15 stops), city driving (10 stops)
%     2. Energy Conservation   - Emergency-stop energy balance check
%     3. Numerical Robustness  - RelTol sweep and solver sweep
%     4. Parameter Sensitivity - Rotor mass sweep

%% Paths
projRoot  = fileparts(fileparts(mfilename('fullpath')));
testDir   = fileparts(mfilename('fullpath'));
inputDir  = fullfile(testDir, 'inputs');
if ~exist(inputDir, 'dir'), mkdir(inputDir); end

mdl = 'DiskBrakeThermal';

% Load parameters (needed for brake_level calculations)
run(fullfile(projRoot, 'disk_brake_thermal_params.m'));

% Clean up any previous test file
testFilePath = fullfile(testDir, 'DiskBrakeThermal_TestSuite.mldatx');
if isfile(testFilePath)
    delete(testFilePath);
end
sltest.testmanager.clear;
sltest.testmanager.clearResults;

%% ====================================================================
%  Generate input MAT files
%  ====================================================================

% Emergency stop input (shared by energy, robustness, sensitivity)
t_es = (0:0.01:10)';
n_es = length(t_es);
brake_es = ones(n_es,1);
brake_es(t_es > 4) = 0;
saveInputMAT(fullfile(inputDir, 'input_emergency_stop.mat'), ...
    t_es, brake_es, zeros(n_es,1), zeros(n_es,1), 25*ones(n_es,1));

% Fade test input (15 stops from 100 km/h)
decel_full = 4 * P_line_max * A_piston * 2 * mu_pad * R_eff / R_wheel / m_veh;
brake_level_fade = 4.0 / decel_full;

t_fade = (0:0.05:500)';
n_fade = length(t_fade);
brake_fade = zeros(n_fade,1);
accel_fade = zeros(n_fade,1);
t_cycle = 0;
for i = 1:15
    idx_b = (t_fade >= t_cycle) & (t_fade < t_cycle + 8);
    brake_fade(idx_b) = brake_level_fade;
    idx_a = (t_fade >= t_cycle + 9) & (t_fade < t_cycle + 28);
    accel_fade(idx_a) = 0.35;
    t_cycle = t_cycle + 30;
end
saveInputMAT(fullfile(inputDir, 'input_fade_test.mat'), ...
    t_fade, brake_fade, accel_fade, zeros(n_fade,1), 25*ones(n_fade,1));

% City driving input (10 stops from 50 km/h)
brake_level_city = 3.0 / decel_full;
t_city = (0:0.05:350)';
n_city = length(t_city);
brake_city = zeros(n_city,1);
accel_city = zeros(n_city,1);
t_cycle = 0;
for i = 1:10
    idx_b = (t_city >= t_cycle) & (t_city < t_cycle + 5);
    brake_city(idx_b) = brake_level_city;
    idx_a = (t_city >= t_cycle + 6) & (t_city < t_cycle + 14);
    accel_city(idx_a) = 0.15;
    t_cycle = t_cycle + 30;
end
saveInputMAT(fullfile(inputDir, 'input_city_driving.mat'), ...
    t_city, brake_city, accel_city, zeros(n_city,1), 25*ones(n_city,1));

%% ====================================================================
%  Create the test file
%  ====================================================================
tf = sltest.testmanager.TestFile(testFilePath);
tf.Description = ...
    'DiskBrakeThermal validation test suite (mirrors test_scenarios_matlab.m)';

% Remove the default test suite created automatically
defaultSuite = getTestSuiteByName(tf, 'New Test Suite 1');
if ~isempty(defaultSuite)
    remove(defaultSuite);
end

% PreloadFcn path for reuse
preloadCmd = sprintf( ...
    'run(fullfile(''%s'', ''disk_brake_thermal_params.m''));', ...
    strrep(projRoot, '\', '/'));

%% ====================================================================
%  Suite 1: Thermal Scenarios
%  ====================================================================
ts1 = createTestSuite(tf, 'Thermal Scenarios');
ts1.Description = 'Multi-stop thermal scenarios: fade and city driving';

% --- Fade Test 15 Stops ---
tc = createTestCase(ts1, 'simulation', 'Fade Test 15 Stops');
tc.Description = 'Fade test: 15 repeated stops from 100 km/h at ~0.4g';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 500);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 27.8);

inp = addInput(tc, fullfile(inputDir, 'input_fade_test.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor = test.sltest_simout.yout{1}.Values.Data;'
    'T_rotor_final = T_rotor(end);'
    'test.verifyGreaterThan(T_rotor_final, 100, ...'
    '    sprintf(''T_rotor final %.0f degC too low'', T_rotor_final));'
    'test.verifyLessThan(T_rotor_final, 700, ...'
    '    sprintf(''T_rotor final %.0f degC too high'', T_rotor_final));'
    }, newline);

% --- City Driving 10 Stops ---
tc = createTestCase(ts1, 'simulation', 'City Driving 10 Stops');
tc.Description = 'City driving: 10 stops from 50 km/h at ~0.3g';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 350);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 13.9);

inp = addInput(tc, fullfile(inputDir, 'input_city_driving.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor = test.sltest_simout.yout{1}.Values.Data;'
    'T_rotor_peak = max(T_rotor);'
    'T_rotor_final = T_rotor(end);'
    'test.verifyLessThan(T_rotor_peak, 200, ...'
    '    sprintf(''T_rotor peak %.0f degC exceeds 200 degC limit'', T_rotor_peak));'
    'test.verifyLessThan(T_rotor_final, 150, ...'
    '    sprintf(''T_rotor final %.0f degC not cooling toward ambient'', T_rotor_final));'
    }, newline);

%% ====================================================================
%  Suite 2: Energy Conservation
%  ====================================================================
ts2 = createTestSuite(tf, 'Energy Conservation');
ts2.Description = 'Verify thermal energy stored is physically consistent';

tc = createTestCase(ts2, 'simulation', 'Energy Conservation Emergency Stop');
tc.Description = 'Emergency stop: stored energy is positive and < vehicle KE';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 10);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 27.8);

inp = addInput(tc, fullfile(inputDir, 'input_emergency_stop.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor = test.sltest_simout.yout{1}.Values.Data;'
    'T_pad   = test.sltest_simout.yout{2}.Values.Data;'
    '% Parameters (from disk_brake_thermal_params.m)'
    'm_r = 6.0; c_r = 449; m_p = 0.30; c_p = 935; m_veh = 1700;'
    'E_stored_rotor = m_r * c_r * (T_rotor(end) - 25);'
    'E_stored_pad   = m_p * c_p * (T_pad(end) - 25);'
    'E_stored = E_stored_rotor + E_stored_pad;'
    'KE_total = 0.5 * m_veh * 27.8^2;'
    'test.verifyGreaterThan(E_stored, 0, ''Stored energy should be positive'');'
    'test.verifyLessThan(E_stored, KE_total, ...'
    '    ''Stored energy should be less than total vehicle KE'');'
    }, newline);

%% ====================================================================
%  Suite 3: Numerical Robustness
%  ====================================================================
ts3 = createTestSuite(tf, 'Numerical Robustness');
ts3.Description = 'Verify results are insensitive to solver settings';

% --- RelTol Sensitivity ---
tc = createTestCase(ts3, 'simulation', 'RelTol Sensitivity');
tc.Description = 'Emergency stop with RelTol = 1e-4, 1e-6, 1e-8';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 10);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 27.8);

inp = addInput(tc, fullfile(inputDir, 'input_emergency_stop.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

setProperty(tc, 'IterationScript', strjoin({
    'relTols = {''1e-6'', ''1e-4'', ''1e-8''};'
    'names   = {''RelTol_1e-6_baseline'', ''RelTol_1e-4_loose'', ''RelTol_1e-8_tight''};'
    'for k = 1:3'
    '    itr = sltestiteration;'
    '    itr.Name = names{k};'
    '    setTestParam(itr, ''PreLoadFcn'', ...'
    '        sprintf(''set_param(''''DiskBrakeThermal'''', ''''RelTol'''', ''''%s'''');'', relTols{k}));'
    '    addIteration(sltest_testCase, itr);'
    'end'
    }, newline));

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor_final = test.sltest_simout.yout{1}.Values.Data(end);'
    '% Each iteration must produce a physically reasonable result'
    'test.verifyGreaterThan(T_rotor_final, 25, ''T_rotor should exceed ambient'');'
    'test.verifyLessThan(T_rotor_final, 200, ''T_rotor should be below 200 degC'');'
    }, newline);

% --- Solver Sensitivity ---
tc = createTestCase(ts3, 'simulation', 'Solver Sensitivity');
tc.Description = 'Emergency stop with ode45 vs ode23t';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 10);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 27.8);

inp = addInput(tc, fullfile(inputDir, 'input_emergency_stop.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

setProperty(tc, 'IterationScript', strjoin({
    'solvers = {''ode45'', ''ode23t''};'
    'names   = {''ode45_baseline'', ''ode23t_alternative''};'
    'for k = 1:2'
    '    itr = sltestiteration;'
    '    itr.Name = names{k};'
    '    setTestParam(itr, ''PreLoadFcn'', ...'
    '        sprintf(''set_param(''''DiskBrakeThermal'''', ''''Solver'''', ''''%s'''');'', solvers{k}));'
    '    addIteration(sltest_testCase, itr);'
    'end'
    }, newline));

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor_final = test.sltest_simout.yout{1}.Values.Data(end);'
    'test.verifyGreaterThan(T_rotor_final, 25, ''T_rotor should exceed ambient'');'
    'test.verifyLessThan(T_rotor_final, 200, ''T_rotor should be below 200 degC'');'
    }, newline);

%% ====================================================================
%  Suite 4: Parameter Sensitivity
%  ====================================================================
ts4 = createTestSuite(tf, 'Parameter Sensitivity');
ts4.Description = 'Verify model responds correctly to parameter variations';

tc = createTestCase(ts4, 'simulation', 'Rotor Mass Sensitivity');
tc.Description = 'Emergency stop with m_r = 4.5, 6.0, 8.0 kg';
setProperty(tc, 'Model', mdl);
setProperty(tc, 'PreloadCallback', preloadCmd);
setProperty(tc, 'OverrideStopTime', true, 'StopTime', 10);

ps = addParameterSet(tc, 'Name', 'Initial Speed');
addParameterOverride(ps, 'v0', 27.8);

inp = addInput(tc, fullfile(inputDir, 'input_emergency_stop.mat'), ...
    'CreateIterations', false);
map(inp, 'Mode', 2);

setProperty(tc, 'IterationScript', strjoin({
    'masses = [4.5, 6.0, 8.0];'
    'names  = {''m_r_4p5kg'', ''m_r_6p0kg'', ''m_r_8p0kg''};'
    'for k = 1:3'
    '    itr = sltestiteration;'
    '    itr.Name = names{k};'
    '    setTestParam(itr, ''PreLoadFcn'', ...'
    '        sprintf(''assignin(''''base'''', ''''m_r'''', %.1f);'', masses(k)));'
    '    addIteration(sltest_testCase, itr);'
    'end'
    }, newline));

cc = getCustomCriteria(tc);
cc.Enabled = true;
cc.Callback = strjoin({
    'T_rotor = test.sltest_simout.yout{1}.Values.Data;'
    'T_rotor_peak = max(T_rotor);'
    'test.verifyGreaterThan(T_rotor_peak, 60, ...'
    '    sprintf(''T_peak %.1f degC too low'', T_rotor_peak));'
    'test.verifyLessThan(T_rotor_peak, 200, ...'
    '    sprintf(''T_peak %.1f degC too high'', T_rotor_peak));'
    }, newline);

%% ====================================================================
%  Save and display summary
%  ====================================================================
saveToFile(tf);

fprintf('\n=== Test Manager suite created ===\n');
fprintf('File: %s\n', testFilePath);
fprintf('Suites:\n');
suites = getTestSuites(tf);
for s = 1:numel(suites)
    fprintf('  %d. %s\n', s, suites(s).Name);
    cases = getTestCases(suites(s));
    for c = 1:numel(cases)
        fprintf('     - %s\n', cases(c).Name);
    end
end
fprintf('\nTo open: sltest.testmanager.load(''%s'');\n', testFilePath);
fprintf('         sltest.testmanager.view;\n');
fprintf('To run:  sltest.testmanager.run;\n\n');

end

%% =====================================================================
%  Local function: save input signals as MAT file with Dataset
%  =====================================================================
function saveInputMAT(filePath, t, brake_cmd, accel_cmd, theta_grade, T_amb)
    names   = {'brake_cmd', 'accel_cmd', 'theta_grade', 'T_amb'};
    signals = {brake_cmd,   accel_cmd,   theta_grade,   T_amb};
    ds = Simulink.SimulationData.Dataset;
    for k = 1:4
        ts_sig = timeseries(signals{k}, t);
        ts_sig.Name = names{k};
        ds = ds.addElement(ts_sig);
    end
    ext_input = ds; %#ok<NASGU>
    save(filePath, 'ext_input');
end
