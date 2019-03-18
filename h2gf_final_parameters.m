%% Gambling DBS Parameter Recovery
%% General set-up
% TAPAS version: commit bda863c on branch h2gf_chm.
% 
% Set path to TAPAS:

clearvars; close all; clc;
addpath(genpath('~/Sync/Sdoff/tapas'))
%% 
% Load input sequence (variable u).
%%
load('input.mat');
%% Explore properties of input sequence
%%
scrsz = get(0,'ScreenSize');
outerpos = [0.2*scrsz(3),0.7*scrsz(4),0.8*scrsz(3),0.3*scrsz(4)];
figure('OuterPosition', outerpos)
plot(u, '.', 'Color', [0 0.6 0], 'MarkerSize', 11)
xlabel('Trial number')
ylabel('u')
axis([1, 100, -0.1, 1.1])
%%
bopars = tapas_fitModel([],...
                         u,...
                         'tapas_hgf_binary_config',...
                         'tapas_bayes_optimal_binary_config');
%%
bopars.c_prc
%%
tapas_hgf_binary_plotTraj(bopars)
%%
sim = tapas_simModel(u,...
                     'tapas_hgf_binary',...
                     [NaN 0 1 NaN 1 1 NaN 0 0 1 1 NaN -2 -1],...
                     'tapas_softmax_binary',...
                     2);
tapas_hgf_binary_plotTraj(sim)
%%
sim = tapas_simModel(u,...
                     'tapas_hgf_binary',...
                     [NaN 0 1 NaN 1 1 NaN 0 0 1 1 NaN -1 -5],...
                     'tapas_softmax_binary',...
                     2);
tapas_hgf_binary_plotTraj(sim)
%% Data simulation and estimation
% We choose a range of values for the parameters $\omega_2$ (tonic volatility 
% at the second level) and $\omega_3$ (tonic volatility at the third level), and 
% $\zeta$ (decision noise). The rest of the parameters are held constant.
%%
om2_values = [-5, -3.5, -2];
om3_values = [-7, -4, -1];
ze_values = [1, 4, 8];

%[om2, om3] = meshgrid(om2_values, om3_values);
[om2, om3, ze] = meshgrid(om2_values, om3_values, ze_values);
om2 = om2(:)';
om3 = om3(:)';
ze = ze(:)';
gridsize = length(om2);
%% 
% We choose a number of simulations per grid point.
%%
numsim = 8;
%% 
% We initialize a structure containing the simulations.
%%
sim = struct('u', cell(gridsize, numsim),...
             'ign', [],...
             'c_sim', [],...
             'p_prc', [],...
             'c_prc', [],...
             'traj', [],...
             'p_obs', [],...
             'c_obs', [],...
             'y', []);
%% 
% We initialize a structure containing the estimations made by the HGF Toolbox.
%%
est = struct('y', cell(gridsize, numsim),...
             'u', [],...
             'ign', [],...
             'irr', [],...
             'c_prc', [],...
             'c_obs', [],...
             'c_opt', [],...
             'optim', [],...
             'p_prc', [],...
             'p_obs', [],...
             'traj', []);
%% 
% We initialize a structure (again containing the simulations) to be used 
% later as an argument for the h2gf estimation.
%%
data = struct('y', cell(gridsize, numsim),...
              'u', [],...
              'ign', [],...
              'irr', []);
%% 
% We simulate and immediately estimate using the HGF Toolbox.
%%
for i = 1:gridsize
    for j = 1:numsim
    % Simulation
    sim(i, j) = tapas_simModel(u,...
                            'tapas_hgf_binary', [NaN,...
                                                1,...
                                                1,...
                                                NaN,...
                                                1,...
                                                1,...
                                                NaN,...
                                                0,...
                                                0,...
                                                1,...
                                                1,...
                                                NaN,...
                                                om2(i),...
                                                om3(i)],...
                         'tapas_softmax_binary', ze(i));
    % Simulated responses for later use by h2gf
    data(i, j).y = sim(i,j).y;
    % Experimental inputs for later use by h2gf
    data(i, j).u = sim(i,j).u;
    % Parameter estimation
    est(i, j) = tapas_fitModel(sim(i,j).y,...
                            sim(i,j).u,...
                            'tapas_hgf_binary_config',...
                            'tapas_softmax_binary_config');
    end
end
clear i j
%% Results
% We gather the results for the $\omega$'s.
%%
om_est = NaN(2, gridsize, numsim);
for i = 1:gridsize
    for j = 1:numsim
        om_est(1,i,j) = est(i,j).p_prc.om(2);
        om_est(2,i,j) = est(i,j).p_prc.om(3);
        om_est(3, i, j) = est(i, j).p_obs.be(1);
    end
end
%% 
% We compare the estimated values for $\omega_2$ with the ground truth.
%%
om2
squeeze(om_est(1,:,:))'
%% 
% We compare the estimated values for $\omega_3$ with the ground truth.
%%
om3
squeeze(om_est(2,:,:))'
%%
ze
squeeze(om_est(3, :, :))'

%% h2gf set-up
%%
hgf = struct('c_prc', [], 'c_obs', []);
hgf.c_prc.prc_fun = @tapas_hgf_binary;
hgf.c_prc.transp_prc_fun = @tapas_hgf_binary_transp;

hgf.c_obs.obs_fun = @tapas_softmax_binary;

hgf.c_obs.transp_obs_fun = @tapas_softmax_binary_transp;
config = tapas_hgf_binary_config();

hgf.c_prc.priormus = config.priormus;
hgf.c_prc.priorsas = config.priorsas;
hgf.c_prc.n_levels = config.n_levels;
%clear config
hgf.c_obs.priormus = 8;
hgf.c_obs.priorsas = 1;
hgf.c_obs.predorpost = 1;
hgf.empirical_priors = struct('eta', []);
hgf.empirical_priors.eta = 1;
%% Sampler configuration
%%
pars = struct();
pars.niter = 1000;
pars.nburnin = 1000;
pars.nchains = 1;
%% h2gf estimation
%%
inference = struct();
%%
%%

om_est2 = NaN(2,gridsize);

for j = 1:numsim
    h2gf_est = tapas_h2gf_estimate(data(:, j), hgf, inference, pars);
    for i = 1:gridsize
        om_est2(1, i, j) = h2gf_est.summary(i).p_prc.om(2);
        om_est2(2, i, j) = h2gf_est.summary(i).p_prc.om(3);
    end
end
%%
om2
squeeze(om_est2(1, :, :))'
mean(squeeze(om_est2(1, :, :))')
%%
om3
squeeze(om_est2(2, :, :))'
mean(squeeze(om_est2(2, :, :))')
