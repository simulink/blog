function SC = fixBlockNames(SC)

    warning('off','SankeyChart:UnbalancedGraph');

    % I need to use the full blockpath for the nodes, but displaying the full
    % blockpath in the plot takes way too much space... so let's see if we can
    % replace with the block name only.
    clear blkNames
    for i = 1:height(SC.GraphData.Nodes)
        blkNames(i,1) = string(get_param(SC.GraphData.Nodes.Name(i),'Name'));
    end
    NodeTable = table(blkNames,'VariableNames',"Name");

    % I get an error if there are duplicates... padding duplicates with an index
    [uniqueStr, ~, idx] = unique(NodeTable.Name);
    counts = accumarray(idx, 1);
    dupMask = counts > 1;
    duplicateStrings = uniqueStr(dupMask);
    % Modify duplicate entries by appending an index
    for i = 1:numel(duplicateStrings)
        dupIndices = find(NodeTable.Name == duplicateStrings(i));
        for j = 2:numel(dupIndices)  % Start from the second occurrence
            NodeTable.Name(dupIndices(j)) = NodeTable.Name(dupIndices(j)) + "_" + j;
        end
    end

    SC.GraphData.Nodes = NodeTable;

    warning('on','SankeyChart:UnbalancedGraph');