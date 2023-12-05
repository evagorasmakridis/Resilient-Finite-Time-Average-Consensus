function adj = gen_graph(nodes, opt)
%GEN_GRAPH helper function that generates our graph
%

  % let the user know of the mishap.
  if nodes < 1
    error("we requite at least 1 node")
  end
  
  % if opt was not supplied initialise an empty struct
  if nargin < 2
    opt = struct;
  end
  
  % do not show the graphs by default
  if ~isfield(opt, "show_graph")
    opt.show_graph = 0;
  end
  
  % check if we are provided with an adjacency matrix
  if isfield(opt, "adj")
    opt.adj_matrix_method = "provided";
  elseif ~isfield(opt, "adj_matrix_method")
    % if not provided, use the "fancy method"
    opt.adj_matrix_method = "fancy";
  end
  
  % check if we have a connectivity constraint for the generated graph
  if ~isfield(opt, "connectivity")
    % enforce strong connectivity requirement, if not provided
    opt.connectivity = "strong";
  end
  
  % check if we have a max graph generation iteration constraint
  if ~isfield(opt, "max_graph_iter")
    opt.max_graph_iter = 10000;
  end
  
  is_connected_graph = 0;
  cnt = 0;
  while is_connected_graph == 0 && cnt < opt.max_graph_iter
    % generate a random binary graph adjacency matrix, 
    % which is also returned
    if opt.adj_matrix_method == "fancy"
      % specify some exact number of zeros
      zero_number = ceil(0.75 * (nodes^2)); % 10 valid links 
      % create the matrix using full zeros
      adj = ones(nodes);
      % now set the number of zeros
      adj(1:zero_number) = 0; 
      adj(randperm(numel(adj))) = adj;
    elseif opt.adj_matrix_method == "regular"
      % a more basic method
      adj = round(rand(nodes));
      adj = triu(adj) + triu(adj, 1)';
      adj = adj - diag(diag(adj));
    end

    % now create a graph g, based on either the provided or generated 
    % adjacency matrix
    for i=1:nodes
        adj(i,i)=0;
    end
    adj = adj + eye(nodes,nodes);
    G = digraph(adj);

    % ensure we have the proper connectivity
    if opt.connectivity == "strong"
      bins = conncomp(G, 'Type', 'strong');
      is_connected_graph = all(bins == 1);
    elseif opt.connectivity == "weak"
      bins = conncomp(G, 'Type', 'weak');
      is_connected_graph = all(bins == 1);
    elseif opt.connectivity == "dontcare"
      % do nothing
    else
      error("Invalid connectivity type provided.")
    end
    
    % increase the counter
    cnt = cnt + 1;
  end
  
  if cnt == opt.max_graph_iter
    error("could not converge for %d iterations", opt.max_graph_iter);
  end
  
  fprintf("\t$$ Graph gen took %d iterations - connection type: %s\n", ...
    cnt, opt.connectivity);

  % compute its distance
  distance = max(max(distances(G)));
  
  % check if we show the graph
  if opt.show_graph == 1
    figure;
    plot(G);
    title(sprintf("Graph with %d nodes", nodes));
  end

end

