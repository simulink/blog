classdef testFullDive < matlab.unittest.TestCase & handle
    % testFullDive Tests the closed-loop 1-hour dive profile and tracking accuracy.

    properties
        ModelName = 'fullDiveHarness'
        % Property to store simulation results for optional plotting
        SimulationResult
    end

    methods
        function runSimulation(testCase)
            evalin('base','initDiveController;');
            in = Simulink.SimulationInput(testCase.ModelName);
            testCase.SimulationResult = sim(in, 'ShowProgress', 'off');
        end

        function plotResults(testCase)
            % Plot the already-cached simulation results instantly
            if isempty(testCase.SimulationResult)
                error('No simulation results found. Please call t.runSimulation first to populate results!');
            end

            out = testCase.SimulationResult;
            depth   = out.logsout.get('depth').Values;
            ref     = out.logsout.get('depth_ref').Values;
            Vbcd    = out.logsout.get('Vbcd').Values;
            inflate = out.logsout.get('inflate').Values;
            deflate = out.logsout.get('deflate').Values;
            Vlung   = out.logsout.get('V_lung').Values;
            TankPressure = out.logsout.get('Tank Pressure').Values;

            figure('Name', 'Full Dive Results', 'NumberTitle', 'off');
            tiledlayout(5, 1, 'TileSpacing', 'compact');

            nexttile;
            plot(ref.Time/60, ref.Data, '--', depth.Time/60, depth.Data, 'LineWidth', 1.5);
            set(gca, 'YDir', 'reverse');
            ylabel('Depth (m)');
            legend('reference', 'actual', 'Location', 'southeast');
            grid on;
            title('1-hour dive: 18 m \rightarrow 12 m \rightarrow 5 m safety stop \rightarrow surface');

            nexttile;
            plot(Vbcd.Time/60, Vbcd.Data*1e3, 'LineWidth', 1.5);
            ylabel('V_{BCD} (L)');
            grid on;

            nexttile;
            plot(inflate.Time/60, inflate.Data, deflate.Time/60, deflate.Data, 'LineWidth', 1.5);
            ylabel('Valve cmd (0-1)');
            legend('inflate', 'deflate', 'Location', 'northeast');
            grid on;

            nexttile;
            plot(Vlung.Time/60, Vlung.Data*1e3, 'LineWidth', 1.5);
            ylabel('V_{lung} (L)');
            xlabel('Time (min)');
            grid on;

            nexttile;
            plot(TankPressure.Time/60, TankPressure.Data, 'LineWidth', 1.5);
            ylabel('Tank Pressure (PSI)');
            xlabel('Time (min)');
            grid on;
        end
    end

    methods(Test)
        function testDiveTrackingAccuracy(testCase)
            % Run full dive simulation
            testCase.runSimulation();
            
            out = testCase.SimulationResult;
            depth = out.logsout.get('depth').Values;
            ref   = out.logsout.get('depth_ref').Values;

            % 1. Verify simulation runs near expected duration (dive completes around 3400+ s)
            testCase.verifyGreaterThanOrEqual(depth.Time(end), 3400, 'Simulation should run until dive completion.');

            % Define holds to verify steady-state depth-tracking
            holds = [180 1500; 1680 2700; 2880 3180];   % s
            names = ["Bottom 18 m", "Bottom 12 m", "Safety stop 5 m"];

            for k = 1:size(holds, 1)
                tq = (holds(k,1):0.5:holds(k,2))';
                err = interp1(depth.Time, depth.Data, tq) - interp1(ref.Time, ref.Data, tq);
                
                % 2. Verify tracking error is within bounds during steady holds
                meanErr = mean(abs(err));
                maxErr = max(abs(err));
                
                testCase.verifyLessThan(meanErr, 0.5, ...
                    sprintf('%s hold mean tracking error should be < 0.5m (actual: %.2f m)', names(k), meanErr));
                testCase.verifyLessThan(maxErr, 1.5, ...
                    sprintf('%s hold max tracking error should be < 1.5m (actual: %.2f m)', names(k), maxErr));
            end
        end
    end
end
