function buildFunctionalAllocation()
% BUILDFUNCTIONALALLOCATION Create Function -> SR Implement links.
%   Per-phase Implement allocation for the functional layer. Superseded by
%   buildAllocation.m in Phase 7, which consolidates F/L/P Implement links.
%
%   Re-run this whenever buildFunctional.m is re-run -- Simulink SIDs change
%   on rebuild and any stored Implement links become stale.
%
%   Uses removeImplementLinksToModel to wipe only this model's Implement
%   links, leaving Logical and Physical Implement links (if any) untouched.
%   The three per-phase allocation scripts are independent in this sense.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    reqDir   = fullfile(rootDir, 'requirements');
    archDir  = fullfile(rootDir, 'architecture');

    modelName   = 'GalacticSoupFunctional';
    srFile      = fullfile(reqDir, 'SystemRequirements.slreqx');
    slmxFile    = fullfile(archDir, [modelName, '~mdl.slmx']);

    slreq.clear();
    srSet = slreq.load(srFile);

    addpath(archDir);
    funcModel = systemcomposer.openModel(modelName);
    funcArch  = funcModel.Architecture;

    nRemoved = removeImplementLinksToModel(srSet, modelName);

    % SR -> Function mapping (from Phase 2 derivation table)
    % { SR-ID, { function component names... } }
    funcAllocation = {
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
    };

    nCreated = 0;
    for i = 1:size(funcAllocation,1)
        srId = funcAllocation{i,1};
        req  = srSet.find('Type','Requirement','Id',srId);
        if isempty(req)
            warning('SR %s not found, skipping', srId);
            continue;
        end
        for k = 1:numel(funcAllocation{i,2})
            fname = funcAllocation{i,2}{k};
            comp  = funcArch.getComponent(fname);
            if isempty(comp)
                warning('Function %s not found in %s, skipping', fname, modelName);
                continue;
            end
            lnk      = slreq.createLink(comp, req(1));
            lnk.Type = 'Implement';
            nCreated = nCreated + 1;
        end
    end

    slreq.saveAll();

    % Register ~mdl.slmx auto-created beside the .slx when the first link lands.
    % Guard with isfile in case some oddity prevents creation -- this layer is
    % always a link source so the file should always exist after this script.
    if isfile(slmxFile)
        registerWithProject({slmxFile});
    end

    % Orphan check: any SR with no Implement link from any function?
    allSrs = srSet.find('Type','Requirement');
    orphans = {};
    for i = 1:numel(allSrs)
        ins = allSrs(i).inLinks();
        has = false;
        for j = 1:numel(ins)
            if strcmp(ins(j).Type,'Implement'), has = true; break; end
        end
        if ~has, orphans{end+1} = allSrs(i).Id; end %#ok<AGROW>
    end

    fprintf('\n=== Functional allocation ===\n');
    fprintf('  Implement links removed (stale): %d\n', nRemoved);
    fprintf('  Implement links created:         %d\n', nCreated);
    fprintf('  SRs with >=1 Implement link:     %d / %d\n', numel(allSrs)-numel(orphans), numel(allSrs));
    if ~isempty(orphans)
        fprintf('  Orphan SRs (no Implement):\n');
        for i=1:numel(orphans), fprintf('    %s\n', orphans{i}); end
    end
end
