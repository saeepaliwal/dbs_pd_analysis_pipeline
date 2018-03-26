function [pars] = tapas_dcm_fmri_hier_pars(dcms, pars)
%% 
%
% Input
%       
% Output
%       

if ~isfield(pars, 'T')
    pars.T = linspace(0.1, 1, 16) .^ 5;
end

if ~isfield(pars, 'seed')
    pars.seed = 0;
end

if pars.seed > 0
    rng(pars.seed);
else
    rng('shuffle');
end


% aponteeduardo@gmail.com
% copyright (C) 2016
%

end

