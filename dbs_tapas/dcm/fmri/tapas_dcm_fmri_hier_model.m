function [model] = tapas_dcm_fmri_hier_model(dcms, model, pars)
%% Generate the definition of the model. 
%
% Input
%       
% Output
%       

% aponteeduardo@gmail.com
% copyright (C) 2016
%

model = struct('graph', []);
model.graph = cell(4, 1);

for i = 1:4
    model.graph{i} = struct('llh', [], 'htheta', []);
end

model.graph{1}.llh = @tapas_dcm_fmri_llh;
model.graph{2}.llh = @tapas_vlinear_hier_llh;
model.graph{3}.llh = @tapas_vlinear_llh;
model.graph{4}.llh = [];

[~, ~, theta0, ptheta] = tapas_mpdcm_fmri_tinput(dcms);

if ~isfield(ptheta, 'integ')
    ptheta.integ = 'rk4';
end

% Replicate the structure for fetching the parameters.
theta0 = repmat(theta0, 1, numel(pars.T));

ptheta.theta0 = theta0;
ptheta.T = pars.T;

model.graph{1}.htheta = ptheta;
model.graph{2}.htheta = struct('T', ones(size(pars.T)));
model.graph{3}.htheta = struct('T', ones(size(pars.T)));

% The last level is a dummy used to store the hyperpriors.
model.graph{4}.htheta = struct('y', [], 'u', []);

end

