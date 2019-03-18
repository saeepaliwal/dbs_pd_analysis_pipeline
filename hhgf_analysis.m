function stats_out = hhgf_analysis(STATS_STRUCT,D, resp_models, parameter_estimate);

load(STATS_STRUCT)

%% Pull in the game trace of the slot machine
load game_trace.mat

%% Run all models:
for iSub = 1:length(stats)
    if isfield(stats{iSub},'hgf')
        stats{iSub} = rmfield(stats{iSub},'hgf');
    end
    if isfield(stats{iSub},'rw')
        stats{iSub} = rmfield(stats{iSub},'rw');
    end
%     P = game_trace(1:length(stats{iSub}.data{1}.performance));
    stats{iSub} = run_hhgf(stats, iSub, resp_models); 
end
save(STATS_STRUCT,'stats');

%% Collect model parameters
for iSub = subject_type
    stats = collect_model_parameters(stats, parameter_estimate)
end
save(STATS_STRUCT,'stats');


%% Step 4: Run model comparison
% Group-level free energy comparison

pars_of_interest = {'omega';'theta';'beta'};
for  iSub = subject_type
    idx = 1; % winning model from pre-DBS timepoint
    stats{iSub}.winning_model = idx;
    
    for p = 1:length(pars_of_interest)
        param = pars_of_interest{p};
        param_all = [param '_all'];
        stats{iSub}.(param) = stats{iSub}.(param_all)(:,idx);
    end
end
save(STATS_STRUCT,'stats');

