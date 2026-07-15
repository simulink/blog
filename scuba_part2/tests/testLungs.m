classdef testLungs < matlab.unittest.TestCase & handle
    % testLungs Tests the Simscape Lungs block under volume command variations.

    properties
        ModelName = 'lungs_test'
        BlockPath = 'lungs_test/Lungs'
        
        % Properties to store simulation results for optional plotting
        V_nom_data
        p_nom_data
        f_nom_data
        
        V_inh_data
        p_inh_data
        f_inh_data
    end

    methods
        function runSimulation(testCase, volumeValue)
            % Programmatically configure logging and run simulation to populate properties
            % Supports optional volumeValue (defaults to 1.5e-3 nominal if omitted)
            arguments
                testCase
                volumeValue (1,1) double = 1.5e-3
            end

            % Configure simulation input with specific commanded volume (1.5e-3 or 3.0e-3)
            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', '10');
            in = in.setBlockParameter([testCase.ModelName '/ConstantVol'], 'Value', num2str(volumeValue));
            out = sim(in);

            ds = out.logsout;
            if volumeValue == 1.5e-3
                testCase.V_nom_data = ds.get('V_lungs').Values;
                testCase.f_nom_data = ds.get('f').Values;
                testCase.p_nom_data = ds.get('P_lung').Values;
            else
                testCase.V_inh_data = ds.get('V_lungs').Values;
                testCase.f_inh_data = ds.get('f').Values;
                testCase.p_inh_data = ds.get('P_lung').Values;
            end
        end

        function plotResults(testCase)
            % % Run simulations with:
            % t.runSimulation(1.5e-3)
            % t.runSimulation(3.0e-3)
            % Plot the already-cached simulation results instantly
            if isempty(testCase.p_nom_data) || isempty(testCase.p_inh_data) || isempty(testCase.f_nom_data) || isempty(testCase.f_inh_data)
                error('No simulation results found. Please run both t.runSimulation(1.5e-3) and t.runSimulation(3.0e-3) first to populate results!');
            end

            % Create Figure & Plot
            figure('Name', 'Lungs Dynamics Test Results', 'NumberTitle', 'off');
            
            subplot(2, 1, 1);
            plot(testCase.p_nom_data.Time, testCase.p_nom_data.Data / 1e5, 'LineWidth', 1.5, 'Color', [0 0.44 0.74]);
            hold on;
            plot(testCase.p_inh_data.Time, testCase.p_inh_data.Data / 1e5, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
            grid on;
            title('Lungs Expansion Dynamics');
            ylabel('Pressure (bar)');
            legend('Nominal (1.5L)', 'Inhalation (3.0L)');
            
            subplot(2, 1, 2);
            plot(testCase.f_nom_data.Time, testCase.f_nom_data.Data, 'LineWidth', 1.5, 'Color', [0 0.44 0.74]);
            hold on;
            plot(testCase.f_inh_data.Time, testCase.f_inh_data.Data, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
            grid on;
            ylabel('Buoyancy Force (N)');
            xlabel('Time (s)');
            legend('Nominal (1.5L)', 'Inhalation (3.0L)');
        end
    end

    methods(Test)
        function testNominalLungsState(testCase)
            % Verify the initial physical state under nominal lung volume of 1.5L
            testCase.runSimulation(); % Uses default 1.5e-3 (1.5L)
            
            % Assertions
            n_lungs_ts = testCase.run_simulation_and_get_moles(1.5e-3);
            testCase.verifyEqual(n_lungs_ts.Data(1), 0.104, AbsTol=1e-3);
            testCase.verifyEqual(testCase.V_nom_data.Data(1), 1.5e-3, AbsTol=1e-4);
            testCase.verifyEqual(testCase.f_nom_data.Data(1), -15.08, AbsTol=1e-1);
        end

        function testInhalationPressureAndBuoyancyDynamics(testCase)
            % Verify expansion pressure drop and higher buoyancy lifting force during inhalation (3.0L)
            testCase.runSimulation();       % Establish nominal baseline via default value
            testCase.runSimulation(3.0e-3); % Simulate expanded inhalation

            % Assertions
            testCase.verifyEqual(testCase.V_inh_data.Data(1), 3.0e-3, AbsTol=1e-4);
            testCase.verifyLessThan(testCase.p_inh_data.Data(1), testCase.p_nom_data.Data(1));
            testCase.verifyEqual(testCase.f_inh_data.Data(1), -30.16, AbsTol=1e-1);
        end
    end

    methods(Access = private)
        function n_lungs_ts = run_simulation_and_get_moles(testCase, volumeValue)
            % Tiny helper to extract private moles during test
            load_system(testCase.ModelName);
            in = Simulink.SimulationInput(testCase.ModelName);
            in = in.setModelParameter('StopTime', '10');
            in = in.setBlockParameter([testCase.ModelName '/ConstantVol'], 'Value', num2str(volumeValue));
            out = sim(in);
            n_lungs_ts = out.logsout.get('n_lungs').Values;
        end
    end
end
