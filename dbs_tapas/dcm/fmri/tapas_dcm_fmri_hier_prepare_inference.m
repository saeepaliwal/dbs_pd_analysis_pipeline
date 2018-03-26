function [inference] = tapas_dcm_fmri_hier_prepare_inference(data, model, ...
    inference)
%% 
%
% Input
%       
% Output
%       

% aponteeduardo@gmail.com
% copyright (C) 2016
%

nc = numel(model.graph{2}.htheta.T);
np = size(data.u, 1);
nb = size(model.graph{4}.htheta.y.mu, 1);

inferece.kernel = cell(4, 1);

inference.kernel{2} = struct('k', [eye(nb)], 's', [0.5]);
inference.kernel{3} = struct('k', [eye(nb)], 's', [0.5]);


end

