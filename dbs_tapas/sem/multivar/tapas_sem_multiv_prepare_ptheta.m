function [ptheta] = tapas_sem_multiv_prepare_ptheta(ptheta, theta, pars)
%% Thin layer of preparations for the hierarchical model. 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Number of parameter data sets.
npars = ptheta.npars;

% Rename
ptheta.name = sprintf('multiv_%s', ptheta.name);

% Simplify the preparations
ptheta.njm = tapas_zeromat(ptheta.jm);

% Duplicate the parameters
ptheta.mu = kron(ones(npars, 1), ptheta.mu);
ptheta.pm = kron(ones(npars, 1), ptheta.pm);
ptheta.p0 = kron(ones(npars, 1), ptheta.p0);

% Precompute some of the linear elements.
<<<<<<< HEAD
ptheta.omega = ptheta.x' * ptheta.x + eye(size(ptheta.x, 2));
=======
xx = ptheta.x' * ptheta.x;
if rank(xx) < size(xx, 1)
    warning('The design matrix is singular.');
end
ptheta.omega = xx + eye(size(ptheta.x, 2));
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
ptheta.iomega = inv(ptheta.omega);
ptheta.comega = chol(ptheta.omega);
ptheta.ciomega = chol(ptheta.iomega);

end

