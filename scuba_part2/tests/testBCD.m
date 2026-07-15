classdef testBCD < matlab.unittest.TestCase & handle
    % testBCD Tests the Simscape BCDBladder block under constant inflation.

    properties
        ModelName = 'bcd_test'
        BlockPath = 'bcd_test/BCDBladder'
        
        % Properties to store simulation results for optional plotting
        n_bcd_data
        V_bcd_data
        p_excess_data
        f_data
    end


    methods

        function runSimulation(testCase, inflateFlow)
            % Programmatically configure logging and run simulation to populate properties
            % Supports optional inflateFlow (defaults to 0.1 mol/s if omitted)
            arguments
                testCase
                inflateFlow (1,1) double = 0.1
            end

            % Configure simulation input with specific commanded flow rate
            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', '10');
            in = in.setBlockParameter([testCase.ModelName '/ConstantFlow'], 'Value', num2str(inflateFlow));
            out = sim(in);

            ds = out.logsout;
            testCase.n_bcd_data = ds.get('n_bcd').Values;
            testCase.V_bcd_data = ds.get('V_bcd').Values;
            testCase.p_excess_data = ds.get('P_excess').Values;
            testCase.f_data = ds.get('f').Values;
        end

        function plotResults(testCase)
            % % Run this to prepare the data
            % testCase.runSimulation(0)
            % testCase.runSimulation()

            % Plot the already-cached simulation results instantly
            if isempty(testCase.n_bcd_data) || isempty(testCase.V_bcd_data) || isempty(testCase.f_data)
                error('No simulation results found. Please call t.runSimulation first to populate results!');
            end

            % Create Figure & Plot
            figure('Name', 'BCD Bladder Test Results', 'NumberTitle', 'off');
            
            subplot(4, 1, 1);
            plot(testCase.n_bcd_data.Time, testCase.n_bcd_data.Data, 'LineWidth', 1.5, 'Color', [0 0.44 0.74]);
            grid on;
            title('BCD Bladder Inflation Dynamics');
            ylabel('Moles (mol)');
            
            subplot(4, 1, 2);
            plot(testCase.V_bcd_data.Time, testCase.V_bcd_data.Data * 1000, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
            grid on;
            ylabel('Volume (Liters)');
            
            subplot(4, 1, 3);
            plot(testCase.p_excess_data.Time, testCase.p_excess_data.Data / 1e5, 'LineWidth', 1.5, 'Color', [0.49 0.18 0.56]);
            grid on;
            ylabel('Excess P (bar)');
            
            subplot(4, 1, 4);
            plot(testCase.f_data.Time, testCase.f_data.Data, 'LineWidth', 1.5, 'Color', [0.46 0.67 0.18]);
            grid on;
            ylabel('Buoyancy Force (N)');
            xlabel('Time (s)');
        end
    end

    methods(Test)
        function testEmptyBCDBladder(testCase)
            % Verify that BCD remains empty under zero flow rate command
            testCase.runSimulation(0);

            % Assert empty properties
            testCase.verifyEqual(testCase.n_bcd_data.Data(end), 0.0, AbsTol=1e-3);
            testCase.verifyEqual(testCase.V_bcd_data.Data(end), 0.0, AbsTol=1e-4);
            testCase.verifyEqual(testCase.f_data.Data(end), 0.0, AbsTol=1e-2);
        end

        function testBCDInflationDynamics(testCase)
            % Verify BCD inflation with default 0.1 mol/s flow
            testCase.runSimulation();

            % 1. Moles should increase continuously
            testCase.verifyGreaterThan(testCase.n_bcd_data.Data(end), testCase.n_bcd_data.Data(1));

            % 2. Actual volume should increase and clamp precisely at V_max = 0.015 m^3
            testCase.verifyEqual(testCase.V_bcd_data.Data(end), 0.015, AbsTol=1e-3);

            % 3. Once full, excess elastic pressure should start developing (P_excess > 0)
            % Flow rate is 0.1 mol/s. Over 10s, 1.0 mol is injected.
            % V_free = n*R*T/P_amb = 1.0 * 8.314 * 293.15 / 101325 = ~0.024 m^3.
            % Since V_free > V_max, BCD is fully stretched and P_excess > 0.
            testCase.verifyGreaterThan(testCase.p_excess_data.Data(end), 0.0);

            % 4. Buoyancy force should clamp corresponding to V_max = 15 Liters
            % F_buoy = -rho_water * g * V_max = -1025 * 9.80665 * 0.015 = -150.777 N
            testCase.verifyEqual(testCase.f_data.Data(end), -150.8, AbsTol=1e-1);
        end
    end
end
