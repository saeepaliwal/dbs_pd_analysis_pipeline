function [model] =  tapas_dcm_fmri_hier_prepare_model(data, model, ...
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

model = tapas_vlinear_prepare_model(data, model, inference);
model.graph{4}.htheta.y.mu = model.graph{1}.htheta.p.theta.mu;

end

