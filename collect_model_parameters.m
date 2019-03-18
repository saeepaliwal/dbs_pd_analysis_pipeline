function stats = collect_model_parameters(stats, type)

for iSub = 1:2

    if strcmp(type,'mean')
        [FE_HH, FE_RW, llh_all, kappa_all, omega_all, theta_all, beta_all] = ...
            collect_mean_parameters(iSub, stats);
    elseif strcmp(type,'median')
        [FE_HH, FE_RW, llh_all, kappa_all, omega_all, theta_all, beta_all] = ...
            collect_median_parameters(iSub, stats);
    end

    stats{iSub}.FE_grid = [FE_HH FE_RW];
    stats{iSub}.llh = llh_all;
    stats{iSub}.kappa_all = kappa_all;
    stats{iSub}.omega_all = omega_all;
    stats{iSub}.theta_all = theta_all;
    stats{iSub}.beta_all = beta_all;
end

pars_of_interest = {'omega';'theta';'beta'};
for  iSub = 1:2
    idx = 1; % winning model from pre-DBS timepoint
    stats{iSub}.winning_model = idx;

    for p = 1:length(pars_of_interest)
        param = pars_of_interest{p};
        param_all = [param '_all'];
        stats{iSub}.(param) = stats{iSub}.(param_all)(:,idx);
    end
end