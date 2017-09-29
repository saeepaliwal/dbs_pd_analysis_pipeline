function [kappa_all,omega_all,theta_all,beta_all,binFEgrid] = collect_model_info(subject_type,stats,PAPER)

% Response Models
% n = 1 is the bet switch 0/1 response
% n = 2 is the machine switch and bet switch response
% n = 3 is the machine switch, gamble and bet switch response
% n = 4 is the machine switch, gamble, cashout, and bet switch response

% Perceptual Models
% nn = 1 is binary, win/loss (gross)
% nn = 2 is true win/loss (net)
% nn = 3 is near misses and fake wins map to wins



if PAPER
    g = subject_type;
    binFEgrid = squeeze(stats{subject_type}.hgf.bin_FE);
    labels = stats{subject_type}.labels;
    for i = 1:length(binFEgrid)
        kappa_all(i) = stats{subject_type}.hgf.bin(:,:,i).p_prc.ka(:,2);
        theta_all(i) = stats{subject_type}.hgf.bin(:,:,i).p_prc.om(:,3);
        omega_all(i) = stats{subject_type}.hgf.bin(:,:,i).p_prc.om(:,2);
        beta_all(i) = stats{subject_type}.hgf.bin(:,:,i).p_obs.be;
    end
else
    for g = subject_type
        for n = 1:4
            for nn = 1:3
                for i = 1:length(stats{g}.labels)
                    % Pull out binary free energy information
                    binFEgrid(:,:,i) = [reshape(stats{subject_type}.hgf.bin_FE(:,:,i),1,12) stats{g}.rw_FE(1,:,i)];
                    kappa_all(n,nn,i) = stats{subject_type}.hgf.bin(n,nn,i).p_prc.ka(:,2);
                    theta_all(n,nn,i) = stats{subject_type}.hgf.bin(n,nn,i).p_prc.om(:,3);
                    omega_all(n,nn,i) = stats{subject_type}.hgf.bin(n,nn,i).p_prc.om(:,2);
                    beta_all(n,nn,i) = stats{subject_type}.hgf.bin(n,nn,i).p_obs.be;
                end
            end
            
        end
    end
    
end