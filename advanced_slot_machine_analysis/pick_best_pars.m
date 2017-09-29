efunction winningmodel = pick_best_pars(results_dir, subject_type, PAPER)

if ~PAPER
    load([results_dir '/bms_results_' sprintf('%d', subject_type)]);
    load([results_dir '/parameter_workspace.mat']);
    
    win_idx = find(allBMS{1} == max(allBMS{1}));
    
    switch win_idx
        case 1
            winningmodel = 'HGF Constant Beta, Perc var: win/loss (gross), Resp var: AllSwitch';
        case 2
            winningmodel = 'HGF  with beta = 1/sigma2, Perc var: win/loss (gross), Resp var: AllSwitch';
        case 3
            winningmodel = 'HGF with beta = 1/exp(mu3), Perc var: win/loss (gross), Resp var: AllSwitch';
        case 4
            winningmodel = 'HGF with x = sigma1, beta = constant, Perc var: win/loss (gross), Resp var: AllSwitch';
        case 5
            winningmodel = 'HGF Constant Beta, Perc var: win/loss net, Resp var: AllSwitch';
        case 6
            winningmodel = 'HGF  with beta = 1/sigma2, Perc var: win/loss (net), Resp var: AllSwitch';
        case 7
            winningmodel = 'HGF with beta = 1/exp(mu3), Perc var: win/loss (net), Resp var: AllSwitch';
        case 8
            winningmodel = 'HGF with x = sigma1, beta = constant, Perc var: win/loss (net), Resp var: AllSwitch';
        case 9
            winningmodel = 'HGF Constant Beta, Perc var: near miss, Resp var: AllSwitch';
        case 10
            winningmodel = 'HGF  with beta = 1/sigma2, Perc var: near miss, Resp var: AllSwitch';
        case 11
            winningmodel = 'HGF with beta = 1/exp(mu3), Perc var: near miss, Resp var: AllSwitch';
        case 12
            winningmodel = 'HGF with x = sigma1, beta = constant, Perc var: near miss, Resp var: AllSwitch';
        case 13
            winningmodel = 'RW with Perc var: win/loss (gross), Resp var: AllSwitch';
        case 14
            winningmodel = 'RW with Perc var: win/loss (net), Resp var: AllSwitch';
        case 15
            winningmodel = 'RW with Perc var: near miss, Resp var: AllSwitch';
    end
    
    binFEgrid = pars.FE;
    omega_all = squeeze(reshape(pars.omega,1,12,size(pars.omega,3)));
    theta_all = squeeze(reshape(pars.theta,1,12,size(pars.theta,3)));
    beta_all =  squeeze(reshape(pars.beta_all,1,12,size(pars.beta_all,3)));
    
    omega = omega_all(win_idx,:);
    theta = theta_all(win_idx,:);
    bbeta = beta_all(win_idx,:);
    save ([results_dir 'parameter_workspace'],'omega_all','theta_all','beta_all','binFEgrid','omega','theta','bbeta','pars');
    
else
    load([results_dir '/parameter_workspace.mat']);
    winningmodel = 'HGF  with beta = 1/sigma2, Perc var: win/loss (net), Resp var: AllSwitch';
    binFEgrid = pars.FE;
    omega = pars.omega;
    theta = pars.theta;
    save ([results_dir 'parameter_workspace'],'binFEgrid','omega','theta','pars');
end
    


