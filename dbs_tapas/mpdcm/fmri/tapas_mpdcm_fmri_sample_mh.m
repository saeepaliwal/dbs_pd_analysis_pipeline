function [otheta, oy, ollh, olpp, v] = tapas_mpdcm_fmri_sample_mh(op, ...
    ptheta, htheta, pars, oy, ollh, olpp)
%% Draws a new sample from a Gaussian proposal distribution.
%
% Input
%   op -- Old parameters
%   ptheta -- Prior
%   htheta -- Hyperpriors
%   v -- Kernel. Two fields: s which is a scaling factor and S which is the     
%       Cholosvky decomposition of the kernel.
%
% Ouput
%   np -- New output 
%

% aponteeduardo@gmail.com
%
% Author: Eduardo Aponte, TNU, UZH & ETHZ - 2015
% Copyright 2015 by Eduardo Aponte <aponteeduardo@gmail.com>
%
% Licensed under GNU General Public License 3.0 or later.
% Some rights reserved. See COPYING, AUTHORS.
%
% Revision log:
%
%

if nargin < 4
    s = cell(numel(op, 1));
    s{:} = 1;
    S = cell(numel(op, 1));
    S{:} = eye(sum(ptheta.mhp));
    v = struct('S', S, 's', s);
end

nt = numel(op);
np = cell(size(op));
mhp = ptheta.mhp;
nh = sum(mhp);

for i = 1:nt
    np{i} = op{i};
    np{i}(mhp) = full(op{i}(mhp) + (v(i).s * v(i).S' * randn(nh, 1)));
end

ntheta = tapas_mpdcm_fmri_set_parameters(np, otheta, ptheta); 

% Make a prediction
ny = tapas_mpdcm_fmri_predict(y, u, ntheta, ptheta, 1);

% Compute the likelihood
nllh = pars.fllh(y, u, ntheta, ptheta, ny);

nllh = sum(nllh, 1);
nlpp = sum(pars.flpp(y, u, ntheta, ptheta), 1);

nllh(isnan(nllh)) = -inf;

v = nllh.*T + nlpp - (ollh.*T + olpp);
v = rand(size(v)) < exp(v);

ollh(v) = nllh(v);
olpp(v) = nlpp(v);
op(:, v) = np(:, v);
oy(:, v) = ny(:, v);

assert(all(-inf < ollh), 'mpdcm:fmri:ps', '-inf value in the likelihood');

end
