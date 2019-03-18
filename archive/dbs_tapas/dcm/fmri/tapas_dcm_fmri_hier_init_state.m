function [state] = tapas_dcm_fmri_hier_init_state(data, model, inference)
%% 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

nc = numel(model.graph{1}.htheta.T);
np = size(data.u, 1);
nb = size(model.graph{4}.htheta.y.mu, 1);

state = struct('graph', [], 'llh', [], 'kernel', []);

state.graph = cell(4, 1);
state.llh = cell(4, 1);
state.kernel = cell(4, 1);

state.graph{1} = data;

state.graph{2} = struct('y', [], 'u', []);
state.graph{2}.y = tapas_mpdcm_fmri_get_parameters(...
    model.graph{1}.htheta.theta0, model.graph{1}.htheta);

state.graph{3} = struct('y', [], 'u', []);
state.graph{3}.y = cell(1, nc);
node = struct('mu', [], 'pe', 1);
node.mu = model.graph{4}.htheta.y.mu;
state.graph{3}.y(:) = {node};

% Use the hyperpriors as state
state.graph{4} = struct('y', [], 'u', []);
state.graph{4}.y = cell(1, nc);
state.graph{4}.u = cell(1, nc);
state.graph{4}.y(:) = {model.graph{4}.htheta.y};
state.graph{4}.u(:) = {model.graph{4}.htheta.u};

state.llh{1} = -inf * ones(np, nc);
state.llh{2} = -inf * ones(np, nc);
state.llh{3} = -inf * ones(1, nc);

state.kernel{2} = cell(np, nc);
state.kernel{2}(:) = inference.kernel(2);
state.kernel{3} = [];

state.nsample = 0;
state.v = zeros(np, nc);


end

