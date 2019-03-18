function  stats = collect_median_parameters(stats)

% Pull out DoubleHGF parameter estimates
for iSubType = 1:length(stats)
    num_models = length(stats{iSubType}.hhgf_est);
    for iModel = 1:num_models
        for iSub = 1:length(stats{iSubType}.labels)
            
            % Collect omega (om2)
            stats{iSubType}.omega_all(iSub,iModel) = ...
                stats{iSubType}.hhgf_est{iModel}.summary(iSub).p_prc.om(2);
            
            % Collect theta (th2)
            stats{iSubType}.theta_all(iSub,iModel) = ...
                stats{iSubType}.hhgf_est{iModel}.summary(iSub).p_prc.om(3);
            
            % Collect beta (be)
            stats{iSubType}.beta_all(iSub,iModel) = ...
                stats{iSubType}.hhgf_est{iModel}.summary(iSub).p_obs.be;
            
            % Pull out free energy here
            stats{iSubType}.FE(1,iModel) = stats{iSubType}.hhgf_est{iModel}.fe;
        end
    end
    % Pull out RW FE if RW was run
    if isfield(stats{iSubType},'rw_est')
        stats{iSubType}.FE(1,end+1) = stats{subject_type}.rw_est.fe;
    end

end

