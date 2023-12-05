function [strongly] = check_strongly_connected(graph)
% Check whether the graph is strongly connected or not
bins = conncomp(graph, 'Type', 'strong');
if all(bins == 1)
    strongly = 1;
else
    strongly = 0;
end
