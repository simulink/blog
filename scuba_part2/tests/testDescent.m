classdef testDescent < matlab.unittest.TestCase & handle
    % testDescent Tests diver descent profiles under different BCD inflation durations.

    properties
        ModelName = 'descent_test'
        InflateVector = linspace(0.50,0.54,5)
        
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
            % Programmatically run a parameter sweep over inflation durations using Fast Restart
            load_system(testCase.ModelName);
            
            N = length(testCase.InflateVector);
            in = repmat(Simulink.SimulationInput(testCase.ModelName), N, 1);
            for i = 1:N
                in(i) = in(i).setVariable('InflateDT', testCase.InflateVector(i));
            end
            
            % Simulate with Fast Restart
            testCase.SimulationResults = sim(in, 'ShowProgress', 'off', 'UseFastRestart', 'on');
        end

        function plotResults(testCase)
            % Plot the already-cached simulation results instantly
            if isempty(testCase.SimulationResults)
                error('No simulation results found. Please call t.runSimulation first to populate results!');
            end

            N = length(testCase.InflateVector);
            figure('Name', 'Descent Test Results', 'NumberTitle', 'off');
            
            % Plot Desired Depth reference
            desiredDepth = testCase.SimulationResults(1).logsout.get('Desired Depth').Values;
            plot(desiredDepth, 'LineWidth', 1.5, 'LineStyle', '--', 'Color', 'r');
            hold on;
            
            % Plot depth trace for each inflation duration
            for i = 1:N
                depthTrace = testCase.SimulationResults(i).logsout.get('Depth').Values;
                plot(depthTrace, 'LineWidth', 1.5);
            end
            hold off;
            
            labels = ["Reference", compose("Inflate duration = %.2f sec", testCase.InflateVector)];
            grid on;
            set(gca, 'YDir', 'reverse')
            xlabel('Time (sec)');
            ylabel('Depth (m)');
            legend(labels, 'Location', 'best');
            title('Diver Descent Profiles');
        end
    end

    methods(Test)
        function testDescentProfiles(testCase)
            % Execute the simulation sweep
            testCase.runSimulation();

            N = length(testCase.InflateVector);
            testCase.verifyEqual(length(testCase.SimulationResults), N, 'Should return results for all inflation durations.');

            for i = 1:N
                depthTrace = testCase.SimulationResults(i).logsout.get('Depth').Values;
                
                % 1. Verify simulation executes successfully and outputs valid trace data
                testCase.verifyNotEmpty(depthTrace.Data, ...
                    sprintf('Depth trace should be populated for duration = %.2f s', testCase.InflateVector(i)));

                % 2. Verify diver descends past the starting point (typically ~0m depth)
                testCase.verifyGreaterThan(max(depthTrace.Data), 0.5, ...
                    sprintf('Diver should descend below surface for duration = %.2f s', testCase.InflateVector(i)));
            end
        end
    end
end
