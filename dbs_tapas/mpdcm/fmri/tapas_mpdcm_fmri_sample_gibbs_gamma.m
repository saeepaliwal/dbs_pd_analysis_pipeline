function [otheta, ny, ollh, olpp] = tapas_mpdcm_fmri_sample_gibbs_gamma(...
    y, u, otheta, ptheta, pars, ny, ollh, olpp)
%% Makes a Gibbs step of a set of the parameters.
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

T = pars.T;
nt = numel(T);

% Perfom a gibb step on the residuals
[ntheta, oq, nq] = draw_samples(y, u, otheta, ptheta, ny, pars);
nllh = pars.fllh(y, u, ntheta, ptheta, ny);
nllh = sum(nllh, 1);
nlpp = sum(pars.flpp(y, u, ntheta, ptheta), 1);

% Make an extra MH step to adjust
% Because of the conjugacy one could obviate the likelihood term but anyways
% one has probably to compute it.
%v = (nllh .* T + nlpp + oq) - (ollh .* T + olpp + nq);
v = (nlpp + oq) - (olpp + nq);

v = v > log(rand(1, nt));

%fprintf(1, '%d', v);
%fprintf(1, '\n');

otheta(v) = ntheta(v);
ollh(v) = nllh(v);
olpp(v) = nlpp(v);

assert(all(-inf < ollh), 'mpdcm:fmri:ps', ...
    'gibbs -inf value in the likelihood');

end % 

function [theta, oq, nq] = draw_samples(y, u, theta, ptheta, ny, pars)
%% Draw a sample for lthe distribution

nt = numel(theta);
nr = size(y{1}, 1);
nd = size(y{1}, 2);
nb = size(ptheta.X0, 2);

y = y{1}';

oq = zeros(1, nt);
nq = zeros(1, nt);

% Adjust the priors to mimic the log normal prior
%a0 = 0.5816;
%b0 = 0.35;
a0 = 0.01;
b0 = 0.616;
%a0 = 1;
%b0 = 2;

for i = 1:nt
    % Assume no correlations between regions i.e., treat the problem as 
    % massive multivariate problem

    if any(isnan(ny{i}(:))) || any(isinf(ny{i}(:)))
        continue
    end
    % Fit only the residual
    if numel(ptheta.X0)
        r = y - (ny{i} + ptheta.X0 * theta{i}.beta);
    else 
        r = y - ny{i};
    end
    
    r2 = sum(r.^2, 1)' * pars.T(i);
    ta = a0 + 0.5 * nd * ones(nr, 1) * pars.T(i);
    tb = b0 + 0.5 * r2;

    % Because we are sampling from the exponential space (and not the log
    % space, adjust by -log(lambda) by deleting one degree of freedom
    oq(i) = sum((a0 - 1) .* theta{i}.lambda - exp(theta{i}.lambda) .* b0);
    theta{i}.lambda = log(gamrnd(ta + 1, 1./tb));
    nq(i) = sum((a0 - 1) .* theta{i}.lambda - exp(theta{i}.lambda) .* b0);
     
end

end
