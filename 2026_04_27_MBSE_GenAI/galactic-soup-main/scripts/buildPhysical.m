function buildPhysical()
% BUILDPHYSICAL Create the GalacticSoup physical architecture + stereotype.
%   Builds the physical interface dictionary, the SC model, and the
%   ComponentCharacteristics stereotype. Idempotent: deletes all artifacts
%   (dict, slx, slmx, profile xml) before rebuilding. Applies stereotype to
%   leaves AND the CookingLine composite so the Analysis Viewer displays
%   hierarchical rollups (see decisions.md Phase 4).

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    archDir  = fullfile(rootDir, 'architecture');

    modelName   = "GalacticSoupPhysical";
    dictName    = "GalacticSoupPhysicalInterfaces.sldd";
    profileName = "GalacticSoupProfile";
    dictFile    = fullfile(archDir, dictName);
    slxFile     = fullfile(archDir, char(modelName) + ".slx");
    slmxFile    = fullfile(archDir, char(modelName) + "~mdl.slmx");
    profileFile = fullfile(archDir, char(profileName) + ".xml");

    if bdIsLoaded(char(modelName)), close_system(char(modelName), 0); end
    Simulink.data.dictionary.closeAll("-discard");
    systemcomposer.profile.Profile.closeAll();
    if isfile(dictFile),    delete(dictFile);    end
    if isfile(slxFile),     delete(slxFile);     end
    if isfile(slmxFile),    delete(slmxFile);    end
    if isfile(profileFile), delete(profileFile); end

    addpath(archDir);

    % ── 1. Interface dictionary (physical, with units) ──────────────────────
    dict = systemcomposer.createDictionary(char(dictFile));
    ifaceSpecs = {
        "ColdIngredientFlow",    {"BatchId","uint32"; "Mass_kg","double"; "Temperature_C","double"; "ContainerType","uint32"; "Prepared","boolean"};
        "AmbientIngredientFlow", {"BatchId","uint32"; "Mass_kg","double"; "ContainerType","uint32"; "Prepared","boolean"};
        "CookedSoupFlow",        {"BatchId","uint32"; "Volume_L","double"; "Temperature_C","double"};
        "PackagedSoupFlow",      {"BatchId","uint32"; "ContainerCount","uint32"; "SealPressure_kPa","double"};
        "ControlBus",            {"Command","uint32"; "TargetRate_bph","double"; "State","uint32"; "FaultFlags","uint32"};
        "RocketPadStatus",       {"PadIndex","uint32"; "RocketPresent","boolean"; "Countdown_s","double"; "FuelLevel_pct","double"};
        "ManifestData",          {"BatchId","uint32"; "DestinationId","uint32"; "ContainerCount","uint32"; "DispatchTime_s","double"};
        "RecipeData",            {"RecipeId","uint32"; "StepCount","uint32"; "NominalDuration_s","double"; "NominalTemperature_C","double"};
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

    % ── 2. Model + top-level components ─────────────────────────────────────
    model = systemcomposer.createModel(char(modelName));
    arch  = model.Architecture;
    linkDictionary(model, strrep(char(dictFile), '\', '/'));

    topNames = {'ColdStorage','AmbientStorage','ConveyanceSystem', ...
                'PrepStation', ...
                'CookingLine','InspectionStation','PackagingLine', ...
                'RocketPadComplex','ControlComputer'};
    top = containers.Map();
    for i = 1:numel(topNames)
        top(topNames{i}) = addComponent(arch, topNames{i});
    end

    % ── 3. CookingLine composite: sub-components + internal wiring ──────────
    cook = top('CookingLine');
    cookRecipeIn = addPort(cook.Architecture, 'RecipeData', 'in');
    cookRecipeIn.setInterface(ifaces('RecipeData'));

    vessel   = addComponent(cook.Architecture, 'CookingVessel');
    stirrer  = addComponent(cook.Architecture, 'StirringMechanism');
    spice    = addComponent(cook.Architecture, 'SpiceDispenser');

    sRecipe = addPort(stirrer.Architecture, 'RecipeData', 'in');
    sRecipe.setInterface(ifaces('RecipeData'));
    pRecipe = addPort(spice.Architecture,   'RecipeData', 'in');
    pRecipe.setInterface(ifaces('RecipeData'));

    connect(cookRecipeIn, stirrer.getPort('RecipeData'));
    connect(cookRecipeIn, spice.getPort('RecipeData'));

    % ── 3b. PrepStation composite: Chopper + Scale (sequential, both flows) ─
    % Two parallel internal paths (cold + ambient), each sequential through
    % Chopper then Scale. Boundary ingredient interfaces carry Prepared=false
    % on input, Prepared=true on output (semantic convention).
    prep = top('PrepStation');
    pColdIn  = addTypedPort(prep, 'ColdIngredientIn',     'in',  ifaces('ColdIngredientFlow'));
    pColdOut = addTypedPort(prep, 'ColdIngredientOut',    'out', ifaces('ColdIngredientFlow'));
    pAmbIn   = addTypedPort(prep, 'AmbientIngredientIn',  'in',  ifaces('AmbientIngredientFlow'));
    pAmbOut  = addTypedPort(prep, 'AmbientIngredientOut', 'out', ifaces('AmbientIngredientFlow'));

    chopper = addComponent(prep.Architecture, 'Chopper');
    scale   = addComponent(prep.Architecture, 'Scale');

    % Sub-component ports: each sub has 4 ingredient ports (cold + ambient, in + out).
    for sub = [chopper, scale]
        addTypedPort(sub, 'ColdIngredientIn',     'in',  ifaces('ColdIngredientFlow'));
        addTypedPort(sub, 'ColdIngredientOut',    'out', ifaces('ColdIngredientFlow'));
        addTypedPort(sub, 'AmbientIngredientIn',  'in',  ifaces('AmbientIngredientFlow'));
        addTypedPort(sub, 'AmbientIngredientOut', 'out', ifaces('AmbientIngredientFlow'));
    end

    % Cold path: boundary -> Chopper -> Scale -> boundary
    connect(pColdIn, chopper.getPort('ColdIngredientIn'));
    connect(chopper.getPort('ColdIngredientOut'), scale.getPort('ColdIngredientIn'));
    connect(scale.getPort('ColdIngredientOut'), pColdOut);

    % Ambient path: same pattern
    connect(pAmbIn, chopper.getPort('AmbientIngredientIn'));
    connect(chopper.getPort('AmbientIngredientOut'), scale.getPort('AmbientIngredientIn'));
    connect(scale.getPort('AmbientIngredientOut'), pAmbOut);

    % ── 4. Chain ports + connections ────────────────────────────────────────
    chain = {
        'ControlComputer',  'RecipeData',            'CookingLine',      'RecipeData',              'RecipeData';
        'ColdStorage',      'ColdIngredientOut',     'ConveyanceSystem', 'ColdFromStore',           'ColdIngredientFlow';
        'AmbientStorage',   'AmbientIngredientOut',  'ConveyanceSystem', 'AmbientFromStore',        'AmbientIngredientFlow';
        'ConveyanceSystem', 'ColdToStore',           'ColdStorage',      'ColdIngredientIn',        'ColdIngredientFlow';
        'ConveyanceSystem', 'AmbientToStore',        'AmbientStorage',   'AmbientIngredientIn',     'AmbientIngredientFlow';
        'ConveyanceSystem', 'ColdToCook',            'PrepStation',      'ColdIngredientIn',        'ColdIngredientFlow';
        'ConveyanceSystem', 'AmbientToCook',         'PrepStation',      'AmbientIngredientIn',     'AmbientIngredientFlow';
        'PrepStation',      'ColdIngredientOut',     'CookingLine',      'ColdIngredientIn',        'ColdIngredientFlow';
        'PrepStation',      'AmbientIngredientOut',  'CookingLine',      'AmbientIngredientIn',     'AmbientIngredientFlow';
        'CookingLine',      'CookedSoupOut',         'InspectionStation','CookedSoupIn',            'CookedSoupFlow';
        'InspectionStation','CookedSoupOut',        'PackagingLine',     'CookedSoupIn',            'CookedSoupFlow';
        'PackagingLine',    'PackagedSoupOut',       'ConveyanceSystem', 'PackagedIn',              'PackagedSoupFlow';
        'PackagingLine',    'ManifestOut',           'ControlComputer',  'ManifestIn',              'ManifestData';
        'RocketPadComplex', 'PadStatus',             'ConveyanceSystem', 'RocketPadStatus',         'RocketPadStatus';
    };

    for i = 1:size(chain,1)
        ifaceObj = ifaces(chain{i,5});
        ensurePort(top(chain{i,1}), chain{i,2}, 'out', ifaceObj);
        ensurePort(top(chain{i,3}), chain{i,4}, 'in',  ifaceObj);
    end
    for i = 1:size(chain,1)
        sp = top(chain{i,1}).getPort(chain{i,2});
        dp = top(chain{i,3}).getPort(chain{i,4});
        connect(sp, dp);
    end

    % ── 5. Orchestration: ControlComputer command fan-out + status fan-in ───
    opsNames = {'ColdStorage','AmbientStorage','ConveyanceSystem', ...
                'PrepStation', ...
                'CookingLine','InspectionStation','PackagingLine','RocketPadComplex'};

    cc = top('ControlComputer');
    ensurePort(cc, 'Command', 'out', ifaces('ControlBus'));
    cmdOut = cc.getPort('Command');

    for i = 1:numel(opsNames)
        op = top(opsNames{i});
        ensurePort(op, 'Command', 'in',  ifaces('ControlBus'));
        ensurePort(op, 'Status',  'out', ifaces('ControlBus'));
        connect(cmdOut, op.getPort('Command'));

        statusName = ['Status_', opsNames{i}];
        ensurePort(cc, statusName, 'in', ifaces('ControlBus'));
        connect(op.getPort('Status'), cc.getPort(statusName));
    end

    % ── 6. Layout ───────────────────────────────────────────────────────────
    Simulink.BlockDiagram.arrangeSystem(char(modelName));
    arrangeComposites(arch, char(modelName));

    % ── 7. Stereotype profile ───────────────────────────────────────────────
    profile = systemcomposer.profile.Profile.createProfile(char(profileName));
    st = addStereotype(profile, "ComponentCharacteristics", AppliesTo="Component");
    addProperty(st, "Mass_kg",               Type="double", Units="kg",       DefaultValue="0");
    addProperty(st, "Power_W",               Type="double", Units="W",        DefaultValue="0");
    addProperty(st, "Cost_credits",          Type="double", Units="credits",  DefaultValue="0");
    addProperty(st, "Throughput_soupsPerHr", Type="double", Units="soups/hr", DefaultValue="0");
    addProperty(st, "Reliability_MTBF_hr",   Type="double", Units="hr",       DefaultValue="0");
    addProperty(st, "Supplier",              Type="string",                   DefaultValue='""');
    addProperty(st, "SafetyLevel",           Type="string",                   DefaultValue='"FoodSafe"');

    % profile.save(folder) — NEVER pass a path ending in .xml
    profile.save(char(archDir));

    applyProfile(model, char(profileName));

    % ── 8. Apply stereotype + set initial values ────────────────────────────
    % {ComponentName, Mass_kg, Power_W, Cost_credits, Throughput_sph, MTBF_hr, Supplier, SafetyLevel}
    % CookingLine is a composite: all numerics 0 (analysis computes rollup),
    % strings default.
    estimates = {
        'ColdStorage',       2500, 80000, 180000,   0, 40000, 'CryoTech',   'FoodSafe';
        'AmbientStorage',    1200,  2000,  60000,   0, 50000, 'ShelfWorks', 'FoodSafe';
        'ConveyanceSystem',  1800, 15000, 220000, 800, 25000, 'ConveyCo',   'FoodSafe';
        'PrepStation',          0,     0,      0,   0,     0, '',           'FoodSafe';
        'CookingLine',          0,     0,      0,   0,     0, '',           'FoodSafe';
        'InspectionStation',  300,  1500, 150000,   0, 35000, 'QualiSense', 'Critical';
        'PackagingLine',     2000, 25000, 280000, 400, 22000, 'PackTronix', 'FoodSafe';
        'RocketPadComplex',  3500,120000, 900000,   0, 15000, 'PadCorp',    'Critical';
        'ControlComputer',     50,   800,  40000,   0, 80000, 'ComputeInc', 'Critical';
        'CookingVessel',      800,     0,  30000,  50, 60000, 'VesselForge','FoodSafe';
        'StirringMechanism',  150,  8000,  22000,   0, 20000, 'StirBot',    'FoodSafe';
        'SpiceDispenser',      80,   500,  12000,   0, 30000, 'SpiceWorks', 'FoodSafe';
        'Chopper',            180,  3000,  45000, 250, 20000, 'ChopWorks',  'FoodSafe';
        'Scale',               40,   100,   8000, 500, 80000, 'WeighCo',    'FoodSafe';
    };

    stPath = char(profileName) + "." + "ComponentCharacteristics";
    for i = 1:size(estimates,1)
        name = estimates{i,1};
        comp = findComponentByName(arch, name);
        if isempty(comp)
            warning('Component %s not found; skipping stereotype apply', name);
            continue;
        end
        applyStereotype(comp, stPath);
        setProperty(comp, stPath + ".Mass_kg",               num2str(estimates{i,2}));
        setProperty(comp, stPath + ".Power_W",               num2str(estimates{i,3}));
        setProperty(comp, stPath + ".Cost_credits",          num2str(estimates{i,4}));
        setProperty(comp, stPath + ".Throughput_soupsPerHr", num2str(estimates{i,5}));
        setProperty(comp, stPath + ".Reliability_MTBF_hr",   num2str(estimates{i,6}));
        setProperty(comp, stPath + ".Supplier",              ['"', estimates{i,7}, '"']);
        setProperty(comp, stPath + ".SafetyLevel",           ['"', estimates{i,8}, '"']);
    end

    % save_system(..., fullPath) is the only save needed. A bare save(model)
    % here would write a second .slx to pwd (typically project root), which
    % shadows the architecture/ copy on the MATLAB path.
    save_system(char(modelName), char(slxFile));

    registerWithProject({char(dictFile), char(slxFile), char(profileFile)});

    fprintf('\n=== Physical architecture ===\n');
    fprintf('  Interfaces:         %d\n', size(ifaceSpecs,1));
    fprintf('  Top-level:          %d\n', numel(topNames));
    fprintf('  Sub-components:     5 (CookingLine: 3, PrepStation: 2)\n');
    fprintf('  Chain conns:        %d\n', size(chain,1));
    fprintf('  Command conns:      %d\n', numel(opsNames));
    fprintf('  Status conns:       %d\n', numel(opsNames));
    fprintf('  Internal conns:     %d (CookingLine 2 + PrepStation 6)\n', 8);
    fprintf('  Total conns:        %d\n', size(chain,1) + 2*numel(opsNames) + 8);
    fprintf('  Stereotype applied: %d components (leaves + 2 composites)\n', size(estimates,1));

    open_system(char(modelName));
end

% ── Helpers ───────────────────────────────────────────────────────────────────

function ensurePort(comp, name, direction, iface)
    existing = comp.getPort(name);
    if ~isempty(existing), return; end
    port = addPort(comp.Architecture, name, direction);
    port.setInterface(iface);
end

function port = addTypedPort(comp, name, direction, iface)
% Non-idempotent; returns the ArchitecturePort so internal boundary-to-sub
% wiring can use it. Use within a one-shot composite-build block.
    port = addPort(comp.Architecture, name, direction);
    port.setInterface(iface);
end

function arrangeComposites(arch, pathPrefix)
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

function comp = findComponentByName(arch, name)
% Depth-first search so a composite's sub-components can be found by name.
    comp = [];
    queue = reshape(arch.Components, [], 1);
    while ~isempty(queue)
        c = queue(1); queue(1) = [];
        if strcmp(c.Name, name), comp = c; return; end
        subA = c.Architecture;
        if ~isempty(subA) && ~isempty(subA.Components)
            queue = [queue; reshape(subA.Components, [], 1)]; %#ok<AGROW>
        end
    end
end
