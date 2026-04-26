function runAnalysis()
% RUNANALYSIS Phase 8 rollup analysis for GalacticSoup.
%   Instantiates the physical architecture against ComponentCharacteristics,
%   iterates PostOrder to compute per-composite rollups via
%   @galacticSoupRollup, then reads top-level aggregated values and reports
%   margins against SR budgets (mass, power, cost) and minimums (throughput).
%   Reliability is reported as informational (no SR cap).
%
%   SR-014 volume cap is intentionally NOT analyzed -- the stereotype does
%   not carry Volume_m3 (per Phase 8 option B; see decisions.md).

    proj        = matlab.project.currentProject();
    reqDir      = fullfile(proj.RootFolder, 'requirements');
    archDir     = fullfile(proj.RootFolder, 'architecture');
    analysisDir = fullfile(proj.RootFolder, 'analysis');

    profileName = 'GalacticSoupProfile';
    modelName   = 'GalacticSoupPhysical';
    prefix      = [profileName, '.ComponentCharacteristics.'];

    % ── Read caps from SR set (not hard-coded) ──────────────────────────────
    slreq.clear();
    srSet = slreq.open(fullfile(reqDir, 'SystemRequirements.slreqx'));
    capMass       = parseBudgetValue(srSet, 'SR-GS-011', 'kg');
    capPower      = parseBudgetValue(srSet, 'SR-GS-012', 'kW') * 1000; % convert to W
    capCost       = parseBudgetValue(srSet, 'SR-GS-013', 'credits');
    minThroughput = parseMinValue   (srSet, 'SR-GS-002', 'bowls/hour');

    % ── Instantiate + PostOrder rollup ──────────────────────────────────────
    addpath(archDir);
    model    = systemcomposer.openModel(modelName);
    arch     = model.Architecture;
    instance = instantiate(arch, profileName, 'GalacticSoupRollup');
    iterate(instance, 'PostOrder', @galacticSoupRollup);

    % ── Read system-level totals from direct top-level children ─────────────
    topKids = instance.Components;
    totMass  = sumTop  (topKids, [prefix, 'Mass_kg']);
    totPower = sumTop  (topKids, [prefix, 'Power_W']);
    totCost  = sumTop  (topKids, [prefix, 'Cost_credits']);
    minTp    = minTopPos(topKids, [prefix, 'Throughput_soupsPerHr']);
    sysMtbf  = seriesTop(topKids, [prefix, 'Reliability_MTBF_hr']);

    % ── Report ──────────────────────────────────────────────────────────────
    fprintf('\n%-24s %14s %14s %14s %8s\n', 'Metric','Value','Target','Margin','OK');
    fprintf('%s\n', repmat('-', 1, 80));
    passFmt = @(ok) ternary(ok, 'PASS', 'FAIL');
    report  = {
        'Mass (kg)',       totMass,   capMass,       capMass  - totMass,   totMass  <= capMass;
        'Power (W)',       totPower,  capPower,      capPower - totPower,  totPower <= capPower;
        'Cost (credits)',  totCost,   capCost,       capCost  - totCost,   totCost  <= capCost;
        'Throughput (sph)',minTp,     minThroughput, minTp    - minThroughput, minTp >= minThroughput;
    };
    for i = 1:size(report,1)
        fprintf('%-24s %14.2f %14.2f %14.2f %8s\n', ...
            report{i,1:4}, passFmt(report{i,5}));
    end
    fprintf('%-24s %14.2f %14s %14s %8s\n', ...
        'System MTBF (hr)', sysMtbf, 'n/a', 'n/a', 'INFO');

    % ── Save for the Analysis Viewer ────────────────────────────────────────
    save(instance, fullfile(analysisDir, 'GalacticSoupRollup.mat'));
    systemcomposer.analysis.openViewer('Source', instance);

    registerWithProject({ ...
        fullfile(analysisDir, 'GalacticSoupRollup.mat'), ...
        fullfile(analysisDir, 'galacticSoupRollup.m') ...
    });

    fprintf('\nSaved: analysis/GalacticSoupRollup.mat (viewer opened with live instance)\n');
end

% ── Top-level aggregation helpers ─────────────────────────────────────────────

function s = sumTop(comps, prop)
    s = 0;
    for i = 1:numel(comps)
        if comps(i).hasValue(prop), s = s + comps(i).getValue(prop); end
    end
end

function m = minTopPos(comps, prop)
    m = inf;
    for i = 1:numel(comps)
        if comps(i).hasValue(prop)
            v = comps(i).getValue(prop);
            if v > 0 && v < m, m = v; end
        end
    end
    if ~isfinite(m), m = 0; end
end

function mtbf = seriesTop(comps, prop)
    sumInv = 0; any_pos = false;
    for i = 1:numel(comps)
        if comps(i).hasValue(prop)
            v = comps(i).getValue(prop);
            if v > 0, sumInv = sumInv + 1/v; any_pos = true; end
        end
    end
    if any_pos, mtbf = 1/sumInv; else, mtbf = 0; end
end

% ── SR-description parsing ────────────────────────────────────────────────────

function value = parseBudgetValue(srSet, reqId, unit)
% Extract numeric cap from a "shall not exceed X <unit>" requirement.
    req  = srSet.find('Id', reqId);
    desc = req.Description;
    tok  = regexp(desc, ['not exceed\s+([\d.]+)\s+', unit], 'tokens', 'once');
    if isempty(tok)
        tok = regexp(desc, ['not exceed\s+', unit, '\s+([\d.]+)'], 'tokens', 'once');
    end
    if isempty(tok)
        error('parseBudgetValue:noMatch', 'Cannot parse %s cap from %s.', unit, reqId);
    end
    value = str2double(tok{1});
end

function value = parseMinValue(srSet, reqId, unit)
% Extract numeric floor from an "at least X <unit>" requirement.
    req  = srSet.find('Id', reqId);
    desc = req.Description;
    patterns = {
        ['(?:&gt;=|>=|at least|support[s]?)\s*([\d.]+)\s+', unit]
        ['([\d.]+)\s+', unit]
    };
    tok = [];
    for i = 1:numel(patterns)
        tok = regexp(desc, patterns{i}, 'tokens', 'once');
        if ~isempty(tok), break; end
    end
    if isempty(tok)
        error('parseMinValue:noMatch', 'Cannot parse %s floor from %s.', unit, reqId);
    end
    value = str2double(tok{1});
end

function s = ternary(cond, a, b), if cond, s = a; else, s = b; end, end
