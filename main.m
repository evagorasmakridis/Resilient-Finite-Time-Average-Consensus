clc; clear; close all;
access_func_directory = fileparts(pwd);
addpath(access_func_directory);

% simulation parameters
%seed = 1;
%rng(seed);
K = 50; % max iteration

% network parameters
n = 10; % number of agents
A = gen_graph(n);
n = size(A,1);
outdegrees = sum(A,1);
C = A./outdegrees;
isStronglyConnected = check_strongly_connected(digraph(A'));
plot(digraph(A'));

%% Initialization
x = [1:n]'; x_arxiv = x;
y = ones(n,1); y_arxiv = y;
z = x./y; z_arxiv = z;

attackSignal = 10;
gain = 0.0;

%% Iterations
for k = 1:K
    % Iterations
    x = C*x; x_arxiv = [x_arxiv x];
    y = C*y; y_arxiv = [y_arxiv y];
    % Ratio of values: Z=X/Y.
    z = x./y; z_arxiv=[z_arxiv z];

    %     if k > 50
    %         x(1) = attackSignal;
    %         C(:,1) = gain*C(:,1);
    %         C(1,1) = 1 - sum(C(2:n,1));
    %     end
end

[maxConsensusItr,ratio] = compute_fterc_rounds(x_arxiv,y_arxiv,C,A,K);
plot([0:K],z_arxiv,LineWidth=2)
ratio
z