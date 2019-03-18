function [stats] = remove_hgf_fields(stats)
%% 
%
% Input
%
% Output
%

% aponteeduardo@gmail.com
% copyright (C) 2018
%

field = {'omega_all', 'theta_all', 'beta_all', 'bms_results', ...
    'winning_model', 'omega', 'theta', 'beta', 'rw_est', 'hhgf_est', ...
    'response_models', 'FE_grid', 'llh'};

for i = 1:numel(field)
    stats = rmfield(stats, field{i});
end

end
