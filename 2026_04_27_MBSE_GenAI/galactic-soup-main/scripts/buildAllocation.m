function buildAllocation()
% BUILDALLOCATION Create all three SR Implement allocation layers.
%   Consolidates buildFunctionalAllocation.m + buildLogicalAllocation.m +
%   buildPhysicalAllocation.m into a single entry point. Idempotent: wipes
%   every Implement link in the SR set before recreating all three layers,
%   so ordering inside buildAll.m no longer matters.
%
%   After running, slreq.saveAll() commits the link changes and the three
%   ~mdl.slmx files are registered with the project (guarded with isfile --
%   a slmx exists only when its model has been the source of at least one
%   link this session).

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    reqDir   = fullfile(rootDir, 'requirements');
    archDir  = fullfile(rootDir, 'architecture');

    srFile = fullfile(reqDir, 'SystemRequirements.slreqx');

    slreq.clear();
    srSet = slreq.load(srFile);

    addpath(archDir);
    funcModel = systemcomposer.openModel('GalacticSoupFunctional');
    logModel  = systemcomposer.openModel('GalacticSoupLogical');
    physModel = systemcomposer.openModel('GalacticSoupPhysical');
    funcArch  = funcModel.Architecture;
    logArch   = logModel.Architecture;
    physArch  = physModel.Architecture;

    % Wipe all Implement links on every SR (from any source model) before
    % rebuilding. This is the consolidated equivalent of calling the scoped
    % removeImplementLinksToModel for each of the three models.
    allReqs = srSet.find('Type','Requirement');
    for i = 1:numel(allReqs)
        lnks = allReqs(i).inLinks();
        for j = 1:numel(lnks)
            if strcmp(lnks(j).Type, 'Implement'), lnks(j).remove(); end
        end
    end

    % ── Functional -> SR ────────────────────────────────────────────────────
    funcAlloc = {
        'SR-GS-001', { 'ManageRecipes', 'CookSoup' };
        'SR-GS-002', { 'CookSoup', 'CoordinateProduction' };
        'SR-GS-003', { 'CoordinateProduction' };
        'SR-GS-004', { 'CoordinateProduction' };
        'SR-GS-005', { 'GenerateManifest' };
        'SR-GS-006', { 'LoadTransport' };
        'SR-GS-007', { 'InspectQuality' };
        'SR-GS-008', { 'InspectQuality' };
        'SR-GS-009', { 'PackageSoup' };
        'SR-GS-010', { 'StoreIngredients' };
        'SR-GS-011', { 'CoordinateProduction' };
        'SR-GS-012', { 'CoordinateProduction' };
        'SR-GS-013', { 'CoordinateProduction' };
        'SR-GS-014', { 'CoordinateProduction' };
        'SR-GS-015', { 'CoordinateProduction' };
        'SR-GS-016', { 'CoordinateProduction' };
        'SR-GS-017', { 'HandleRocket' };
        'SR-GS-018', { 'HandleRocket' };
        'SR-GS-019', { 'RefuelRocket' };
        'SR-GS-020', { 'StoreIngredients' };
        'SR-GS-021', { 'StoreIngredients' };
        'SR-GS-022', { 'CookSoup' };
        'SR-GS-023', { 'TransferIngredients' };
        'SR-GS-024', { 'TransferIngredients' };
        'SR-GS-025', { 'CoordinateProduction' };
        'SR-GS-026', { 'CoordinateProduction' };
        'SR-GS-027', { 'CoordinateProduction' };
        'SR-GS-028', { 'PrepareIngredients' };
    };
    nF = applyAllocation(srSet, funcArch, funcAlloc);

    % ── Logical -> SR ───────────────────────────────────────────────────────
    logAlloc = {
        'SR-GS-003', { 'ProductionController' };
        'SR-GS-004', { 'ProductionController' };
        'SR-GS-010', { 'IngredientStore' };
        'SR-GS-017', { 'RocketPad' };
        'SR-GS-018', { 'RocketPad' };
        'SR-GS-024', { 'MaterialHandler' };
        'SR-GS-025', { 'ProductionController' };
        'SR-GS-026', { 'ProductionController' };
        'SR-GS-027', { 'ProductionController' };
        'SR-GS-028', { 'PrepStation' };
    };
    nL = applyAllocation(srSet, logArch, logAlloc);

    % ── Physical -> SR ──────────────────────────────────────────────────────
    allOperational = {'ColdStorage','AmbientStorage','ConveyanceSystem', ...
                      'PrepStation', ...
                      'CookingLine','InspectionStation','PackagingLine', ...
                      'RocketPadComplex','ControlComputer'};
    physAlloc = {
        'SR-GS-006', { 'ConveyanceSystem', 'RocketPadComplex' };
        'SR-GS-007', { 'InspectionStation' };
        'SR-GS-008', { 'InspectionStation' };
        'SR-GS-009', { 'PackagingLine' };
        'SR-GS-015', allOperational;
        'SR-GS-016', allOperational;
        'SR-GS-017', { 'RocketPadComplex' };
        'SR-GS-018', { 'RocketPadComplex' };
        'SR-GS-019', { 'RocketPadComplex' };
        'SR-GS-020', { 'ColdStorage', 'AmbientStorage' };
        'SR-GS-021', { 'ColdStorage', 'AmbientStorage' };
        'SR-GS-028', { 'PrepStation' };
    };
    nP = applyAllocation(srSet, physArch, physAlloc);

    slreq.saveAll();

    % Register ~mdl.slmx files if they exist (guard -- they may not if the
    % first-link autosave happened differently on this run).
    slmxFiles = { ...
        fullfile(archDir, 'GalacticSoupFunctional~mdl.slmx'), ...
        fullfile(archDir, 'GalacticSoupLogical~mdl.slmx'), ...
        fullfile(archDir, 'GalacticSoupPhysical~mdl.slmx')};
    existing = slmxFiles(cellfun(@isfile, slmxFiles));
    if ~isempty(existing), registerWithProject(existing); end

    % Coverage check
    srs = srSet.find('Type','Requirement');
    withImpl = 0;
    for i = 1:numel(srs)
        ins = srs(i).inLinks();
        if any(strcmp({ins.Type}, 'Implement')), withImpl = withImpl + 1; end
    end

    fprintf('\n=== Consolidated allocation ===\n');
    fprintf('  Functional -> SR: %d links\n', nF);
    fprintf('  Logical    -> SR: %d links\n', nL);
    fprintf('  Physical   -> SR: %d links\n', nP);
    fprintf('  Total Implement links: %d\n', nF + nL + nP);
    fprintf('  SRs with >=1 Implement link: %d / %d\n', withImpl, numel(srs));
end

function n = applyAllocation(srSet, arch, table)
    n = 0;
    for i = 1:size(table,1)
        srId = table{i,1};
        req  = srSet.find('Type','Requirement','Id',srId);
        if isempty(req), warning('SR %s not found', srId); continue; end
        for k = 1:numel(table{i,2})
            cname = table{i,2}{k};
            comp  = arch.getComponent(cname);
            if isempty(comp), warning('Component %s not found in arch', cname); continue; end
            lnk      = slreq.createLink(comp, req(1));
            lnk.Type = 'Implement';
            n = n + 1;
        end
    end
end
