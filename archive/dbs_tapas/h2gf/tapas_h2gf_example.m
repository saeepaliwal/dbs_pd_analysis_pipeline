function [hgf_est] = tapas_h2gf_example()
% Runs an example of the hgf using arbitrary data.
%

% aponteeduardo@gmail.com
% copyright (C) 2017
%

% Initilize a structure to hold the hgf
hgf = struct('c_prc', [], 'c_obs', []);
% Set up the number of levels
hgf.c_prc.n_levels = 3; 

% Set up the perceptual function
hgf.c_prc.prc_fun = @tapas_hgf_binary;
% Set up the reparametrization function
hgf.c_prc.transp_prc_fun = @tapas_hgf_binary_transp;

% Set up the observation function.
hgf.c_obs.obs_fun = @tapas_unitsq_sgm; 
% Reparametrization function 
hgf.c_obs.transp_obs_fun = @tapas_unitsq_sgm_transp; 

% Enter the configuration of the binary hgf
config = tapas_hgf_binary_config();

% Parameters should be columns
hgf.c_prc.priormus = config.priormus';
hgf.c_prc.priorsas = config.priorsas';

% Parameters should be columns
hgf.c_obs.priormus = 0.5;
hgf.c_obs.priorsas = 1;

% Number of subjects
num_subjects = 10;

% Values of ze, ka
ze = 0.5;
ka = 0.5;

% Simulate trajectories with set parameters
pars = [NaN 1 1 NaN 1 1 NaN 0 0 NaN ka NaN -4 log(0.0025)];
% Initialize a structure for the data
data = struct('y', cell(num_subjects, 1), ...
    'u', cell(num_subjects, 1), 'ign', [], 'irr', []);

% This are trial used in the experiment
[y, u] = tapas_h2gf_load_example_data();

for i = 1:num_subjects
	% Generate artifical data
    %sim = tapas_simModel(u, 'tapas_hgf_binary', ...
	%	pars, 'tapas_unitsq_sgm');
	% Fill the responses
    data(i).y = y;
	% and experimental manipulations
    data(i).u = u;
end

% Initilize the place holder for the parameters of the 
% inference. Missing parameters are filled by default
% values. This is implemented in tapas_h2gf_inference.m

inference = struct();
pars = struct();

% Number of samples stored 
pars.niter = 4000;
% Number of samples in the burn-in phase
pars.nburnin = 4000;
% Number of samples used for diagnostics. During the 
% burn-in phase the parameters of the algorithm are 
% adjusted to increase the efficiency. This happens after 
% every diagnostic cycle.
pars.ndiag = 1000;

% Set up the so called temperature schedule. This is used to
%compute the model evidence. It is a matrix of NxM, where N 
% is the number of subjects and M is the number of chains used 
%to compute the model evidence. The
% temperature schedule is selected using a 5th order power rule. 
pars.T = ones(num_subjects, 1) * linspace(0.01, 1, 16).^5;

% This controls how often a 'swap' step is perform. 
pars.mc3it = 4;

% This function is entry point to the algorithm. Note that its
% behavior can be largely modified by changing the default 
% settings.
hgf_est = tapas_h2gf_estimate(data, hgf, inference, pars);

end
