function buildFunctionalToLogical()
% BUILDFUNCTIONALTOLOGICAL Create the F -> L allocation set.
%   Maps each functional component to the logical element(s) that realize
%   it. Idempotent: closes any existing allocation set and deletes the
%   .mldatx file before recreating.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    archDir  = fullfile(rootDir, 'architecture');

    allocBase = 'GalacticSoupFunctionalToLogical';
    allocFile = fullfile(archDir, [allocBase, '.mldatx']);

    systemcomposer.allocation.AllocationSet.closeAll();
    if isfile(allocFile), delete(allocFile); end

    addpath(archDir);
    funcModel = systemcomposer.openModel('GalacticSoupFunctional');
    logModel  = systemcomposer.openModel('GalacticSoupLogical');
    funcArch  = funcModel.Architecture;
    logArch   = logModel.Architecture;

    % Allocation set name must differ from file basename -- save() derives a
    % name from the file path and rejects a duplicate. Append 'Set' to avoid
    % the "name must be unique" save error.
    allocSetName = [allocBase, 'Set'];
    allocSet = systemcomposer.allocation.createAllocationSet( ...
        allocSetName, 'GalacticSoupFunctional', 'GalacticSoupLogical');

    scenario      = allocSet.Scenarios(1);
    scenario.Name = 'FunctionalToLogical';

    % { FunctionName, LogicalElementName }
    pairs = {
        'ManageRecipes',        'RecipeController';
        'StoreIngredients',     'IngredientStore';
        'TransferIngredients',  'MaterialHandler';
        'PrepareIngredients',   'PrepStation';
        'CookSoup',             'CookingUnit';
        'InspectQuality',       'QualityStation';
        'PackageSoup',          'PackagingStation';
        'GenerateManifest',     'PackagingStation';
        'LoadTransport',        'MaterialHandler';
        'HandleRocket',         'RocketPad';
        'RefuelRocket',         'RocketPad';
        'ReceiveIngredients',   'MaterialHandler';
        'CoordinateProduction', 'ProductionController';
    };

    for i = 1:size(pairs, 1)
        f = funcArch.getComponent(pairs{i,1});
        l = logArch.getComponent(pairs{i,2});
        if isempty(f)
            warning('Function %s not found, skipping', pairs{i,1}); continue;
        end
        if isempty(l)
            warning('Logical element %s not found, skipping', pairs{i,2}); continue;
        end
        allocate(scenario, f, l);
    end

    save(allocSet, allocFile);
    registerWithProject({allocFile});

    fprintf('\n=== F -> L allocation set ===\n');
    fprintf('  Scenario:    %s\n', scenario.Name);
    fprintf('  Pairs:       %d\n', size(pairs,1));
    fprintf('  File:        %s\n', strrep(allocFile, rootDir, '.'));
end
