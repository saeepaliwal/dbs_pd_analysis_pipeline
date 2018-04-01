function stats = collect_model_info(subject_type, stats, PAPER)


fields = {
    'binFEgrid';
    'kappa_all';
    'theta_all';
    'omega_all';
    'beta_all'};

for f = 1:length(fields)
    if isfield(stats{subject_type},fields{f})
        stats{subject_type} = rmfield(stats{subject_type},fields{f});
    end
end

if PAPER
    binFEgrid = squeeze(stats{subject_type}.hgf.bin_FE);
    labels = stats{subject_type}.labels;

    for i = 1:length(binFEgrid)
        stats{subject_type}.kappa_all(i) = ...
            stats{subject_type}.hgf.bin(:,:,i).p_prc.ka(:,2);
        stats{subject_type}.theta_all(i) = ...
            stats{subject_type}.hgf.bin(:,:,i).p_prc.om(:,3);
        stats{subject_type}.omega_all(i) = ...
            stats{subject_type}.hgf.bin(:,:,i).p_prc.om(:,2);
        stats{subject_type}.beta_all(i) = ...
            stats{subject_type}.hgf.bin(:,:,i).p_obs.be;
    end
else
    for n = 1:length(stats{subject_type}.response_models)
        for nn = 1:3
            for i = 1:length(stats{subject_type}.labels)
                % Pull out binary free energy information
                stats{subject_type}.binFEgrid(:,:,i) = ...
                    [reshape(stats{subject_type}.hgf.bin_FE(:,:,i)',1,12)...
                        stats{subject_type}.rw_FE(1,:,i)];
                stats{subject_type}.kappa_all(n,nn,i) = ...
                    stats{subject_type}.hgf.bin(n,nn,i).p_prc.ka(:,2);
                stats{subject_type}.theta_all(n,nn,i) = ...
                    stats{subject_type}.hgf.bin(n,nn,i).p_prc.om(:,3);
                stats{subject_type}.omega_all(n,nn,i) = ...
                    stats{subject_type}.hgf.bin(n,nn,i).p_prc.om(:,2);
                stats{subject_type}.beta_all(n,nn,i) = ...
                    stats{subject_type}.hgf.bin(n,nn,i).p_obs.be;
            end
        end
        
    end    
end
