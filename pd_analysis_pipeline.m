 %% Pull in all paths
 
addpath(genpath('./advanced_slot_machine_analysis'));
addpath(genpath('~/Dropbox/Doctorate/tools/spm12'));
addpath(genpath('~/Dropbox/Doctorate/tools/tapas/'));

% Patients to exclude
exclude = [55];

%% Organize all data, run model from Paliwal, Petzschner et al
questionnaires = 0;
anatomical = 0;
standard_hgf_analysis

%% Analyse behavioral data, pre and post

pd_pre_post_behavior(exclude)

%% Run Bayes-optimal HGF on performance

performance_bayesoptimal_hgf

%% Run regressions on winning model from paper
analysis = 'pre'
impulsivity_regressions(analysis,exclude)

%% Run regressions on Bayes optimal parameters

bayes_optimal_regressions(exclude)

%% Run regressions on behavioral data

behavioral_regressions(exclude)

%% Run analyses on anatomical data

anatomical_analyses(exclude)


