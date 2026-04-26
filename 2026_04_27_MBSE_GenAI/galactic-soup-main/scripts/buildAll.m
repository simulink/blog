function buildAll()
% BUILDALL Rebuild every GalacticSoup artifact from scratch, in order.
%   Single entry point for a clean rebuild. Every phase script is idempotent;
%   running buildAll twice is equivalent to running it once.
%
%   Phase allocation scripts: buildAllocation.m (Phase 7) supersedes the three
%   per-phase allocation scripts (buildFunctionalAllocation, buildLogical-
%   Allocation, buildPhysicalAllocation) -- we call buildAllocation here.
%   The per-phase scripts remain in scripts/ for ad-hoc layer-scoped runs.

    tStart = tic;

    step('Requirements',         @buildRequirements);
    step('Functional arch',      @buildFunctional);
    step('Logical arch',         @buildLogical);
    step('Physical arch',        @buildPhysical);
    step('Architecture views',   @buildViews);
    step('F -> L allocation',    @buildFunctionalToLogical);
    step('L -> P allocation',    @buildLogicalToPhysical);
    step('SR Implement links',   @buildAllocation);
    step('Rollup analysis',      @runAnalysis);
    step('Test cases',           @buildTestCases);

    fprintf('\nTotal rebuild time: %.1f s\n', toc(tStart));

    %% Register all scripts with the project
    scriptsDir = fileparts(mfilename('fullpath'));
    scriptFiles = { ...
        fullfile(scriptsDir, 'buildAll.m'), ...
        fullfile(scriptsDir, 'buildAllocation.m'), ...
        fullfile(scriptsDir, 'buildFunctional.m'), ...
        fullfile(scriptsDir, 'buildFunctionalAllocation.m'), ...
        fullfile(scriptsDir, 'buildFunctionalToLogical.m'), ...
        fullfile(scriptsDir, 'buildLogical.m'), ...
        fullfile(scriptsDir, 'buildLogicalAllocation.m'), ...
        fullfile(scriptsDir, 'buildLogicalToPhysical.m'), ...
        fullfile(scriptsDir, 'buildMyViews.m'), ...
        fullfile(scriptsDir, 'buildPhysical.m'), ...
        fullfile(scriptsDir, 'buildPhysicalAllocation.m'), ...
        fullfile(scriptsDir, 'buildRequirements.m'), ...
        fullfile(scriptsDir, 'buildTestCases.m'), ...
        fullfile(scriptsDir, 'buildViews.m'), ...
        fullfile(scriptsDir, 'importMyRequirements.m'), ...
        fullfile(scriptsDir, 'registerWithProject.m'), ...
        fullfile(scriptsDir, 'removeImplementLinksToModel.m'), ...
        fullfile(scriptsDir, 'runAnalysis.m'), ...
        fullfile(scriptsDir, 'setupMBSEProject.m'), ...
        fullfile(scriptsDir, 'setupProject.m'), ...
    };
    registerWithProject(scriptFiles);

    %% Project health check (verbatim block from matlab-project skill)
    proj = matlab.project.currentProject();
    if ~isempty(proj.Name)
        results = runChecks(proj);
        nFail = 0;
        fprintf('\nProject checks:\n');
        for i = 1:numel(results)
            if results(i).Passed
                fprintf('  [PASS] %s\n', results(i).Description);
            else
                fprintf('  [FAIL] %s\n', results(i).Description);
                for j = 1:numel(results(i).ProblemFiles)
                    fprintf('           %s\n', results(i).ProblemFiles(j));
                end
                nFail = nFail + 1;
            end
        end
        if nFail == 0
            fprintf('All checks passed.\n');
        else
            fprintf('%d check(s) failed -- review output above.\n', nFail);
        end
    end
end

function step(label, fn)
    fprintf('\n>>> %s\n', label);
    t0 = tic;
    fn();
    fprintf('    (%.1f s)\n', toc(t0));
end
