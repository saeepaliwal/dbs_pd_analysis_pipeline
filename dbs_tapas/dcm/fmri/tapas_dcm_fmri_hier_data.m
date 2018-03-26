function [data] = tapas_dcm_fmri_hier_data(dcms, pars)
%% Prepare the data structure
%
% Input
%   dcms        -- Cell array of dcm objects
%   pars        -- Structure with paramerters.
%       
% Output
%   data        -- Data object.

% aponteeduardo@gmail.com
% copyright (C) 2016
%

nt = numel(dcms);

data = struct('y', [], 'u', []);

[y, u, theta, ptheta] = tapas_mpdcm_fmri_tinput(dcms);

data.y = y;
data.u = u;


end

