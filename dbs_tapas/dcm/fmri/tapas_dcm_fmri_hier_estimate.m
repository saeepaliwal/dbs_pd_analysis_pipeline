function [posterior] = tapas_dcm_fmri_hier_estimate(dcms, model, ...
    inference, pars)
%% Estimate a set of dcms defined in DCM using a very simple hierarchical
% prior.
%
% Input
%   dcms        -- Cell array of dcms.
%   model       -- Structure with a model, possibly empty
%   inference   -- Structure with an inference object, possiby empty.
%   pars        -- Parameters of the inference, possibly empty
%       
% Output
%   posterior   -- A structure return the posterior of the model.
% 
% The model, inference and pars structure are assigned default values by the
% the functions:
%
%   tapas_dcm_hier_model
%   tapas_dcm_hier_inference
%   tapas_dcm_hier_pars.
%
% If a field is not provided a default value would be assigned.
%

% aponteeduardo@gmail.com
% copyright (C) 2016
%

n = 2;
if nargin < n
    model = struct();
end

n = n + 1;
if nargin < n
    inference = struct();
end

n = n + 1;
if nargin < n
    pars = struct();
end

[pars] = tapas_dcm_fmri_hier_pars(dcms, pars);
[data] = tapas_dcm_fmri_hier_data(dcms, pars);
[model] = tapas_dcm_fmri_hier_model(dcms, model, pars);
[inference] = tapas_dcm_fmri_hier_inference(dcms, inference, pars);

[posterior] = tapas_dcm_fmri_hier_estimate_interface(data, model, inference);

end

