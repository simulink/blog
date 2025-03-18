function SC = mdlSankey(mdl,lim)
    arguments
        mdl char
        lim (1,1) {mustBeNumeric} = 1;
    end
    warning('off','SankeyChart:UnbalancedGraph');
    % Fill the table with find_system
    T = mdlTable(table(),mdl);
    % Cut elements with less blocks than "lim"
    T(T.Weight<lim,:) = [];
    % create digraph
    DG = digraph(T);
    % Plot
    f = uifigure;
    SC = SankeyChart( "Parent", f, "GraphData", DG );
    SC.LabelIncludeTotal = "on";
    % Fix labels
    SC = fixBlockNames(SC);
end
