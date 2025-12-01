classdef slModifier < handle

    properties
        modelName
        request
        findOptions = Simulink.FindOptions;
        blks
        param
        value
    end

    methods
        function obj = slModifier()
            obj.modelName = "qwen3:latest";
        end

        function run(obj)
            obj.findBlks();
            obj.findParam();
            obj.findParamValue();
            obj.doTheModif();
        end

        function obj = findBlks(obj)

            disp("1 - Analyzing request for blocks to modify");

            % Step 1 is to find the list of blocks the user wants to modify
            tool1 = openAIFunction("slModifier.findSelectedBlocks",...
                "Returns the list of currently selected blocks in a Simulink model");
            tool2 = openAIFunction("slModifier.findBlocksOfType",...
                "Returns the list of blocks of a specific blockType in a Simulink model");
            tool2 = addParameter(tool2,"blockType",type="string");

            systemPrompt = "You are an automated tool designed to modify Simulink models, " +...
                "a block diagram programming language. " + ...
                "The user will make a request, you need to find which " + ...
                "modelling elements the user is trying to modify";

            agent = ollamaChat(obj.modelName,systemPrompt,tools=[tool1,tool2]);
            [response, message] = generate(agent, "The sentence: " + obj.request);
            obj.blks = slModifier.callTool(response, message);
            blkStrings = string(getfullname(obj.blks));

            % Display blocks found
            disp("Found blocks to modify:")
            for i = 1:length(obj.blks)
                disp("- <a href=""matlab:hilite_system('" + blkStrings{i} + "')"">" + blkStrings(i) + "</a>");
            end
            % disp(newline);
        end

        function obj = findParam(obj)
            % 2 - find which parameter the user is talking about. Get all
            % the parameters for this block and ask the tool to find which one is the
            % best match for what they described. 

            disp("2 - Analyzing which parameter to set");
            % all the parameters for the block, make that a coma separated list
            d = get_param(obj.blks(1),'ObjectParameters');
            f = fieldnames(d);
            commaSeparatedString = string(strjoin(f, ', '));

            systemPrompt = "You will receive a sentence and comma-separated list of parameters for a Simulink block. " + ...
                "Find the parameter that corresponds the most likely to the sentence. " + ...
                "Returns only the parameter name.";
            agent = ollamaChat(obj.modelName,systemPrompt);
            [obj.param, message] = generate(agent, "The sentence: " + obj.request + "The listof parameters: " + commaSeparatedString); %#ok<ASGLU>
             disp("Found parameter to set: ''" + string(obj.param) + "''");
             % disp(newline);
        end

        function obj = findParamValue(obj)
            % 3 - we need to figure out the value the user wants to set.
            disp("3 - Analyzing which value to set");
            systemPrompt = "You are an automated tool designed to modify Simulink models. " + ...
                "The user will make a request, your task is to identify the value " + ...
                "of the parameter that needs to be applied. " + ...
                "Return only a single word. " + ...
                "Example: Set the color of this block to red, the answer should be red. " + ...
                "Example: Set the value of a Gain block to 3, the answer is 3.";
            agent = ollamaChat(obj.modelName,systemPrompt);
            [obj.value, message] = generate(agent, "The sentence: " + obj.request); %#ok<ASGLU>
            disp("Setting ''" + obj.param + "'' to ''" + obj.value + "''");
        end
        
        function doTheModif(obj)
            for i = 1:length(obj.blks)
                set_param(obj.blks(i),obj.param,obj.value);
            end
            disp("Done");
        end


    end

    % Tools passed ot the LLM
    methods (Static=true)

        function out = callTool(response,message)
            % Common entry point to call all tool functions
            if response == ""
                if not(isempty(message.tool_calls))
                    h = str2func(message.tool_calls.function.name);
                    data = message.tool_calls.function.arguments;
                    out = h(data);
                else
                    out = 'No tool calls available.';
                end
            end
        end

        function blks = findSelectedBlocks(data) %#ok<INUSD>
            % Function to be called by the LLM if we determine that it
            % needs the lis tof all selected blocks
            opts = Simulink.FindOptions;
            opts.SearchDepth = 1;
            blks = Simulink.findBlocks(gcs,'Selected','on',opts);
        end

        function blks = findBlocksOfType(data)
            % Function to be called by the LLM if it determines that it
            % needs blocks of a certain type
            type = string(data.blockType); 

            % I did find_system on simulink.slx and stored the types of all blocks
            d = load('allBlockTypes.mat');

            if any(strcmp(d.bTypes,type))
                % Type already exists
                blockType = type;
            else
                disp("Determining block type based on: ''" + type + "''");

                systemPrompt = "You will receive a sentence and comma-separated list " + ...
                    "of parameters for a Simulink block. " +...
                    "Find the parameter that corresponds the most likely to the sentence. " +... 
                    "Returns only the parameter name.";
                modelName = "qwen3:latest";
                mdl = ollamaChat(modelName, systemPrompt);
                [response, message] = generate(mdl, "The sentence: " + type + "The list of parameters: " + d.blkTypesStr); %#ok<ASGLU>
                blockType = response;
            end

            opts = Simulink.FindOptions;% Could be modified to include referenced models
            blks = Simulink.findBlocksOfType(bdroot,blockType,opts);

        end
    end
end