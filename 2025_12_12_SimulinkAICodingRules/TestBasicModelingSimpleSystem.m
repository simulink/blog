classdef TestBasicModelingSimpleSystem < matlab.unittest.TestCase
    % Test class for baseline validation of BasicModelingSimpleSystem.slx
    methods (Test)
        function testBaselineX(testCase)
            % Simulation end time
            tEnd = 10;
            t = linspace(0, tEnd, 1001)';
            u = double(t >= 1);
            stepTS = timeseries(u, t);
            ds = Simulink.SimulationData.Dataset;
            ds{1} = stepTS;

            in = Simulink.SimulationInput('BasicModelingSimpleSystem');
            in = in.setModelParameter('StopTime', num2str(tEnd));
            in = in.setExternalInput(ds);

            out = sim(in);
            x_actual = out.logsout.get('x').Values;

            % Load baseline
            baseline = load('x_baseline.mat', 'x_baseline');
            x_baseline = baseline.x_baseline;

            % Compare signals (allowing for small numerical differences)
            testCase.verifyEqual(x_actual.Data, x_baseline.Data, 'AbsTol', 1e-8);
            testCase.verifyEqual(x_actual.Time, x_baseline.Time, 'AbsTol', 1e-8);
        end
    end
end
