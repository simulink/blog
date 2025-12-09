## Usage of the sim command to Simulate Simulink models
### General syntax
- Simulink models should always be simulated using the sim command
- The sim command should be used with the syntax "out = sim(in)", where "in" is a Simulink.SimulationInput object and out is a Simulink.SimulationOutput object.
- Use the variable name "in" for the Simulink.SimulationInput object.
- Use the variable name "out" for the Simulink.SimulationOutput object.
- Avoid using set_param for simulation. All parameters should be set through Simulink.SimulationInput methods.
- Avoid using load_system or open_system for simulation. Models will be loaded automatically by the sim command.
- Model parameters should be specified using the Simulink.SimulationInput method setModelParameter.
- Block parameters should be specified using the Simulink.SimulationInput method setBlockParameter.
- New values for MATLAB variables used by the Simulink models should be specified using the Simulink.SimulationInput method setVariable.

### Input signals
- Input signals should be passed to the model using Inport blocks.
- The values for the individual input signals should be stored in MATLAB timeseries. 
- The timeseries should be combined into a Simulink.SimulationData.Dataset. For example: "ds=Simulink.SimulationData.Dataset;ds{1} = myTimeseries;"
-  The Simulink.SimulationData.Dataset should be specified using the Simulink.SimulationInput method setExternalInput. For example: "in = in.setExternalInput(ds);"

### Data logging
- Data is logged in dataset format.
- Logged data can be accessed through the logsout field of the Simulink.SimulationOutput object, for example "out.logsout".
- Logged signals can be accessed by name using the get method, for example: "out.logsout.get('signalName')"
- Logged signals should be plotted using the timeseries plot command, for example: "plot(out.logsout.get('signalName').Values)"
- Avoid creating unnecessary variables when accessing logged data. Access logged data directly from the Simulink.SimulationOutput object. For example, use "out.logsout.get('signalName').Values" instead of creating a separate variable for the logged signal.
- Avoid unnecessary validation of the Simulink.SimulationOutput object. Assume the sim command returns a valid object. No try-catch or validation code is needed.
- A Simulink.SimulationOutput does not have a isfield method. Do not use isfield to check for logged data.