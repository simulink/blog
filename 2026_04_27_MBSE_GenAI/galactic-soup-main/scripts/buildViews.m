function buildViews()
% BUILDVIEWS Create review-dashboard architecture views on the physical model.
%   Must run after buildPhysical.m -- a physical-model rebuild wipes views.
%   Idempotent: the buildMyViews helper deletes any existing view with the
%   same name before creating.

    modelName     = 'GalacticSoupPhysical';
    profilePrefix = 'GalacticSoupProfile.ComponentCharacteristics.';

    % {name, propertyName, op, value, color}
    % Note: Bottlenecks is query-expressible only as < 200. The "and > 0" side
    % is covered by the ZeroEstimate_Flag view which is scanned alongside it
    % during review -- components with Throughput == 0 (not in the pipeline)
    % would otherwise show up as false-positive bottlenecks.
    viewSpecs = {
        'CostDrivers',        'Cost_credits',          'gt', 200000, '#D62728';
        'HighPowerConsumers', 'Power_W',               'gt',  50000, '#FF7F0E';
        'HeavyPayload',       'Mass_kg',               'gt',   2000, '#8C564B';
        'Bottlenecks',        'Throughput_soupsPerHr', 'lt',    200, '#E377C2';
        'ZeroEstimate_Flag',  'Cost_credits',          'eq',      0, '#17BECF';
    };

    buildMyViews(modelName, profilePrefix, viewSpecs);

    % SafetyCritical is a string-equality query -- handle separately because
    % the generic buildMyViews helper is numeric-op only. Create via the
    % direct systemcomposer.query API.
    import systemcomposer.query.*;
    model = systemcomposer.openModel(modelName);
    try, deleteView(model, 'SafetyCritical'); end %#ok<TRYNC>
    pv = PropertyValue([profilePrefix, 'SafetyLevel']);
    q  = pv == "Critical";
    createView(model, 'SafetyCritical', Select=q, Color='#9467BD');
    n  = numel(find(model, q));
    fprintf('  %-28s %s eq "%s"  ->  %d match(es)\n', ...
        'SafetyCritical', 'SafetyLevel', 'Critical', n);
    save_system(modelName);
end
