function parameter_inversion_simulations(invert_omega, invert_theta, invert_beta)
% Simulation replicating Figure 7, Mathys 2014, for the doubleHGF
addpath(genpath('./tapas_saee/'));
%addpath(genpath('./dbs_tapas'))
% Number of subjects/iterations

% % Set inversion
% invert_omega = 1;
% invert_theta = 0;
% invert_beta = 0;

% Set num subjects
num_subjects = 38; 

% Set perceptual variable as slot machine trace
load dbs_u
u_final = dbs_u;
%u_final = repmat(dbs_u, 1, 1);
%u_final = randi([0 1],400,1);

load params_config
pars_sim = params_config.priormus;
subjects = struct('y', cell(num_subjects, 1), 'u', cell(num_subjects, 1));


%%
for sim_num = 1:30

    %theta_vals_init = -7:0.3:-1;
    theta_vals_init = normrnd(-7, 2, num_subjects,1);
    omega_vals_init = normrnd(-6, 2,num_subjects,1);
    beta_vals_init = normrnd(8, 2, num_subjects,1);  
    
    th_val = -7;
    om_val = -6;
    be_val = 8;

    % Feed forward with HGF
    for i = 1:num_subjects
       % th_val = theta_vals_init(i);
        if invert_omega
            om_val = omega_vals_init(i);
        elseif invert_theta
            th_val = theta_vals_init(i);
        elseif invert_beta
            be_val = beta_vals_init(i);
        end
        
        pars_sim(end-1) = om_val;
        pars_sim(end) = th_val;
        
        sim = tapas_simModel(u_final, 'tapas_hgf_binary', pars_sim,...
            'tapas_unitsq_sgm',be_val);
        subjects(i).y = sim.y;
        subjects(i).u = dbs_u;
        subjects(i,1).ign = [];
        subjects(i,1).irr = [];  
    end

    %% Construct model object
    num_chains = 1;
      
    [hhgf, rw, pars, inference] = get_hhgf_settings('tapas_softmax_binary', num_chains);

%     if invert_omega
%         hhgf.c_prc.priorsas(end)=0;
%         hhgf.c_obs.priorsas = 0;
%     elseif invert_theta
%         hhgf.c_prc.priorsas(end-1)=0;
%         hhgf.c_obs.priorsas = 0;
%     elseif invert_beta
%         hhgf.c_prc.priorsas(end)=0;
%         hhgf.c_prc.priorsas(end-1)=0;
%     end

    hhgf_est = tapas_h2gf_estimate(subjects, hhgf, inference, pars);
    
    sim_out.ground_truth.theta = theta_vals_init;
    sim_out.ground_truth.omega = omega_vals_init;
    sim_out.ground_truth.beta = beta_vals_init;
    sim_out.th_fixed = -7;
    sim_out.om_fixed = -6;
    sim_out.be_fixed = 8;
    sim_out.recovered_pars = get_parameter_estimates(hhgf_est, num_subjects);
    [R] = check_convergence_inv_sim(hhgf_est, 2);
    sim_out.R = R;

%     assert(convergence_test==1, 'Chains have not converged!');
    if invert_omega
        save(['pars_inversion_sim_chm_omega_' sprintf('%d',sim_num')],'sim_out');
    elseif invert_theta
        save(['pars_inversion_sim_chm_theta_' sprintf('%d',sim_num')],'sim_out');
    elseif invert_beta
        save(['pars_inversion_sim_chm_beta_' sprintf('%d',sim_num')],'sim_out');
    end

end

function [rec_pars] = get_parameter_estimates(hhgf_est, num_subjects)
% % Pull out DoubleHGF recovered parameter estimates
% 
% for m = 1:length(hh.data)
%     clear pars_distro llh
%     for i = 1:size(hh.samples_theta,2)
%     %for i = 1:length(hh.samples_theta)
%         %pars_distro(i,:) = hh.samples_theta{i}{m}
%         pars_distro(i,1) = hh.samples_theta{m,i}(13);
%         pars_distro(i,2) = hh.samples_theta{m,i}(14);
%         pars_distro(i,3) = hh.samples_theta{m,i}(15);
%         pars_distro_all(m,:,i) = pars_distro(i,:);
%     end
% 
%     % Get omega
%     rec_pars.pars_distro = pars_distro_all;
%     rec_pars.omega_mean(m,1) = mean(pars_distro(:,1));
%     rec_pars.omega_median(m,1) = median(pars_distro(:,1));
% 
%     
%     % Get theta
%     rec_pars.theta_median(m,1) = median(pars_distro(:,2));
%     rec_pars.theta_mean(m,1) = mean(pars_distro(:,2));
% 
%     
%     rec_pars.beta_median(m,1) = median(pars_distro(:,3));
%     rec_pars.beta_mean(m,1) = mean(pars_distro(:,3));
%  
% end



for iSub = 1:num_subjects

        % Collect omega (om2)
        rec_pars.omega(iSub,1) = hhgf_est.summary(iSub).p_prc.om(2);

        % Collect theta (th2)
        rec_pars.theta(iSub,1) = hhgf_est.summary(iSub).p_prc.om(3);

        % Collect beta (be)
        rec_pars.beta(iSub,1) = hhgf_est.summary(iSub).p_obs.be;

end