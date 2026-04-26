function buildLogicalToPhysical()
% BUILDLOGICALTOPHYSICAL Create the L -> P allocation set.
%   Maps each logical element to the physical component(s) that implement it,
%   including sub-components inside composites (Stirrer -> StirringMechanism,
%   Seasoner -> SpiceDispenser). Idempotent.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    archDir  = fullfile(rootDir, 'architecture');

    allocBase = 'GalacticSoupLogicalToPhysical';
    allocFile = fullfile(archDir, [allocBase, '.mldatx']);

    systemcomposer.allocation.AllocationSet.closeAll();
    if isfile(allocFile), delete(allocFile); end

    addpath(archDir);
    logModel  = systemcomposer.openModel('GalacticSoupLogical');
    physModel = systemcomposer.openModel('GalacticSoupPhysical');

    allocSetName = [allocBase, 'Set'];
    allocSet = systemcomposer.allocation.createAllocationSet( ...
        allocSetName, 'GalacticSoupLogical', 'GalacticSoupPhysical');

    scenario      = allocSet.Scenarios(1);
    scenario.Name = 'LogicalToPhysical';

    % {LogicalPath, PhysicalPath} -- path is '/' separated for sub-components,
    % top-level names use no separator.
    pairs = {
        'RecipeController',          'ControlComputer';
        'IngredientStore',           'ColdStorage';
        'IngredientStore',           'AmbientStorage';
        'MaterialHandler',           'ConveyanceSystem';
        'PrepStation',               'PrepStation';
        'PrepStation/Chopper',       'PrepStation/Chopper';
        'PrepStation/Scale',         'PrepStation/Scale';
        'CookingUnit',               'CookingLine';
        'CookingUnit/Stirrer',       'CookingLine/StirringMechanism';
        'CookingUnit/Seasoner',      'CookingLine/SpiceDispenser';
        'QualityStation',            'InspectionStation';
        'PackagingStation',          'PackagingLine';
        'RocketPad',                 'RocketPadComplex';
        'ProductionController',      'ControlComputer';
    };

    for i = 1:size(pairs,1)
        src = resolveByPath(logModel.Architecture,  pairs{i,1});
        dst = resolveByPath(physModel.Architecture, pairs{i,2});
        if isempty(src)
            warning('Logical element %s not found, skipping', pairs{i,1}); continue;
        end
        if isempty(dst)
            warning('Physical component %s not found, skipping', pairs{i,2}); continue;
        end
        allocate(scenario, src, dst);
    end

    save(allocSet, allocFile);
    registerWithProject({allocFile});

    fprintf('\n=== L -> P allocation set ===\n');
    fprintf('  Scenario:    %s\n', scenario.Name);
    fprintf('  Pairs:       %d\n', size(pairs,1));
    fprintf('  File:        %s\n', strrep(allocFile, rootDir, '.'));
end

function c = resolveByPath(arch, pathStr)
% Walk a slash-separated path from the top-level architecture down.
% 'A' returns the top-level component A.
% 'A/B' descends into A's internal architecture and fetches B.
    parts = strsplit(pathStr, '/');
    c = arch.getComponent(parts{1});
    for k = 2:numel(parts)
        if isempty(c), return; end
        c = c.Architecture.getComponent(parts{k});
    end
end
