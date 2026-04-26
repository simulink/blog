function buildRequirements()
% BUILDREQUIREMENTS Import Stakeholder Needs and System Requirements from
% the external xlsx files and create SN -> SR Derive links from the
% DerivedFrom column on the SR set.
%
% Idempotent: clears slreq state and deletes .slreqx / .slmx before
% re-importing on every run.

    proj    = matlab.project.currentProject();
    rootDir = proj.RootFolder;
    reqDir  = fullfile(rootDir, 'requirements');

    snXlsx = fullfile(reqDir, 'source', 'StakeholderNeeds.xlsx');
    srXlsx = fullfile(reqDir, 'source', 'SystemRequirements.xlsx');

    snSetName = 'StakeholderNeeds';
    srSetName = 'SystemRequirements';
    snFile = fullfile(reqDir, [snSetName, '.slreqx']);
    srFile = fullfile(reqDir, [srSetName, '.slreqx']);
    snSlmx = fullfile(reqDir, [snSetName, '~slreqx.slmx']);
    srSlmx = fullfile(reqDir, [srSetName, '~slreqx.slmx']);

    slreq.clear();
    if isfile(snFile), delete(snFile); end
    if isfile(srFile), delete(srFile); end
    if isfile(snSlmx), delete(snSlmx); end
    if isfile(srSlmx), delete(srSlmx); end

    snSet = importMyRequirements(snXlsx, snSetName, ...
        destDir=reqDir, attributeColumn=5, attributes={'DerivedFrom'});
    srSet = importMyRequirements(srXlsx, srSetName, ...
        destDir=reqDir, attributeColumn=5, attributes={'DerivedFrom'});

    % SN -> SR Derive links, driven by the SR DerivedFrom attribute.
    % Supports multiple parents separated by comma/semicolon/whitespace.
    srs = srSet.find('Type','Requirement');
    linkCount  = 0;
    unresolved = {};
    for i = 1:numel(srs)
        sr  = srs(i);
        raw = getAttribute(sr, 'DerivedFrom');
        if isempty(raw) || all(isspace(raw))
            continue;
        end
        parents = strsplit(strtrim(raw), {',',';',' '});
        parents(cellfun(@isempty, parents)) = [];
        for k = 1:numel(parents)
            snId = parents{k};
            sn   = snSet.find('Type','Requirement','Id',snId);
            if isempty(sn)
                unresolved{end+1} = sprintf('%s <- %s (not found)', sr.Id, snId); %#ok<AGROW>
                continue;
            end
            lnk      = slreq.createLink(sn(1), sr);
            lnk.Type = 'Derive';
            linkCount = linkCount + 1;
        end
    end

    snSet.save();
    srSet.save();
    slreq.saveAll();

    % Register artifacts. `~slreqx.slmx` is auto-created only for sets that are
    % the *source* of a link. SN is the source of every Derive link here, so
    % StakeholderNeeds~slreqx.slmx exists; SystemRequirements~slreqx.slmx
    % typically does not. Guard with isfile.
    filesToRegister = {snFile, srFile};
    if isfile(snSlmx), filesToRegister{end+1} = snSlmx; end
    if isfile(srSlmx), filesToRegister{end+1} = srSlmx; end
    registerWithProject(filesToRegister);

    nSn = numel(snSet.find('Type','Requirement'));
    nSr = numel(srs);
    fprintf('\n=== Requirements import ===\n');
    fprintf('  SN count: %d\n', nSn);
    fprintf('  SR count: %d\n', nSr);
    fprintf('  SN -> SR Derive links: %d\n', linkCount);
    if ~isempty(unresolved)
        fprintf('  UNRESOLVED DerivedFrom references:\n');
        for i = 1:numel(unresolved), fprintf('    %s\n', unresolved{i}); end
    else
        fprintf('  All DerivedFrom references resolved.\n');
    end
end
