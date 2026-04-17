classdef test_scenarios_matlab < matlab.unittest.TestCase
    % MATLAB-based tests for scenarios requiring complex time-varying inputs.
    % Covers: Fade Test, City Driving, Energy Conservation, Numerical Robustness.

    properties (Constant)
        ModelName = 'DiskBrakeThermal'
    end

    methods (TestClassSetup)
        function loadModel(testCase) %#ok<MANU>
            projRoot = fileparts(fileparts(mfilename('fullpath')));
            addpath(projRoot);
            run(fullfile(projRoot, 'disk_brake_thermal_params.m'));
        end
    end

    methods (Test)

        function testFadeTest15Stops(testCase)
            % Fade test: 15 repeated stops from 100 km/h at ~0.4g
            disk_brake_thermal_params;

            decel_full = 4 * P_line_max * A_piston * 2 * mu_pad * R_eff / R_wheel / m_veh;
            brake_level = 4.0 / decel_full;

            t_end = 500;
            dt = 0.05;
            t = (0:dt:t_end)';
            n = length(t);
            brake_signal = zeros(n,1);
            accel_signal = zeros(n,1);

            % Each cycle: brake for 8s, coast 1s, accel for 19s, coast 2s = 30s
            t_cycle = 0;
            for i = 1:15 %#ok<FXUP>
                idx_b = (t >= t_cycle) & (t < t_cycle + 8);
                brake_signal(idx_b) = brake_level;
                idx_a = (t >= t_cycle + 9) & (t < t_cycle + 28);
                accel_signal(idx_a) = 0.35;
                t_cycle = t_cycle + 30;
            end

            ds = test_scenarios_matlab.buildInputDataset(t, brake_signal, accel_signal, zeros(n,1), 25*ones(n,1));

            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', num2str(t_end));
            in = in.setVariable('v0', 27.8);
            in = in.setExternalInput(ds);

            out = sim(in);

            T_rotor = out.yout{1}.Values.Data;
            T_rotor_final = T_rotor(end);

            testCase.verifyGreaterThan(T_rotor_final, 100, ...
                sprintf('T_rotor final %.0f degC too low', T_rotor_final));
            testCase.verifyLessThan(T_rotor_final, 700, ...
                sprintf('T_rotor final %.0f degC too high', T_rotor_final));
        end

        function testCityDriving10Stops(testCase)
            % City driving: 10 stops from 50 km/h at ~0.3g
            disk_brake_thermal_params;

            decel_full = 4 * P_line_max * A_piston * 2 * mu_pad * R_eff / R_wheel / m_veh;
            brake_level = 3.0 / decel_full;

            t_end = 350;
            dt = 0.05;
            t = (0:dt:t_end)';
            n = length(t);
            brake_signal = zeros(n,1);
            accel_signal = zeros(n,1);

            % Each cycle: brake 5s, coast 1s, accel 8s, coast 16s = 30s
            t_cycle = 0;
            for i = 1:10 %#ok<FXUP>
                idx_b = (t >= t_cycle) & (t < t_cycle + 5);
                brake_signal(idx_b) = brake_level;
                idx_a = (t >= t_cycle + 6) & (t < t_cycle + 14);
                accel_signal(idx_a) = 0.15;
                t_cycle = t_cycle + 30;
            end

            ds = test_scenarios_matlab.buildInputDataset(t, brake_signal, accel_signal, zeros(n,1), 25*ones(n,1));

            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', num2str(t_end));
            in = in.setVariable('v0', 13.9);
            in = in.setExternalInput(ds);

            out = sim(in);

            T_rotor = out.yout{1}.Values.Data;
            T_rotor_peak = max(T_rotor);
            T_rotor_final = T_rotor(end);

            testCase.verifyLessThan(T_rotor_peak, 200, ...
                sprintf('T_rotor peak %.0f degC exceeds 200 degC limit', T_rotor_peak));
            testCase.verifyLessThan(T_rotor_final, 150, ...
                sprintf('T_rotor final %.0f degC not cooling toward ambient', T_rotor_final));
        end

        function testEnergyConservation(testCase)
            % Energy conservation check for emergency stop
            disk_brake_thermal_params;

            t_end = 10;
            dt = 0.01;
            t = (0:dt:t_end)';
            n = length(t);
            brake_signal = ones(n,1);
            brake_signal(t > 4) = 0;

            ds = test_scenarios_matlab.buildInputDataset(t, brake_signal, zeros(n,1), zeros(n,1), 25*ones(n,1));

            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', num2str(t_end));
            in = in.setVariable('v0', 27.8);
            in = in.setExternalInput(ds);

            out = sim(in);

            T_rotor = out.yout{1}.Values.Data;
            T_pad   = out.yout{2}.Values.Data;

            E_stored_rotor = m_r * c_r * (T_rotor(end) - 25);
            E_stored_pad   = m_p * c_p * (T_pad(end) - 25);
            E_stored = E_stored_rotor + E_stored_pad;

            KE_total = 0.5 * m_veh * 27.8^2;

            testCase.verifyGreaterThan(E_stored, 0, 'Stored energy should be positive');
            testCase.verifyLessThan(E_stored, KE_total, ...
                'Stored energy should be less than total vehicle KE');
        end

        function testNumericalRobustnessRelTol(testCase)
            % Run emergency stop with different solver tolerances
            disk_brake_thermal_params;

            [ds, t_end] = test_scenarios_matlab.buildEmergencyStopInput();

            % Build three SimulationInput objects with different RelTol
            tolerances = {'1e-6', '1e-4', '1e-8'};
            in = repmat(Simulink.SimulationInput(testCase.ModelName), 3, 1);
            for k = 1:3
                in(k) = Simulink.SimulationInput(testCase.ModelName);
                in(k) = in(k).setModelParameter('StopTime', num2str(t_end));
                in(k) = in(k).setModelParameter('RelTol', tolerances{k});
                in(k) = in(k).setVariable('v0', 27.8);
                in(k) = in(k).setExternalInput(ds);
            end

            out = sim(in);

            T_baseline = out(1).yout{1}.Values.Data(end);
            T_loose    = out(2).yout{1}.Values.Data(end);
            T_tight    = out(3).yout{1}.Values.Data(end);

            testCase.verifyEqual(T_loose, T_baseline, 'RelTol', 0.01, ...
                'Loose tolerance result should be within 1% of baseline');
            testCase.verifyEqual(T_tight, T_baseline, 'RelTol', 0.01, ...
                'Tight tolerance result should be within 1% of baseline');
        end

        function testNumericalRobustnessSolver(testCase)
            % Run emergency stop with ode23t instead of ode45
            disk_brake_thermal_params;

            [ds, t_end] = test_scenarios_matlab.buildEmergencyStopInput();

            in = repmat(Simulink.SimulationInput(testCase.ModelName), 2, 1);
            solvers = {'ode45', 'ode23t'};
            for k = 1:2
                in(k) = Simulink.SimulationInput(testCase.ModelName);
                in(k) = in(k).setModelParameter('StopTime', num2str(t_end));
                in(k) = in(k).setModelParameter('Solver', solvers{k});
                in(k) = in(k).setVariable('v0', 27.8);
                in(k) = in(k).setExternalInput(ds);
            end

            out = sim(in);

            T_baseline = out(1).yout{1}.Values.Data(end);
            T_alt      = out(2).yout{1}.Values.Data(end);

            testCase.verifyEqual(T_alt, T_baseline, 'RelTol', 0.01, ...
                'ode23t result should be within 1% of ode45 baseline');
        end

        function testParameterSensitivityRotorMass(testCase)
            % Vary rotor mass and check peak T_rotor stays in range
            disk_brake_thermal_params;

            [ds, t_end] = test_scenarios_matlab.buildEmergencyStopInput();

            mass_values = [4.5, 6.0, 8.0];
            N = numel(mass_values);
            in = repmat(Simulink.SimulationInput(testCase.ModelName), N, 1);
            for k = 1:N
                in(k) = Simulink.SimulationInput(testCase.ModelName);
                in(k) = in(k).setModelParameter('StopTime', num2str(t_end));
                in(k) = in(k).setVariable('v0', 27.8);
                in(k) = in(k).setVariable('m_r', mass_values(k));
                in(k) = in(k).setExternalInput(ds);
            end

            out = sim(in);

            T_peaks = zeros(1, N);
            for k = 1:N
                T_peaks(k) = max(out(k).yout{1}.Values.Data);
            end

            testCase.verifyGreaterThan(T_peaks(1), T_peaks(2), ...
                'Lighter rotor should peak hotter');
            testCase.verifyGreaterThan(T_peaks(2), T_peaks(3), ...
                'Heavier rotor should peak cooler');

            for k = 1:N
                testCase.verifyGreaterThan(T_peaks(k), 60, ...
                    sprintf('T_peak too low for m_r=%.1f kg', mass_values(k)));
                testCase.verifyLessThan(T_peaks(k), 200, ...
                    sprintf('T_peak too high for m_r=%.1f kg', mass_values(k)));
            end
        end
    end

    methods (Static, Access = private)
        function ds = buildInputDataset(t, brake_cmd, accel_cmd, theta_grade, T_amb)
            % Build a Simulink.SimulationData.Dataset with named timeseries
            % matching the model's Inport signal names.
            names = {'brake_cmd', 'accel_cmd', 'theta_grade', 'T_amb'};
            signals = {brake_cmd, accel_cmd, theta_grade, T_amb};
            ds = Simulink.SimulationData.Dataset;
            for k = 1:4
                ts = timeseries(signals{k}, t);
                ts.Name = names{k};
                ds = ds.addElement(ts);
            end
        end

        function [ds, t_end] = buildEmergencyStopInput()
            % Standard emergency stop input reused across tests.
            t_end = 10;
            dt = 0.01;
            t = (0:dt:t_end)';
            n = length(t);
            brake_signal = ones(n,1);
            brake_signal(t > 4) = 0;
            ds = test_scenarios_matlab.buildInputDataset(t, brake_signal, zeros(n,1), zeros(n,1), 25*ones(n,1));
        end
    end
end
