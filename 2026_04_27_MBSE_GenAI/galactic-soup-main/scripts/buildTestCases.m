function buildTestCases()
% BUILDTESTCASES Create one TC per SR with a Verify link.
%   Uses the load-or-clear-and-repopulate idempotency pattern (skill guidance):
%   slreq.new(tcFile) intermittently fails with "name conflict" when the same
%   long pipeline re-runs, even after slreq.clear() + delete(tcFile). Loading
%   the existing set, clearing its LinkSet first (to avoid orphan outLinks in
%   the .slmx), then removing its requirements in reverse order, is robust.

    proj    = matlab.project.currentProject();
    rootDir = proj.RootFolder;
    reqDir  = fullfile(rootDir, 'requirements');

    srFile = fullfile(reqDir, 'SystemRequirements.slreqx');
    tcFile = fullfile(reqDir, 'TestCases.slreqx');
    tcSlmx = fullfile(reqDir, 'TestCases~slreqx.slmx');

    slreq.clear();
    srSet = slreq.load(srFile);

    if isfile(tcFile)
        tcSet = slreq.load(tcFile);

        % Clear LinkSet first -- req.remove() otherwise leaves orphan outLinks
        % in the .slmx that produce "unresolved source" warnings on reload.
        lnkSets = slreq.find('type','LinkSet','Artifact', tcFile);
        for i = 1:numel(lnkSets)
            links = lnkSets(i).getLinks();
            for j = 1:numel(links), links(j).remove(); end
        end

        existing = tcSet.find('Type','Requirement');
        for k = numel(existing):-1:1, existing(k).remove(); end
    else
        tcSet = slreq.new(tcFile);
    end

    % { 'SR-GS-NNN', 'TC-GS-NNN', 'Summary', 'Description' }
    specs = {
        'SR-GS-001','TC-GS-001','Recipe catalog verification',         'Load recipe database; verify >= 8 distinct recipes are selectable via the operator HMI at runtime.';
        'SR-GS-002','TC-GS-002','Sustained throughput',                'Run production line for >= 1 h at nominal ingredient supply; verify bowls output >= 200/hr.';
        'SR-GS-003','TC-GS-003','Automation level check',              'Observe normal shift operations; verify average automation fraction across components >= 0.8.';
        'SR-GS-004','TC-GS-004','Operator-count cap',                  'Run a peak-load shift; verify concurrent active operator count <= 5 at all sample points.';
        'SR-GS-005','TC-GS-005','Manifest generation',                 'Complete a batch; verify a shipping manifest is generated containing batch ID, container count, and destination.';
        'SR-GS-006','TC-GS-006','Transport loading time',              'Trigger packaging completion; verify packaged soup is loaded onto transport within 10 min.';
        'SR-GS-007','TC-GS-007','Contamination detection',             'Inject contamination in 100 seeded batches; verify at least 99 flagged before sealing (>= 99% sensitivity).';
        'SR-GS-008','TC-GS-008','Serving temperature verification',    'Present 20 cooked batches with induced temperature variation; verify only batches with center temperature in 70-95 C pass QC.';
        'SR-GS-009','TC-GS-009','30-day seal life',                    'Seal sample containers; apply 30-day vacuum/thermal cycling per interstellar transit profile; verify seal integrity maintained.';
        'SR-GS-010','TC-GS-010','Inventory accuracy',                  'Audit physical vs. tracked inventory over 30 days of nominal operation; verify discrepancy <= 1%.';
        'SR-GS-011','TC-GS-011','Mass budget (analysis)',              'Run runAnalysis(); verify Mass margin >= 0 against the 15000 kg cap.';
        'SR-GS-012','TC-GS-012','Power budget (analysis)',             'Run runAnalysis(); verify Power margin >= 0 against the 500 kW cap.';
        'SR-GS-013','TC-GS-013','Cost budget (analysis)',              'Run runAnalysis(); verify Cost margin >= 0 against the 2000000 credit cap.';
        'SR-GS-014','TC-GS-014','Volume budget (measurement)',         'Measure total enclosed system volume via as-built survey; verify <= 400 m^3. (Not covered by Phase 8 analysis.)';
        'SR-GS-015','TC-GS-015','Gravity operating range',             'Perform cooking, packaging, and shipping reference runs at 0.1 g, 1 g, 6 g, and 12 g; verify nominal behavior at each setpoint.';
        'SR-GS-016','TC-GS-016','Structural 12 g tolerance',           'Apply sustained 12 g load to structural elements per structural test procedure; verify no permanent deformation post-test.';
        'SR-GS-017','TC-GS-017','Concurrent-rocket capacity',          'Dock three rockets simultaneously; verify all three are serviced (loaded or unloaded) without queuing conflicts.';
        'SR-GS-018','TC-GS-018','Rocket turnaround',                   'Dock a reference rocket at a free pad; verify load-or-unload completes within 20 min of dock-time.';
        'SR-GS-019','TC-GS-019','On-site refueling',                   'Dock a rocket requiring fuel service; verify onsite refueling completes to nominal fuel level.';
        'SR-GS-020','TC-GS-020','Storage zone separation',             'Inspect storage area; verify cold and room-temperature zones are physically and thermally separated and each holds its nominal target temperature.';
        'SR-GS-021','TC-GS-021','72 h ingredient capacity',            'Load ingredients at 72 h nominal consumption rate; verify storage accepts the full volume without overflow or cold-chain violation.';
        'SR-GS-022','TC-GS-022','Cooking capacity',                    'Operate cooking subsystem at continuous steady state; verify sustained cook rate meets or exceeds the system throughput target.';
        'SR-GS-023','TC-GS-023','Internal transfer rate',              'Measure transfer rate from storage to cooking at nominal demand; verify sustained flow meets cooking-demand rate.';
        'SR-GS-024','TC-GS-024','Transfer automation fraction',        'Observe internal transfer operations over a nominal shift; verify >= 90% of transfers are automated (no operator assist).';
        'SR-GS-025','TC-GS-025','Startup readiness',                   'Trigger a cold start from fully-off state; verify system reaches nominal operating throughput within the defined startup period.';
        'SR-GS-026','TC-GS-026','Single-fault tolerance',              'Inject a single internal component fault during production; verify no uncontrolled termination (system degrades gracefully or continues).';
        'SR-GS-027','TC-GS-027','Production coordination',             'Observe concurrent operations across shifts; verify throughput, safety, and logistical constraints are simultaneously satisfied.';
        'SR-GS-028','TC-GS-028','Preparation zone',                    'Inspect factory layout; verify a physically-isolated prep zone exists containing chopping and weighing stations. Run prep in isolation; verify sustained prep rate >= 200 bowls/hour equivalent.';
    };

    nCreated = 0;
    for i = 1:size(specs,1)
        srId = specs{i,1};
        tcId = specs{i,2};

        tc             = tcSet.add();
        tc.Id          = tcId;
        tc.Summary     = specs{i,3};
        tc.Description = specs{i,4};
        tc.Rationale   = ['Verifies ', srId];

        sr = srSet.find('Type','Requirement','Id',srId);
        if isempty(sr)
            warning('SR %s not found; TC %s created but not linked', srId, tcId);
            continue;
        end
        lnk      = slreq.createLink(tc, sr(1));
        lnk.Type = 'Verify';
        nCreated = nCreated + 1;
    end

    tcSet.save();
    slreq.saveAll();

    filesToRegister = {tcFile};
    if isfile(tcSlmx), filesToRegister{end+1} = tcSlmx; end
    registerWithProject(filesToRegister);

    % Coverage check
    allSrs = srSet.find('Type','Requirement');
    verified = 0;
    for i = 1:numel(allSrs)
        ins = allSrs(i).inLinks();
        if any(strcmp({ins.Type}, 'Verify')), verified = verified + 1; end
    end

    fprintf('\n=== Test cases ===\n');
    fprintf('  TCs created:                 %d\n', size(specs,1));
    fprintf('  Verify links created:        %d\n', nCreated);
    fprintf('  SRs with >=1 Verify link:    %d / %d\n', verified, numel(allSrs));
end
