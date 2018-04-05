function stats = hhgf_analysis(STATS_PRE, STATS_POST)
%% Pre DBS

% Run analyses
[pre_stats] = wrapper(STATS_PRE, target_dir);

%% Post DBS

% Run analyses
[post_stats] = wrapper(STATS_POST, target_dir);

%% Combine stats

for i = 1:length(pre_stats{1}.labels)
    if ~strcmp(pre_stats{1}.labels{i}(1:end-4), ...
        post_stats{1}.labels{i}(1:end-5))
        error('Labels are not aligned correctly!');
    end
end

stats{1} = pre_stats{1};
stats{2} = post_stats{1};

end

function [stats] = wrapper(STATS_STRUCT, dtarget)
%% Pull in the game trace of the slot machine
load(fullfile('advanced_slot_machine_analysis','game_trace.mat'));

%% Step 1: Pull behavioral information
% N.B: stats struct has the following structure: stats{subject_type}.fields

load(STATS_STRUCT);
iSub = 1;

%% Step 2: Run all models:
if isfield(stats{iSub},'hgf')
    stats{iSub} = rmfield(stats{iSub},'hgf');
end
if isfield(stats{iSub},'rw')
    stats{iSub} = rmfield(stats{iSub},'rw');
end
P = game_trace(1:length(stats{iSub}.data{1}.performance));
stats = run_all_models_HHGF(stats, iSub, P); 

%% Step 3: Collect all model info
[FE_HH, FE_RW, llh_all, kappa_all, omega_all, theta_all, beta_all] = ...
    collect_model_info_TI(iSub, stats);

stats{iSub}.FE_grid = [FE_HH FE_RW];
stats{iSub}.llh = llh_all;
stats{iSub}.kappa_all = kappa_all;
stats{iSub}.omega_all = omega_all;
stats{iSub}.theta_all = theta_all;
stats{iSub}.beta_all = beta_all;


%% Step 4: Run model comparison
% Group-level free energy comparison

pars_of_interest = {'omega'; 'theta'; 'beta'};
%[m idx] = max(stats{1}.FE_grid); 
idx = 1; % winning model from pre-DBS timepoint
stats{iSub}.winning_model = idx;

for p = 1:length(pars_of_interest)
    param = pars_of_interest{p};
    param_all = [param '_all'];
    stats{iSub}.(param) = stats{iSub}.(param_all)(:,idx);
end

save(fullfile(dtarget, STATS_STRUCT), 'stats');


