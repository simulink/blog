function buildFunctional()
% BUILDFUNCTIONAL Create the GalacticSoup functional architecture.
%   Builds the functional interface dictionary and the functional System
%   Composer model. Idempotent: deletes the .sldd and .slx before rebuilding.
%
%   Material/data flow (production chain) and orchestration hub connections
%   are drawn at the functional abstraction level -- no units or
%   implementation detail in any interface element.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    archDir  = fullfile(rootDir, 'architecture');

    modelName = "GalacticSoupFunctional";
    dictName  = "GalacticSoupFunctionalInterfaces.sldd";
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
        "RecipeSpec",        {"RecipeId","uint32";  "CookTemperature","double"; "CookDuration","double"};
        "IngredientRequest", {"BatchId","uint32";   "TotalMass","double"};
        "IngredientDelivery",{"BatchId","uint32";   "TotalMass","double"};
        "CookedBatch",       {"BatchId","uint32";   "RecipeId","uint32"; "Volume","double"; "Temperature","double"};
        "QCOutcome",         {"BatchId","uint32";   "Accepted","boolean"; "Reason","uint32"};
        "PackagedBatch",     {"BatchId","uint32";   "ContainerCount","uint32"; "DestinationId","uint32"};
        "Manifest",          {"BatchId","uint32";   "DestinationId","uint32"; "ContainerCount","uint32"; "DispatchTime","double"};
        "ProductionCommand", {"Command","uint32";   "TargetRate","double"};
        "ProductionStatus",  {"SubsystemId","uint32";"State","uint32"; "Rate","double"; "FaultFlags","uint32"};
        "RocketSchedule",    {"RocketId","uint32";  "SlotIndex","uint32"; "ArrivalTime","double"; "LoadingWindow","double"};
    };
    for i = 1:size(ifaceSpecs,1)
        iface = addInterface(dict, ifaceSpecs{i,1});
        elems = ifaceSpecs{i,2};
        for k = 1:size(elems,1)
            addElement(iface, elems{k,1}, Type=char(elems{k,2}));
        end
    end
    dict.save();

    % Re-fetch (required before use in setInterface -- handles go stale across save)
    ifaces = containers.Map('KeyType','char','ValueType','any');
    for i = 1:size(ifaceSpecs,1)
        ifaces(char(ifaceSpecs{i,1})) = dict.getInterface(ifaceSpecs{i,1});
    end

    % ── 2. Model + function components ──────────────────────────────────────
    model = systemcomposer.createModel(char(modelName));
    arch  = model.Architecture;
    linkDictionary(model, strrep(char(dictFile), '\', '/'));

    funcNames = { ...
        'ManageRecipes', 'StoreIngredients', 'TransferIngredients', ...
        'PrepareIngredients', ...
        'CookSoup', 'InspectQuality', 'PackageSoup', ...
        'GenerateManifest', 'LoadTransport', 'HandleRocket', ...
        'RefuelRocket', 'ReceiveIngredients', 'CoordinateProduction'};
    funcs = containers.Map();
    for i = 1:numel(funcNames)
        funcs(funcNames{i}) = addComponent(arch, funcNames{i});
    end

    % ── 3. Production-chain ports + connections ─────────────────────────────
    % Each row: {SrcFunc, SrcPort, DstFunc, DstPort, InterfaceName}
    chain = {
        'ManageRecipes',       'RecipeSpec',            'CookSoup',            'RecipeSpec',        'RecipeSpec';
        'TransferIngredients', 'IngredientRequest',     'StoreIngredients',    'IngredientRequest', 'IngredientRequest';
        'StoreIngredients',    'IngredientDeliveryOut', 'TransferIngredients', 'IngredientDelivery','IngredientDelivery';
        'TransferIngredients', 'IngredientDeliveryOut', 'PrepareIngredients',  'IngredientDeliveryIn', 'IngredientDelivery';
        'PrepareIngredients',  'IngredientDeliveryOut', 'CookSoup',            'IngredientDelivery',   'IngredientDelivery';
        'CookSoup',            'CookedBatch',           'InspectQuality',      'CookedBatch',       'CookedBatch';
        'InspectQuality',      'QCOutcome',             'PackageSoup',         'QCOutcome',         'QCOutcome';
        'PackageSoup',         'PackagedBatch',         'LoadTransport',       'PackagedBatchIn',   'PackagedBatch';
        'PackageSoup',         'PackagedBatch',         'GenerateManifest',    'PackagedBatch',     'PackagedBatch';
        'GenerateManifest',    'Manifest',              'LoadTransport',       'Manifest',          'Manifest';
        'LoadTransport',       'PackagedBatchOut',      'HandleRocket',        'PackagedBatch',     'PackagedBatch';
        'HandleRocket',        'IngredientDelivery',    'ReceiveIngredients',  'IngredientDeliveryIn','IngredientDelivery';
        'ReceiveIngredients',  'IngredientDeliveryOut', 'StoreIngredients',    'IngredientDeliveryIn','IngredientDelivery';
    };

    % Add ports (reuse a port name if it already exists on the component -- this
    % happens when a port fans out to multiple destinations, e.g. PackageSoup's
    % PackagedBatch feeds both LoadTransport and GenerateManifest).
    for i = 1:size(chain,1)
        srcName = chain{i,1}; srcPort = chain{i,2};
        dstName = chain{i,3}; dstPort = chain{i,4};
        iface   = ifaces(chain{i,5});
        ensurePort(funcs(srcName), srcPort, 'out', iface);
        ensurePort(funcs(dstName), dstPort, 'in',  iface);
    end

    % Connect after all ports exist
    for i = 1:size(chain,1)
        sp = funcs(chain{i,1}).getPort(chain{i,2});
        dp = funcs(chain{i,3}).getPort(chain{i,4});
        connect(sp, dp);
    end

    % ── 4. Orchestration: Command fan-out, Status fan-in, RocketSchedule ────
    % 9 ops functions under orchestration (per approved spec).
    opsFuncs = {'StoreIngredients','TransferIngredients','PrepareIngredients','CookSoup', ...
                'InspectQuality','PackageSoup','LoadTransport', ...
                'HandleRocket','RefuelRocket','ReceiveIngredients'};

    coord = funcs('CoordinateProduction');
    ensurePort(coord, 'Command',        'out', ifaces('ProductionCommand'));
    ensurePort(coord, 'RocketSchedule', 'out', ifaces('RocketSchedule'));

    cmdOut = coord.getPort('Command');
    for i = 1:numel(opsFuncs)
        op = funcs(opsFuncs{i});
        ensurePort(op, 'Command', 'in', ifaces('ProductionCommand'));
        connect(cmdOut, op.getPort('Command'));

        % Status fan-in: separate input port per source on CoordinateProduction
        statusPortName = ['Status_', opsFuncs{i}];
        ensurePort(op,    'Status',         'out', ifaces('ProductionStatus'));
        ensurePort(coord, statusPortName,   'in',  ifaces('ProductionStatus'));
        connect(op.getPort('Status'), coord.getPort(statusPortName));
    end

    % RocketSchedule to HandleRocket
    ensurePort(funcs('HandleRocket'), 'RocketSchedule', 'in', ifaces('RocketSchedule'));
    connect(coord.getPort('RocketSchedule'), funcs('HandleRocket').getPort('RocketSchedule'));

    % ── 5. Layout + save ────────────────────────────────────────────────────
    Simulink.BlockDiagram.arrangeSystem(char(modelName));
    save_system(char(modelName), char(slxFile));

    registerWithProject({char(dictFile), char(slxFile)});

    nChain = size(chain,1);
    nCmd   = numel(opsFuncs);
    nStat  = numel(opsFuncs);
    fprintf('\n=== Functional architecture ===\n');
    fprintf('  Interfaces:      %d\n', size(ifaceSpecs,1));
    fprintf('  Functions:       %d\n', numel(funcNames));
    fprintf('  Chain conns:     %d\n', nChain);
    fprintf('  Command conns:   %d\n', nCmd);
    fprintf('  Status conns:    %d\n', nStat);
    fprintf('  RocketSchedule:  1\n');
    fprintf('  Total conns:     %d\n', nChain + nCmd + nStat + 1);

    open_system(char(modelName));
end

% ── Helpers ───────────────────────────────────────────────────────────────────

function ensurePort(comp, name, direction, iface)
% Add a typed port by name/direction if it does not already exist on the
% component. Reusing an existing outbound port is how 1->N fan-out is modelled
% in SC (single output port can connect to many inputs).
    existing = comp.getPort(name);
    if ~isempty(existing)
        return;
    end
    port = addPort(comp.Architecture, name, direction);
    port.setInterface(iface);
end
