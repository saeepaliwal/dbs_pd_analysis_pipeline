function [R] = check_convergence_inv_sim(posterior, groups)

for s = 1:length(posterior.data)
    A = [];
    N = size(posterior.samples_theta,2);
    for i = 1:N
        A(1,:,i) = posterior.samples_theta{s,i}([end-2:end]);
    end
    
    [ R(s,:) ] = mcmcgr(A,groups);
end

% parameters = {'omega';'theta';'beta'};
% 
% if any(any(R>1.1)==1)
%     p = parameters{find(any(R>1.1))};
%     fprintf('\n%s %d %s\n','WARNING: Model has not converged for all parameters across subjects.');
%     fprintf('%s %s %s\n\n','Parameter', p, 'has a GR value of >1.1.');
% else
%     fprintf('%s %d %s\n\n','Model has converged for all paramteres across subjects!');
% end
%     