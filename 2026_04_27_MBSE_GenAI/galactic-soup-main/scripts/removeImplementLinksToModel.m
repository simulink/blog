function nRemoved = removeImplementLinksToModel(srSet, modelBasename)
% REMOVEIMPLEMENTLINKSTOMODEL Remove only the Implement links sourced from a given model.
%   Scans every requirement in the SR set for inLinks of type Implement, and
%   removes those whose source artifact matches the given model basename.
%   Leaves Implement links from other models untouched -- used by each per-phase
%   allocation script so it only cleans up its own links, enabling the three
%   per-phase allocation scripts (Functional/Logical/Physical) to be re-run
%   in any order without wiping each other out.
%
%   Inputs:
%     srSet         - slreq.ReqSet to scan
%     modelBasename - Model file basename (e.g. 'GalacticSoupFunctional' or
%                     'GalacticSoupFunctional.slx'); the basename is matched
%                     against lnk.source().artifact via `contains`.
%
%   Output:
%     nRemoved - Count of Implement links removed

    nRemoved = 0;
    reqs    = srSet.find('Type','Requirement');
    needle  = char(modelBasename);
    for i = 1:numel(reqs)
        lnks = reqs(i).inLinks();
        for j = 1:numel(lnks)
            if ~strcmp(lnks(j).Type, 'Implement'), continue; end
            try
                src = lnks(j).source();
            catch
                continue;
            end
            art = char(src.artifact);
            if contains(art, needle)
                lnks(j).remove();
                nRemoved = nRemoved + 1;
            end
        end
    end
end
