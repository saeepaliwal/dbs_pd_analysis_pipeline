function [theta, ny, nllh, nlpp] = tapas_mpdcm_fmri_sample_gibbs(y, u, ...
    theta, ptheta, pars, ny, nllh, nlpp)
%% Makes a Gibbs step of a set of the parameters.
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Perfom a gibb step

if numel(ptheta.X0) 
    theta = draw_samples(y, u, theta, ptheta, ny, pars);
    nllh = pars.fllh(y, u, theta, ptheta, ny);
    nllh = sum(nllh, 1);
    nlpp = sum(pars.flpp(y, u, theta, ptheta), 1);

    assert(all(-inf < nllh), 'mpdcm:fmri:ps', ...
        'gibbs -inf value in the likelihood');
end

end % 

function [theta] = draw_samples(y, u, theta, ptheta, ny, pars)
%% Draw a sample for lthe distribution

nt = numel(theta);
nr = size(y{1}, 1);
nb = size(ptheta.X0, 2);

I = eye(nb);
y = y{1};

for i = 1:nt
    % Assume no correlations between regions i.e., treat the problem as massive
    % multivariate problem

    if any(isnan(ny{i}(:))) || any(isinf(ny{i}(:)))
        continue
    end
    % Fit only the residual
    r = y' - ny{i};
    %beta = ptheta.omega * (y' - ny{i});
    lambda = exp(theta{i}.lambda) * pars.T(i);
    for j = 1:nr
        beta = ...
            (ptheta.X0X0 * lambda(j) + I)\(lambda(j) * ptheta.X0' * r(:, j));
        theta{i}.beta(:, j) = beta + ...
            chol(ptheta.X0X0 * lambda(j) + I)'\randn(nb, 1);
    end
end

end %

