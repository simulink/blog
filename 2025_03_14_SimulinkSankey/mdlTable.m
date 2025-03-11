function T = mdlTable(T,blk)
opts = Simulink.FindOptions;
opts.FollowLinks = true;
opts.SearchDepth = 1;
% Find the subsystems at this level
blks = Simulink.findBlocksOfType(blk,'SubSystem',opts);
% blockpath of the "source" in Sankey
SrcName = string(getfullname(get_param(blk,'handle')));
for i = 1:length(blks)
    % blockpath of the "destination" in Sankey
    DestName = string(getfullname(blks(i)));
    % Number of blocks inside this subsystem
    opts.SearchDepth = -1;
    Nchilds = max(length(Simulink.findBlocks(blks(i),opts)),1);
    % Fill the table
    if isempty(T)
        T = table([SrcName,DestName], Nchilds,'VariableNames',["EndNodes","Weight"]);
    else
        T(end+1,:) = {[SrcName,DestName], Nchilds}; %#ok<AGROW>
    end
    % Run the same on found subsystem
    T = mdlTable(T,blks(i));
end