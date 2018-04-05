function stats = run_all_models_HHGF(stats, subject_type, P)
% Double HGF on response models

resp_models = {
    'tapas_softmax_binary';
    'tapas_softmax_binary_invsig2';
    'rescorla_wagner'};

  
for r = 1:length(resp_models)
    resp_model = resp_models{r}
    
    %% Run perceptual variables
    num_subjects = length(stats{subject_type}.labels)
    for i = 1:num_subjects

        y = make_winning_response_variable(subject_type, i,stats);
        subjects(i,1).y = y{:};
        
        u = make_winning_perceptual_variable(subject_type,i, stats,P);
        subjects(i,1).u = u{:}(1:length(subjects(i,1).y));
        
        subjects(i,1).ign = [];
        subjects(i,1).irr = [];
    end

    transp_fun = [resp_model '_transp'];
    % HGF
    hhgf.c_prc.n_levels = 3;
    hhgf.c_obs.obs_fun = str2func(resp_model);
    hhgf.c_obs.transp_obs_fun = str2func(transp_fun);
    hhgf.c_prc.prc_fun = @tapas_hgf_binary;
    hhgf.c_prc.transp_prc_fun = @tapas_hgf_binary_transp;
    
    c = tapas_hgf_binary_config;
    c.priormus(isnan(c.priormus)) = 0;
    c.priorsas(isnan(c.priorsas)) = 0;
    
    hhgf.c_prc.priormus = c.priormus';
    hhgf.c_prc.priorsas = c.priorsas';
    hhgf.c_obs.priormus = 1;
    hhgf.c_obs.priorsas = 1;
    hhgf.c_obs.predorpost = 1;
    
    % For Gamma(2,2)
    hhgf.c_prc.priorsas(hhgf.c_prc.priorsas > 1.0) = 1;
    hhgf.scale = 0.5;
    
    hhgf.ign = [];
    hhgf.irr = [];
    
    inference = struct();
    pars = struct();
    pars.seed = 1;
    pars.ndiag = 200;
    pars.niter = 9000;
    pars.nburnin = 2000;
    pars.T = ones(num_subjects, 1) * linspace(0.01, 1, 2).^5;
    pars.mc3it = 4;
    
    % Rescorla-Wagner
    c_rw = tapas_rw_binary_config;

    rw.c_prc.n_levels = 3;
    rw.c_obs.obs_fun = str2func(resp_models{1});
    rw.c_obs.transp_obs_fun = str2func(transp_fun);
    rw.c_prc.prc_fun = @tapas_rw_binary;
    rw.c_prc.transp_prc_fun = @tapas_rw_binary_transp;
    rw.c_obs.predorpost = 1;

    rw.c_prc.priormus = c_rw.priormus';
    rw.c_prc.priorsas = c_rw.priorsas';
    rw.c_prc.priorsas(1) = 0;
    rw.c_prc.priorsas(2) = 16;
    rw.c_obs.priormus = 1;
    rw.c_obs.priorsas = 1;
    rw.scale = 0.5;
    
    rw.ign = [];
    rw.irr = [];
    if strcmp(resp_model,'tapas_softmax_binary') || strcmp(resp_model,'tapas_softmax_binary_invsig2')
        estimate = tapas_h2gf_estimate(subjects, hhgf, inference, pars);
        stats{subject_type}.hhgf_est{r} = estimate;
    elseif strcmp(resp_model,'rescorla_wagner')
        estimate = tapas_h2gf_estimate(subjects, rw, inference, pars);
        stats{subject_type}.rw_est = estimate;
    end 
    fprintf(1, '%s - Fe=%0.2f\n', resp_model, estimate.fe);
end

stats{subject_type}.response_models = resp_models;

end
