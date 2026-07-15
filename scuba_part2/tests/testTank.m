classdef testTank < matlab.unittest.TestCase & handle
    % testTank Tests the Simscape GasTank block under constant discharge.

    properties
        ModelName = 'tank_test'
        BlockPath = 'tank_test/GasTank'
        
        % Properties to store simulation results for optional plotting
        n_tank_data
        f_data
        p_data
    end

    methods

        function runSimulation(testCase)

            % Run simulation (sim will auto-load)
            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', '10');
            out = sim(in);

            % Save timeseries results to properties
            ds = out.logsout;
            testCase.n_tank_data = ds.get('n_tank').Values;
            testCase.f_data = ds.get('f').Values;
            testCase.p_data = ds.get('A.p').Values;
        end

        function plotResults(testCase)
            % Plot the already-cached simulation results instantly
            if isempty(testCase.p_data) || isempty(testCase.n_tank_data) || isempty(testCase.f_data)
                error('No simulation results found. Please call t.runSimulation first to populate results!');
            end

            % Create Figure & Plot
            figure('Name', 'Gas Tank Test Results', 'NumberTitle', 'off');
            
            subplot(3, 1, 1);
            plot(testCase.p_data.Time, testCase.p_data.Data / 1e5, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
            grid on;
            title('Gas Tank Discharge Dynamics');
            ylabel('Pressure (bar)');
            
            subplot(3, 1, 2);
            plot(testCase.n_tank_data.Time, testCase.n_tank_data.Data, 'LineWidth', 1.5, 'Color', [0 0.44 0.74]);
            grid on;
            ylabel('Gas Quantity (mol)');
            
            subplot(3, 1, 3);
            plot(testCase.f_data.Time, testCase.f_data.Data, 'LineWidth', 1.5, 'Color', [0.46 0.67 0.18]);
            grid on;
            ylabel('Weight Force (N)');
            xlabel('Time (s)');
        end
    end

    methods(Test)
        function testInitialMoles(testCase)
            % Ensure initial moles match the parameter spec (n_init = 98.47 mol)
            testCase.runSimulation();
            testCase.verifyEqual(testCase.n_tank_data.Data(1), 98.47, AbsTol=1e-3);
        end

        function testMolesDecrease(testCase)
            % Verify that moles decrease continuously as gas flows out
            testCase.runSimulation();
            testCase.verifyLessThan(testCase.n_tank_data.Data(end), testCase.n_tank_data.Data(1));
        end

        function testPressureDecreases(testCase)
            % Verify that pressure decreases continuously
            testCase.runSimulation();
            testCase.verifyLessThan(testCase.p_data.Data(end), testCase.p_data.Data(1));
        end

        % 4. Verify that the weight force f decreases as the gas leaves
        function testWeightForceDecreases(testCase)
            testCase.runSimulation();
            testCase.verifyLessThan(testCase.f_data.Data(end), testCase.f_data.Data(1));
        end
        
        % 5. Verify weight force is directly proportional to moles
        function testWeightProportionalToMoles(testCase)
            testCase.runSimulation();
            expected_ratio = 0.029 * 9.80665;
            actual_ratio = testCase.f_data.Data ./ testCase.n_tank_data.Data;
            testCase.verifyEqual(actual_ratio, repmat(expected_ratio, size(actual_ratio)), AbsTol=1e-2);
        end
    end
end
