function [posterior] = tapas_dcm_hier_estimate_interface(data, model, ...
    inference)
%%  Interface to the estimation method.
%
% Input
%       
% Output
%       

% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Verify input 
tapas_validate_data(data);
tapas_validate_model(model);
tapas_validate_inference(inference);

[data] = tapas_dcm_fmri_hier_prepare_data(data, model, inference);
[model] = tapas_dcm_fmri_hier_prepare_model(data, model, inference);
[inference] = tapas_dcm_fmri_hier_prepare_inference(data, model, inference);

[posterior] = inference.estimate_method(data, model, inference);

end
