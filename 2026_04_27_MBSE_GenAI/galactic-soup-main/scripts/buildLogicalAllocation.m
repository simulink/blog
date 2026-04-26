function buildLogicalAllocation()
% BUILDLOGICALALLOCATION Create Logical -> SR Implement links.
%   Per-phase Implement allocation for the logical layer (non-functional and
%   logical-role-specific SRs). Superseded by buildAllocation.m in Phase 7,
%   which consolidates F/L/P Implement links.
%
%   Uses removeImplementLinksToModel scoped to GalacticSoupLogical so
%   functional-model Implement links (created by buildFunctionalAllocation.m)
%   are untouched and the two scripts can run in any order.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    reqDir   = fullfile(rootDir, 'requirements');
    archDir  = fullfile(rootDir, 'architecture');

    modelName = 'GalacticSoupLogical';
    srFile    = fullfile(reqDir, 'SystemRequirements.slreqx');
    slmxFile  = fullfile(archDir, [modelName, '~mdl.slmx']);

    slreq.clear();
    srSet = slreq.load(srFile);

    addpath(archDir);
    logModel = systemcomposer.openModel(modelName);
    logArch  = logModel.Architecture;

    nRemoved = removeImplementLinksToModel(srSet, modelName);

    % SR -> Logical element mapping (non-functional + logical-role-specific)
    logAllocation = {
        'SR-GS-003', { 'ProductionController' };
        'SR-GS-004', { 'ProductionController' };
        'SR-GS-010', { 'IngredientStore' };
        'SR-GS-017', { 'RocketPad' };
        'SR-GS-018', { 'RocketPad' };
        'SR-GS-024', { 'MaterialHandler' };
        'SR-GS-025', { 'ProductionController' };
        'SR-GS-026', { 'ProductionController' };
        'SR-GS-027', { 'ProductionController' };
    };

    nCreated = 0;
    for i = 1:size(logAllocation,1)
        srId = logAllocation{i,1};
        req  = srSet.find('Type','Requirement','Id',srId);
        if isempty(req)
            warning('SR %s not found, skipping', srId);
            continue;
        end
        for k = 1:numel(logAllocation{i,2})
            lname = logAllocation{i,2}{k};
            comp  = logArch.getComponent(lname);
            if isempty(comp)
                warning('Logical element %s not found in %s, skipping', lname, modelName);
                continue;
            end
            lnk      = slreq.createLink(comp, req(1));
            lnk.Type = 'Implement';
            nCreated = nCreated + 1;
        end
    end

    slreq.saveAll();

    if isfile(slmxFile)
        registerWithProject({slmxFile});
    end

    fprintf('\n=== Logical allocation ===\n');
    fprintf('  Implement links removed (stale): %d\n', nRemoved);
    fprintf('  Implement links created:         %d\n', nCreated);
end
