classdef testBreath < matlab.unittest.TestCase & handle
    % testBreath Tests diver air consumption at different depths in the breath_test model.

    properties
        ModelName = 'breath_test'
        DepthVector = 5:5:30
        
        % Property to store simulation results for optional plotting
        SimulationResults
    end

    methods(TestMethodSetup)
        function loadModel(testCase)
            % Ensure the model is loaded but not open in UI
            load_system(testCase.ModelName);
            testCase.addTeardown(@() close_system(testCase.ModelName, 0));
        end
    end

    methods
        function runSimulation(testCase)
            % Programmatically run a parameter sweep over depths using Fast Restart
            load_system(testCase.ModelName);
            
            N = length(testCase.DepthVector);
            in = repmat(Simulink.SimulationInput(testCase.ModelName), N, 1);
            for i = 1:N
                in(i) = in(i).setVariable('breathTestDepth', testCase.DepthVector(i));
            end
            
            % Simulate with Fast Restart
            testCase.SimulationResults = sim(in, 'ShowProgress', 'off', 'UseFastRestart', 'on');
        end

        function plotResults(testCase)
            % Plot the already-cached simulation results instantly
            if isempty(testCase.SimulationResults)
                error('No simulation results found. Please call t.runSimulation first to populate results!');
            end

            N = length(testCase.DepthVector);
            figure('Name', 'Air Consumption Test Results', 'NumberTitle', 'off');
            hold on;
            for i = 1:N
                ts = testCase.SimulationResults(i).logsout.get('Tank Pressure').Values;
                plot(ts.Time/60, ts.Data, 'LineWidth', 1.5);
            end
            hold off;
            
            labels = compose("Depth = %dm", testCase.DepthVector);
            legend(labels, 'Location', 'best');
            grid on;
            xlabel('Time (min)');
            ylabel('Tank Pressure (PSI)');
            title('Air consumption at different depths');
        end
    end

    methods(Test)
        function testAirConsumptionAtDepths(testCase)
            % Execute the simulation sweep
            testCase.runSimulation();

            N = length(testCase.DepthVector);
            testCase.verifyEqual(length(testCase.SimulationResults), N, 'Should return results for all depths.');

            lastPressures = zeros(1, N);

            for i = 1:N
                ts = testCase.SimulationResults(i).logsout.get('Tank Pressure').Values;
                
                % 1. Verify tank pressure decreases over time
                testCase.verifyLessThan(ts.Data(end), ts.Data(1), ...
                    sprintf('Tank pressure should decrease at depth = %d m', testCase.DepthVector(i)));
                
                lastPressures(i) = ts.Data(end);
            end

            % 2. Verify gas consumption rate is higher (final pressure is lower) at greater depths
            % due to higher ambient density and molar flow demand.
            for i = 2:N
                testCase.verifyLessThan(lastPressures(i), lastPressures(i-1), ...
                    sprintf('Final tank pressure at %d m should be less than at %d m', ...
                    testCase.DepthVector(i), testCase.DepthVector(i-1)));
            end
        end
    end
end
