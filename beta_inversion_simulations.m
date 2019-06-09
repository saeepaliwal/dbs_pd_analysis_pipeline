function beta_inversion_simulations
addpath(genpath('./tapas_saee/'));

% Set num subjects
num_subjects = 9; 

% Set perceptual variable as slot machine trace
load dbs_u
u_final = dbs_u;

params_config = tapas_hgf_binary_config_recovery;
pars_sim = params_config.priormus;
subjects = struct('y', cell(num_subjects, 1), 'u', cell(num_subjects, 1));


%%
for sim_num = 1:8
    
    th_val = -6;
    om_val = -3;
    be_vals_init = [12 12 12 8 8 8 4 4 4];

    % Feed forward with HGF
    for i = 1:num_subjects
        be_val = be_vals_init(i);            
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
    hhgf.c_prc.priorsas(end-1)=0;
    hhgf.c_prc.priorsas(end)=0;
    
    hhgf_est = tapas_h2gf_estimate(subjects, hhgf, inference, pars);
    
    sim_out.ground_truth.theta = pars_sim(end);
    sim_out.ground_truth.omega = pars_sim(end-1);
    sim_out.ground_truth.beta = be_vals_init;
    sim_out.recovered_pars = get_parameter_estimates(hhgf_est, num_subjects);

    keyboard
    save(['pars_inversion_sim_chm_beta_' sprintf('%d',sim_num')],'sim_out');

end

function [rec_pars] = get_parameter_estimates(hhgf_est, num_subjects)
% % Pull out DoubleHGF recovered parameter estimates

for iSub = 1:num_subjects

        % Collect omega (om2)
        rec_pars.omega(iSub,1) = hhgf_est.summary(iSub).p_prc.om(2);

        % Collect theta (th2)
        rec_pars.theta(iSub,1) = hhgf_est.summary(iSub).p_prc.om(3);

        % Collect beta (be)
        rec_pars.beta(iSub,1) = hhgf_est.summary(iSub).p_obs.be;

end