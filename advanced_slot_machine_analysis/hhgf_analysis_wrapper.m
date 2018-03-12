
%% Pull in the game trace of the slot machine
load game_trace.mat

%% Specify subject type
subject_type = [1 2];

%% Step 1: Pull behavioral information
% N.B: stats struct has the following structure: stats{subject_type}.fields

if ~exist('STATS_STRUCT')
    if ~iscell(D.LIST_OF_SUBJECT_DIRECTORIES)
        subject_dir = {D.LIST_OF_SUBJECT_DIRECTORIES};
    else
        subject_dir = D.LIST_OF_SUBJECT_DIRECTORIES;
    end
    
    stats = {};
    for i = 1:length(subject_dir)
        stats{i} = output2mat(subject_dir{i})
    end
    
    data_name = ['stats_' ANALYSIS_NAME];
    save(data_name,'stats');
    subject_type = 1:length(subject_dir);
else
    load(STATS_STRUCT)
    subject_type = 1:length(stats);
end

%% Step 2: Run all models:
for iSub = subject_type
    if isfield(stats{iSub},'hgf')
        stats{iSub} = rmfield(stats{iSub},'hgf');
    end
    if isfield(stats{iSub},'rw')
        stats{iSub} = rmfield(stats{iSub},'rw');
    end
    P = game_trace(1:length(stats{iSub}.data{1}.performance));
    stats = run_all_models_HHGF(stats, iSub,P)    
end
save(STATS_STRUCT,'stats');


%% Step 3: Collect all model info

for iSub = subject_type
    [FE_HH,FE_RW,llh_all,kappa_all,omega_all,theta_all,beta_all] = collect_model_info_TI(iSub, stats);
    
    stats{iSub}.FE_grid = [FE_HH FE_RW];
    stats{iSub}.llh = llh_all;
    stats{iSub}.kappa_all = kappa_all;
    stats{iSub}.omega_all = omega_all;
    stats{iSub}.theta_all = theta_all;
    stats{iSub}.beta_all = beta_all;
end
save(STATS_STRUCT,'stats');


%% Step 4: Run model comparison
% Group-level free energy comparison

pars_of_interest = {'omega';'theta';'beta'};
for  iSub = subject_type
    %[m idx] = max(stats{1}.FE_grid); 
    idx = 1; % winning model from pre-DBS timepoint
    stats{iSub}.winning_model = idx;
    
    for p = 1:length(pars_of_interest)
        param = pars_of_interest{p};
        param_all = [param '_all'];
        stats{iSub}.(param) = stats{iSub}.(param_all)(:,idx);
    end
end
save(STATS_STRUCT,'stats');

