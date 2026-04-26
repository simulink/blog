function galacticSoupRollup(instance, varargin)
% GALACTICSOUPROLLUP Per-composite rollup callback for the Phase 8 analysis.
%   Invoked via iterate(instance, 'PostOrder', @galacticSoupRollup) so that by
%   the time we visit a parent, all children already hold their aggregated
%   values. Aggregation rules per property:
%     - Mass_kg / Power_W / Cost_credits     -> SUM over children
%     - Throughput_soupsPerHr                -> MIN over children with value > 0
%                                               (zero = "not in pipeline")
%     - Reliability_MTBF_hr                  -> series reliability:
%                                               1 / sum(1 / MTBF_i) over children
%                                               with MTBF_i > 0
%   Supplier and SafetyLevel are strings and don't roll up; left untouched on
%   composites (remain at their default values).

    prefix = 'GalacticSoupProfile.ComponentCharacteristics.';

    if ~instance.isComponent() || isempty(instance.Components)
        return;  % leaves keep their designer-set values
    end

    % ── SUM aggregation ─────────────────────────────────────────────────────
    sumProps = {'Mass_kg','Power_W','Cost_credits'};
    for k = 1:numel(sumProps)
        p = [prefix, sumProps{k}];
        if instance.hasValue(p)
            tot = 0;
            for child = instance.Components
                if child.hasValue(p), tot = tot + child.getValue(p); end
            end
            instance.setValue(p, tot);
        end
    end

    % ── MIN over positive (throughput bottleneck) ───────────────────────────
    p = [prefix, 'Throughput_soupsPerHr'];
    if instance.hasValue(p)
        bottleneck = inf;
        for child = instance.Components
            if child.hasValue(p)
                v = child.getValue(p);
                if v > 0 && v < bottleneck, bottleneck = v; end
            end
        end
        if isfinite(bottleneck)
            instance.setValue(p, bottleneck);
        end
    end

    % ── Series reliability (1 / sum(1/MTBF_i) over positive children) ───────
    p = [prefix, 'Reliability_MTBF_hr'];
    if instance.hasValue(p)
        sumInv  = 0;
        anyPos  = false;
        for child = instance.Components
            if child.hasValue(p)
                v = child.getValue(p);
                if v > 0
                    sumInv = sumInv + 1/v;
                    anyPos = true;
                end
            end
        end
        if anyPos
            instance.setValue(p, 1/sumInv);
        end
    end
end
