function check_convergence(stats, subject_type,model)
% function converged = check_convergence(stats, subject_type,model)
% IN: 
%     subject_type: 1 for PRE-DBS, 2 for POST-DBS
%     model: 1 for HGF, 2 for RW
%% Check for convergence
posterior = stats{subject_type}.hhgf_est{model};
groups = 4;
for s = 1:length(posterior.data)
    A = [];
    N = size(posterior.samples_theta,2);
    for i = 1:N
        A(1,:,i) = posterior.samples_theta{s,i}([end-2 end]);
    end
    
    [ R(s,:) ] = mcmcgr(A,groups);
end

parameters = {'omega';'theta';'beta'};
R
if any(any(R>1.1)==1)
    p = parameters{find(any(R>1.1))};
    fprintf('\n%s %d %s\n','WARNING: Model', model, 'has not converged for all parameters across subjects.');
    fprintf('%s %s %s\n\n','Parameter', p, 'has a GR value of >1.1.');
else
    fprintf('%s %d %s\n\n','Model', model, 'has converged for all paramteres across subjects!');
end
    
    