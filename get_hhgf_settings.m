function [hgf, rw, pars, inference] = get_hhgf_settings(resp_model, num_chains)
% Set number of chains
nchains = num_chains;


% Construct transpose function from response model
transp_fun = [resp_model '_transp'];

%% Construct HHGF object for HGF models
hgf = struct('c_prc', [], 'c_obs', []);

% Perceptual model
hgf.c_prc.prc_fun = @tapas_hgf_binary;
hgf.c_prc.transp_prc_fun = @tapas_hgf_binary_transp;

% Response model
hgf.c_obs.obs_fun =  str2func(resp_model);
hgf.c_obs.transp_obs_fun = str2func(transp_fun);

% Initialize perceptual priors
config = tapas_hgf_binary_config();
hgf.c_prc.priormus = config.priormus;
hgf.c_prc.priorsas = config.priorsas;
hgf.c_prc.n_levels = config.n_levels;

% Set response model priors
hgf.c_obs.priormus = 8;
hgf.c_obs.priorsas = 1;

hgf.c_obs.predorpost = 1;
hgf.empirical_priors = struct('eta', []);
hgf.empirical_priors.eta = 1;

%% Sampler configuration

pars = struct();
pars.seed = 1;
% pars.nburnin = 5000;
% pars.niter = 15000;

pars.nburnin = 2000;
pars.niter = 5000;


% pars.nburnin = 200;
% pars.niter = 1000;

pars.nchains = nchains;

fprintf('Setting up hhgf run with %d chains, %d burn-in iterations and %d iterations\n',...
    nchains, pars.nburnin, pars.niter);
%% Set inference struct

inference = struct();

%% Construct RW object for RW models
% Rescorla-Wagner

rw = struct('c_prc', [], 'c_obs', []);
config_rw = tapas_rw_binary_config;

rw.c_prc.n_levels = 3;
rw.c_obs.obs_fun = @tapas_softmax_binary;
rw.c_obs.transp_obs_fun = @tapas_softmax_binary_transp;

rw.c_prc.prc_fun = @tapas_rw_binary;
rw.c_prc.transp_prc_fun = @tapas_rw_binary_transp;

rw.c_obs.predorpost = 1;
rw.c_prc.priormus = config_rw.priormus';
rw.c_prc.priorsas = config_rw.priorsas';
rw.c_prc.priorsas(1) = 0;
rw.c_prc.priorsas(2) = 16;

rw.c_obs.priormus = 8;
rw.c_obs.priorsas = 1;
rw.scale = 0.5;

rw.ign = [];
rw.irr = [];