%% Pull in all paths
addpath(genpath('./advanced_slot_machine_analysis'));
addpath(genpath('./tools'));
addpath(genpath('./tapas/'));
%% Make directories

PROJECT_FOLDER = pwd;

D.PROJECT_FOLDER = PROJECT_FOLDER;

% Data directories
D.LIST_OF_SUBJECT_DIRECTORIES = {[D.PROJECT_FOLDER 'PRE_DBS']};
D.SPREADSHEET_DIR = fullfile(D.PROJECT_FOLDER, 'data_spreadsheets');

% Results directories
D.RESULTS_DIR = fullfile(D.PROJECT_FOLDER, 'results');
D.FIGURES_DIR = fullfile(D.RESULTS_DIR, 'figures');
D.REGRESSION_DIR = fullfile(D.RESULTS_DIR, 'regressions');

D.PARAMETER_SPREADSHEET = fullfile(D.RESULTS_DIR, 'DBS_pre_parameters.csv');

% Create any necessary directories
results_dirs = {'RESULTS_DIR'; 'FIGURES_DIR'; 'REGRESSION_DIR'};
for iDir = 1:numel(results_dirs)
    results_dir = results_dirs{iDir};
    if ~exist(D.(results_dir),'dir')
        mkdir(D.(results_dir));
    end
end

%% Set analysis flags
% Construct stats struct
flags.construct_stats = 0;

% Invert HHGF
flags.run_hhgf = 1;

% Collect model parametrs
flags.collect_model_parameters = 1;

% Run model comparison
flags.run_model_comparison = 1;

% Save to final (this saves the latest stats struct to version _FINAL
flags.save_to_final = 1;

% Load questionnaire and anatomical data
flags.load_q_and_a = 0;

% Print parameters to CSV for Phil
flags.print_parameters_to_csv = 0;

% Post-hoc statistical analyses
flags.run_figures_tables = 1;
flags.run_cross_validation = 0;

%% Names of output stats strucutures
% N.B. stats is structured as follows:
%    stats{1} holds pre-dbs data
%    stats{2} hold post-dbs data

load('latest_run_num.mat');

% Increment stats file
if flags.run_hhgf
    latest_run_num = latest_run_num + 1;
    save('latest_run_num','latest_run_num');
end
disp(latest_run_num)

stats_filename = ['STATS_DBS_' sprintf('%d',latest_run_num) '.mat'];

STATS_DBS = fullfile(D.RESULTS_DIR,stats_filename);
disp(STATS_DBS)

if flags.run_hhgf
    BASE_STATS = fullfile(D.RESULTS_DIR,'STATS_DBS.mat');
    copyfile(BASE_STATS,STATS_DBS);
end

%% Step 1: Construct stats
% N.B: stats struct has the following structure: stats{subject_type}.fields

if flags.construct_stats
    stats = construct_stats(D)
    save(STATS_DBS,'stats');
end

%% Run all models

if flags.run_hhgf
    load(STATS_DBS);
    resp_models = {
        'tapas_softmax_binary';
        'tapas_softmax_binary_invsig2';
        'rescorla_wagner'};

    fprintf('Running HHGF on all models\n');

    % Selected for testing
    resp_models = resp_models(1);

    % Run HHGF
    stats = run_hhgf(stats,resp_models);

    keyboard
    save(STATS_DBS,'stats');
end

%% Collect model parameters

if flags.collect_model_parameters
    load(STATS_DBS);
    stats = collect_median_parameters(stats);
    save(STATS_DBS,'stats');
end

%% Run model comparison

if flags.run_model_comparison
    load(STATS_DBS);
    pars_of_interest = {'omega';'theta';'beta'};
    for  iSub = 1:length(stats)
        idx = 1; % winning model from pre-DBS timepoint
        stats{iSub}.winning_model = idx;

        for p = 1:length(pars_of_interest)
            param = pars_of_interest{p};
            param_all = [param '_all'];
            stats{iSub}.(param) = stats{iSub}.(param_all)(:,idx);
        end
    end
    save(STATS_DBS,'stats');
end

%% Save this version to final
if flags.save_to_final
    flags.save_to_final = 0;
    load('latest_run_num.mat');
    stats_filename = ['STATS_DBS_' sprintf('%d',latest_run_num) '.mat'];
    STATS_DBS = fullfile(D.RESULTS_DIR,stats_filename);
    STATS_FINAL = fullfile(D.RESULTS_DIR,'STATS_FINAL.mat');
    copyfile(STATS_DBS, STATS_FINAL);
end

%% Print parameters to csv
if flags.print_parameters_to_csv
    print_parameters_to_csv(stats,D);
end

%% Load questionnaire and anatomical data

if flags.load_q_and_a
    load(STATS_DBS);
    stats = load_questionnaires_and_anatomical_data(stats, D);
    save(STATS_DBS,'stats');
end

%% Run regressions on winning model from paper
if flags.run_figures_tables

    load(STATS_DBS)

    %% Table 2 and Supplementary table 2:
    % Questionnaire and slot machine behavior
    %behavioral_data_analyses(stats)

    %% Table 3: Run regressions on behavioral data
    %behavioral_regressions(stats);

    %% Table 4 and Figure 3: Model comparison and winning model parameters,
    % Pre and Post DBS
    %model_parameter_analyses(stats, D)

    %% Regressions of BIS on model parameters
    % Table 5 & Supplementary tables 7 & 8
    parameter_regressions(stats);
end

%% Run cross-validation
if flags.run_cross_validation

    %% Runs and prints Figure 5
    cross_validation(stats, D);
end
%}