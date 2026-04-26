function buildLogical()
% BUILDLOGICAL Create the GalacticSoup logical architecture.
%   Builds the logical interface dictionary and the logical SC model.
%   Idempotent: deletes .sldd/.slx/~mdl.slmx before rebuilding.
%
%   CookingUnit is a composite: holds sub-components Stirrer and Seasoner
%   inside it. Boundary-to-sub internal wiring uses the ArchitecturePort
%   returned from addPort(cook.Architecture,...) on one side and the
%   ComponentPort from sub.getPort(...) on the other (see system-composer
%   skill: mixing these wrong throws "incompatible directions").

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    archDir  = fullfile(rootDir, 'architecture');

    modelName = "GalacticSoupLogical";
    dictName  = "GalacticSoupLogicalInterfaces.sldd";
    dictFile  = fullfile(archDir, dictName);
    slxFile   = fullfile(archDir, char(modelName) + ".slx");
    slmxFile  = fullfile(archDir, char(modelName) + "~mdl.slmx");

    if bdIsLoaded(char(modelName)), close_system(char(modelName), 0); end
    Simulink.data.dictionary.closeAll("-discard");
    if isfile(dictFile),  delete(dictFile);  end
    if isfile(slxFile),   delete(slxFile);   end
    if isfile(slmxFile),  delete(slmxFile);  end

    addpath(archDir);

    % ── 1. Interface dictionary ─────────────────────────────────────────────
    dict = systemcomposer.createDictionary(char(dictFile));
    ifaceSpecs = {
        "RecipeProgram",    {"RecipeId","uint32"; "StepCount","uint32"; "NominalDuration","double"; "NominalTemperature","double"};
        "IngredientBatch",  {"BatchId","uint32"; "TotalMass","double"; "ColdChain","boolean"; "Prepared","boolean"};
        "CookedBatch",      {"BatchId","uint32"; "RecipeId","uint32"; "Volume","double"; "CenterTemperature","double"};
        "QCVerdict",        {"BatchId","uint32"; "Accepted","boolean"; "FaultCode","uint32"};
        "PackagedBatch",    {"BatchId","uint32"; "ContainerCount","uint32"; "DestinationId","uint32"; "SealIntegrity","boolean"};
        "ManifestRecord",   {"BatchId","uint32"; "DestinationId","uint32"; "ContainerCount","uint32"; "DispatchTimestamp","double"};
        "RocketPadSignal",  {"PadIndex","uint32"; "RocketPresent","boolean"; "Countdown","double"};
        "ControlSignal",    {"Command","uint32"; "TargetRate","double"; "State","uint32"; "FaultFlags","uint32"};
    };
    for i = 1:size(ifaceSpecs,1)
        iface = addInterface(dict, ifaceSpecs{i,1});
        elems = ifaceSpecs{i,2};
        for k = 1:size(elems,1)
            addElement(iface, elems{k,1}, Type=char(elems{k,2}));
        end
    end
    dict.save();

    ifaces = containers.Map('KeyType','char','ValueType','any');
    for i = 1:size(ifaceSpecs,1)
        ifaces(char(ifaceSpecs{i,1})) = dict.getInterface(ifaceSpecs{i,1});
    end

    % ── 2. Model + top-level logical components ─────────────────────────────
    model = systemcomposer.createModel(char(modelName));
    arch  = model.Architecture;
    linkDictionary(model, strrep(char(dictFile), '\', '/'));

    logNames = {'RecipeController','IngredientStore','MaterialHandler', ...
                'PrepStation', ...
                'CookingUnit','QualityStation','PackagingStation', ...
                'RocketPad','ProductionController'};
    logComps = containers.Map();
    for i = 1:numel(logNames)
        logComps(logNames{i}) = addComponent(arch, logNames{i});
    end

    % ── 3. CookingUnit composite: sub-components + internal wiring ──────────
    % Pre-create the boundary ports we need to wire internally, saving the
    % ArchitecturePort refs. (ensurePort in step 4 is idempotent -- when it
    % encounters these pre-existing ports it will no-op.)
    cook           = logComps('CookingUnit');
    cookRecipeIn   = addPort(cook.Architecture, 'RecipeProgram', 'in');
    cookRecipeIn.setInterface(ifaces('RecipeProgram'));

    stirrer  = addComponent(cook.Architecture, 'Stirrer');
    seasoner = addComponent(cook.Architecture, 'Seasoner');
    stirrerRecipe  = addPort(stirrer.Architecture,  'RecipeProgram', 'in');
    stirrerRecipe.setInterface(ifaces('RecipeProgram'));
    seasonerRecipe = addPort(seasoner.Architecture, 'RecipeProgram', 'in');
    seasonerRecipe.setInterface(ifaces('RecipeProgram'));

    % Internal wiring: boundary (ArchitecturePort) -> sub (ComponentPort via getPort).
    % Fan-out from ONE boundary input port to TWO sub-component inputs.
    connect(cookRecipeIn, stirrer.getPort('RecipeProgram'));
    connect(cookRecipeIn, seasoner.getPort('RecipeProgram'));

    % ── 3b. PrepStation composite: Chopper + Scale (sequential) ─────────────
    % Boundary IngredientBatch arrives with Prepared=false, leaves with
    % Prepared=true (semantic convention; same interface type both ways).
    prep = logComps('PrepStation');
    prepIn  = addPort(prep.Architecture, 'IngredientBatchIn',  'in');
    prepIn.setInterface(ifaces('IngredientBatch'));
    prepOut = addPort(prep.Architecture, 'IngredientBatchOut', 'out');
    prepOut.setInterface(ifaces('IngredientBatch'));

    chopper = addComponent(prep.Architecture, 'Chopper');
    scale   = addComponent(prep.Architecture, 'Scale');
    cIn  = addPort(chopper.Architecture, 'IngredientBatchIn',  'in');
    cIn.setInterface(ifaces('IngredientBatch'));
    cOut = addPort(chopper.Architecture, 'IngredientBatchOut', 'out');
    cOut.setInterface(ifaces('IngredientBatch'));
    sIn  = addPort(scale.Architecture,   'IngredientBatchIn',  'in');
    sIn.setInterface(ifaces('IngredientBatch'));
    sOut = addPort(scale.Architecture,   'IngredientBatchOut', 'out');
    sOut.setInterface(ifaces('IngredientBatch'));

    connect(prepIn, chopper.getPort('IngredientBatchIn'));
    connect(chopper.getPort('IngredientBatchOut'), scale.getPort('IngredientBatchIn'));
    connect(scale.getPort('IngredientBatchOut'), prepOut);

    % ── 4. Chain ports + connections ────────────────────────────────────────
    % {SrcComp, SrcPort, DstComp, DstPort, InterfaceName}
    chain = {
        'RecipeController', 'RecipeProgram',          'CookingUnit',           'RecipeProgram',            'RecipeProgram';
        'IngredientStore',  'IngredientBatchOut',     'MaterialHandler',       'IngredientBatchFromStore', 'IngredientBatch';
        'MaterialHandler',  'IngredientBatchToStore', 'IngredientStore',       'IngredientBatchIn',        'IngredientBatch';
        'MaterialHandler',  'IngredientBatchToCook',  'PrepStation',           'IngredientBatchIn',        'IngredientBatch';
        'PrepStation',      'IngredientBatchOut',     'CookingUnit',           'IngredientBatch',          'IngredientBatch';
        'CookingUnit',      'CookedBatch',            'QualityStation',        'CookedBatch',              'CookedBatch';
        'QualityStation',   'QCVerdict',              'PackagingStation',      'QCVerdict',                'QCVerdict';
        'PackagingStation', 'PackagedBatch',          'MaterialHandler',       'PackagedBatchIn',          'PackagedBatch';
        'PackagingStation', 'ManifestRecord',         'ProductionController',  'ManifestRecord',           'ManifestRecord';
        'RocketPad',        'RocketPadSignal',        'MaterialHandler',       'RocketPadSignal',          'RocketPadSignal';
    };

    for i = 1:size(chain,1)
        ifaceObj = ifaces(chain{i,5});
        ensurePort(logComps(chain{i,1}), chain{i,2}, 'out', ifaceObj);
        ensurePort(logComps(chain{i,3}), chain{i,4}, 'in',  ifaceObj);
    end
    for i = 1:size(chain,1)
        sp = logComps(chain{i,1}).getPort(chain{i,2});
        dp = logComps(chain{i,3}).getPort(chain{i,4});
        connect(sp, dp);
    end

    % ── 5. Orchestration: Command fan-out + Status fan-in ───────────────────
    opsNames = {'RecipeController','IngredientStore','MaterialHandler', ...
                'PrepStation', ...
                'CookingUnit','QualityStation','PackagingStation','RocketPad'};

    pc = logComps('ProductionController');
    ensurePort(pc, 'Command', 'out', ifaces('ControlSignal'));
    cmdOut = pc.getPort('Command');

    for i = 1:numel(opsNames)
        op = logComps(opsNames{i});
        ensurePort(op, 'Command', 'in',  ifaces('ControlSignal'));
        ensurePort(op, 'Status',  'out', ifaces('ControlSignal'));
        connect(cmdOut, op.getPort('Command'));

        statusPortName = ['Status_', opsNames{i}];
        ensurePort(pc, statusPortName, 'in', ifaces('ControlSignal'));
        connect(op.getPort('Status'), pc.getPort(statusPortName));
    end

    % ── 6. Layout + save ────────────────────────────────────────────────────
    % arrangeSystem only touches the named system level. Walk composites and
    % arrange each one explicitly; otherwise sub-blocks land stacked on top of
    % each other inside the composite.
    Simulink.BlockDiagram.arrangeSystem(char(modelName));
    arrangeComposites(arch, char(modelName));
    save_system(char(modelName), char(slxFile));

    registerWithProject({char(dictFile), char(slxFile)});

    fprintf('\n=== Logical architecture ===\n');
    fprintf('  Interfaces:         %d\n', size(ifaceSpecs,1));
    fprintf('  Top-level elements: %d\n', numel(logNames));
    fprintf('  Sub-components:     4 (Stirrer+Seasoner in CookingUnit; Chopper+Scale in PrepStation)\n');
    fprintf('  Chain conns:        %d\n', size(chain,1));
    fprintf('  Command conns:      %d\n', numel(opsNames));
    fprintf('  Status conns:       %d\n', numel(opsNames));
    fprintf('  Internal conns:     %d (CookingUnit 2 + PrepStation 3)\n', 5);
    fprintf('  Total conns:        %d\n', size(chain,1) + 2*numel(opsNames) + 5);

    open_system(char(modelName));
end

% ── Helpers ───────────────────────────────────────────────────────────────────

function ensurePort(comp, name, direction, iface)
    existing = comp.getPort(name);
    if ~isempty(existing), return; end
    port = addPort(comp.Architecture, name, direction);
    port.setInterface(iface);
end

function arrangeComposites(arch, pathPrefix)
% Recursively arrange every composite sub-system. A component is composite
% when its own Architecture has sub-components.
    comps = arch.Components;
    for i = 1:numel(comps)
        sub = comps(i).Architecture;
        if ~isempty(sub) && ~isempty(sub.Components)
            subPath = [pathPrefix, '/', comps(i).Name];
            Simulink.BlockDiagram.arrangeSystem(subPath);
            arrangeComposites(sub, subPath);
        end
    end
end
