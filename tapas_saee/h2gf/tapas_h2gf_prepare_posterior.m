function [posterior] = tapas_h2gf_prepare_posterior(data, model, ...
    inference, states)
%% 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

T = model.graph{1}.htheta.T;

posterior = struct('data', data, 'model', model, 'inference', inference, ...
    'samples_theta', [], 'fe', [], 'llh', []);

np = numel(states);

theta = cell(np, 1); 
for i = 1:np
    theta{i} = states{i}.graph{2}(:, end);
end

% Contains all the terms related to the likelihood
cllh = cell(2, 1);

[ns, nc] = size(states{1}.llh{1});

% Log likelihood under the posteriors
llh = zeros(ns, nc, np);
for i = 1:np
    llh(:, :, i) = states{i}.llh{1};
    for j = 1:size(llh(:, :, i),2)
        if any(isinf(abs(llh(:,j,i))))
            idx = find(isinf(abs(llh(:,j,i))));
            if j > 1
                llh(idx,j,i) = llh(idx,j-1,i);
            else
                llh(idx,j,i) = 0;
            end
        end
    end
end

cllh{1} = llh;

posterior.llh = cllh;
ellh = mean(squeeze(sum(cllh{1}, 1)), 2);

if size(T, 2) > 1
    fe = trapz(T(1, :), ellh);
else
    fe = nan;
end

posterior.fe = fe;
posterior.accuracy = ellh(end);

posterior.T = T;
posterior.samples_theta = horzcat(theta{:});

hgf = model.graph{1}.htheta.hgf;

for i = 1:numel(posterior.samples_theta)
    posterior.samples_theta{i} = tapas_h2gf_unwrapp_parameters(...
        posterior.samples_theta{i}, hgf);
end

posterior.hgf = hgf;
posterior.summary = tapas_h2gf_summary(data, posterior, hgf);

end
