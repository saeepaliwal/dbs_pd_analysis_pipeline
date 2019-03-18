function [state] = tapas_mcmc_meta_adaptive(data, model, inference, state, ...
    states, si)
%% 
%
% Input
%       
% Output
%       

% aponteeduardo@gmail.com
% copyright (C) 2016
%


if state.nsample > inference.nburnin || mod(si, inference.ndiag)
    return;
end

t = floor(state.nsample / inference.ndiag);
t = 2;
node = 2;
c0 = 1.0;
c1 = 0.8;

% Optimal log rejection rate
ropt = 0.234;

gammaS = t^-c1;
gammas = c0*gammaS;

ns = inference.ndiag;
[np, nc] = size(state.kernel{node});
nt = size(state.kernel{node}{1}.k, 1);

ok = state.kernel{node};
nk = state.kernel{node};

if isfield(state.kernel{node}{1}, 'nuk')
    nup = state.kernel{node}{1}.nuk;
else
    nup = eye(size(ok{1}.k, 1));
end

samples = zeros(nt, ns - 1);

v = states{si}.v;
for j = 1 : ns
    v = v + states{si - inference.ndiag + j}.v;
end
ar = v/inference.ndiag;

for i = 1:numel(ok)
    % From Cholesky form to covariance form
    ok{i}.k = ok{i}.k' * ok{i}.k;
    % Empirical variance
    for j = 1:ns
        samples(:, j) = states{si - j + 1}.graph{node}{i};
    end
    ts = bsxfun(@minus, samples, mean(samples, 2));
    ek = (ts * ts') ./ (ns - 1);
    % Set new kernel
    tk = ok{i}.k + gammaS * nup * ( ek - ok{i}.k ) * nup;
    % Compute the Cholesky decomposition 
    try
        nk{i}.k = chol(tk);
    catch
        warning('Cholesky decomposition failed.')
        nk{i}.s = ok{i}.s / 2;
        continue
    end
    % Set new scaling
    nk{i}.s = exp(log(ok{i}.s) + gammas * (ar(i) - ropt));
end

state.kernel{node} = nk;

end

