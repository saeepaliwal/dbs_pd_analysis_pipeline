function stats = run_hhgf(subject_type, resp_models, stats,P)

for r = 1:length(resp_models)
    resp_model = resp_models{r};
    
    %% Run perceptual variables
    num_subjects = length(stats{subject_type}.labels)
    for i = 1:num_subjects
        u = make_winning_perceptual_variable(subject_type,i, stats,P);
        subjects(i,1).u = u{:};
        y = make_winning_response_variable(subject_type, i,stats);
        subjects(i,1).y = y{:};
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
    
    pars.ndiag = 1000;
    pars.niter = 4000;
    pars.nburndin = 4000;
    pars.T = ones(num_subjects, 1) * linspace(0.01, 1, 32).^5;
    pars.mc3it = 4;
    
    % Rescorla-Wagner
    rw.c_prc.n_levels = 3;
    rw.c_obs.obs_fun = str2func(resp_model);
    rw.c_obs.transp_obs_fun = str2func(transp_fun);
    rw.c_prc.prc_fun = @tapas_rw_binary;
    rw.c_prc.transp_prc_fun = @tapas_rw_binary_transp;
    rw.c_obs.predorpost = 1;
    
    rw.c_prc.priormus = c.priormus';
    rw.c_prc.priorsas = c.priorsas';
    rw.c_obs.priormus = 1;
    rw.c_obs.priorsas = 0;
    
    % For Gamma(2,2)
    rw.c_prc.priorsas(hhgf.c_prc.priorsas > 1.0) = 1;
    rw.scale = 0.5;
    
    rw.ign = [];
    rw.irr = [];
    
    stats{subject_type}.hhgf_est{run_num} = tapas_h2gf_estimate(subjects, hhgf, inference, pars);
    if r == 2
        stats{subject_type}.rw_est = tapas_h2gf_estimate(subjects, rw, inference, pars);
    end
    
end