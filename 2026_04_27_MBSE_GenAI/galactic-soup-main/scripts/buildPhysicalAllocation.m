function buildPhysicalAllocation()
% BUILDPHYSICALALLOCATION Create Physical -> SR Implement links.
%   Per-phase Implement allocation for the physical layer (hardware-specific,
%   environmental, packaging, installation SRs). Superseded by
%   buildAllocation.m in Phase 7.
%
%   Budget SRs (SR-011..014) are NOT allocated here -- they are system-wide
%   caps verified by the Phase 8 rollup analysis, and stay on
%   CoordinateProduction at the functional layer.
%
%   Uses removeImplementLinksToModel scoped to GalacticSoupPhysical so
%   Functional and Logical Implement links are untouched.

    proj     = matlab.project.currentProject();
    rootDir  = proj.RootFolder;
    reqDir   = fullfile(rootDir, 'requirements');
    archDir  = fullfile(rootDir, 'architecture');

    modelName = 'GalacticSoupPhysical';
    srFile    = fullfile(reqDir, 'SystemRequirements.slreqx');
    slmxFile  = fullfile(archDir, [modelName, '~mdl.slmx']);

    slreq.clear();
    srSet = slreq.load(srFile);

    addpath(archDir);
    physModel = systemcomposer.openModel(modelName);
    physArch  = physModel.Architecture;

    nRemoved = removeImplementLinksToModel(srSet, modelName);

    % Operational + structural top-level components — used as the "all
    % physical operational" target for environmental SRs.
    allOperational = {'ColdStorage','AmbientStorage','ConveyanceSystem', ...
                      'CookingLine','InspectionStation','PackagingLine', ...
                      'RocketPadComplex','ControlComputer'};

    physAllocation = {
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
    };

    nCreated = 0;
    for i = 1:size(physAllocation,1)
        srId = physAllocation{i,1};
        req  = srSet.find('Type','Requirement','Id',srId);
        if isempty(req)
            warning('SR %s not found, skipping', srId);
            continue;
        end
        targets = physAllocation{i,2};
        for k = 1:numel(targets)
            pname = targets{k};
            comp  = physArch.getComponent(pname);
            if isempty(comp)
                warning('Physical component %s not found in %s, skipping', pname, modelName);
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

    fprintf('\n=== Physical allocation ===\n');
    fprintf('  Implement links removed (stale): %d\n', nRemoved);
    fprintf('  Implement links created:         %d\n', nCreated);
    fprintf('  SRs covered by Physical layer:   %d\n', size(physAllocation,1));
end
