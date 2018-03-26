function [ptheta] = tapas_h2gf_prepare_ptheta(ptheta, theta, pars)
%% 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

n = 1;

n = n + 1;
if nargin < n
    theta  = [];
end

n = n + 1;
if nargin < n
    pars = [];
end


i = 1;
n = numel(ptheta.c_prc.priormus);

ptheta.theta_prc = i : n + i -1;
ptheta.theta_prc_nd = n;

i = i + n;
n = numel(ptheta.c_obs.priormus);

ptheta.theta_obs = i : i + n - 1;
ptheta.theta_obs_nd = n;

ptheta.mu = [ptheta.c_prc.priormus; ptheta.c_obs.priormus];
ptheta.pe = 1./[ptheta.c_prc.priorsas; ptheta.c_obs.priorsas];

ptheta.p0 = ptheta.mu;

prc_idx = ptheta.c_prc.priorsas;
prc_idx(isnan(prc_idx)) = 0;
prc_idx = find(prc_idx);

obs_idx = ptheta.c_obs.priorsas;
obs_idx(isnan(obs_idx)) = 0;
obs_idx = find(obs_idx);

valid = [prc_idx; numel(ptheta.c_prc.priorsas) + obs_idx];

ptheta.jm = zeros(size(ptheta.mu, 1), size(valid, 1));

for i = 1:numel(valid)
    ptheta.jm(valid(i), i) = 1;
end

ptheta.jm = sparse(ptheta.jm);
ptheta.p0 = ptheta.p0 - (ptheta.jm * ptheta.jm') * ptheta.p0;
ptheta.mu = ptheta.jm' * ptheta.mu;
ptheta.pe = ptheta.jm' * ptheta.pe; 

end

