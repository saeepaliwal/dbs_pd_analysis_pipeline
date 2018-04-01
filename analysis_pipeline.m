function analysis_pipeline()
%% Set analysis flags

fp = 1;

% Invert HHGF
flags.run_hhgf = 0;

% Load questionnaire and anatomical data
flags.load_q_and_a = 0;

% Print parameters to CSV (for Phil)
flags.print_parameters_to_csv = 0;

% Post-hoc statistical analyses
flags.run_behavioral_analysis = 0;
flags.run_behavioral_regressions = 0;
flags.run_model_analysis  = 0;
flags.run_regressions = 1;
flags.load_original = 0;
flags.run_cross_val = 0;

%% Clear workspace and define values

% Main directory
D.PROJECT_FOLDER = './';

% Data directories
D.LIST_OF_SUBJECT_DIRECTORIES = {[D.PROJECT_FOLDER 'PRE_DBS'];...
    [D.PROJECT_FOLDER '/POST_DBS']};
D.SPREADSHEET_DIR = [D.PROJECT_FOLDER 'data_spreadsheets/'];

% Results directories
D.RESULTS_DIR = [D.PROJECT_FOLDER 'eduardo_rerun/'];
D.FIGURES_DIR = [D.RESULTS_DIR 'figures/'];
D.REGRESSION_DIR = [D.RESULTS_DIR 'regressions/'];

% Create any necessary directories
results_dirs = {'RESULTS_DIR'; 'FIGURES_DIR'; 'REGRESSION_DIR'};
for iDir = 1:numel(results_dirs)
    results_dir = results_dirs{iDir};
    if ~exist(D.(results_dir),'dir')
        mkdir(D.(results_dir));
    end
end

%% Names of output stats strucutures
% N.B. stats is structured as follows:
%    stats{1} holds pre-dbs data
%    stats{2} hold post-dbs data

STATS_PRE = [D.RESULTS_DIR 'stats_PRE_DBS.mat'];
STATS_POST = [D.RESULTS_DIR 'stats_POST_DBS.mat'];
STATS_HHGF = [D.RESULTS_DIR 'stats_HHGF.mat'];
STATS_ALL_DATA = [D.RESULTS_DIR 'stats_ALL_DATA.mat'];
%STATS_HHGF = STATS_ALL_DATA;

PARAMETER_SPREADSHEET = [D.RESULTS_DIR 'DBS_PD_pre_post_parameters.csv'];

if flags.load_original
    stats = load('eduardo_rerun/stats_ALL_DATA.mat');
    stats = stats.stats;
else
    %% Run models
    if flags.run_hhgf
        stats = hhgf_analysis(STATS_PRE, STATS_POST, flags);
    else
        stats = load('verification/eduardo_rerun/stats_ALL_DATA.mat');
        stats = stats.stats; 
    end
    behavioral_stats = load('data/stats_behavioral.mat');
    behavioral_stats = behavioral_stats.stats;
    for i = 1:2
        stats{i} = copy_fields(stats{i}, behavioral_stats{i});
    end
end

%% Print parameters to csv
if flags.print_parameters_to_csv
    print_parameters_to_csv();
end

%% Analyse behavioral data, pre and pos
% Supplementary table 3
if flags.run_behavioral_analysis
    behavioral_data_analyses(stats, D) % DONE
end

if flags.run_behavioral_regressions
    %% Run regressions on behavioral data
    % Supplementary table 4, 5, 6 & table 3
    behavioral_regressions(stats);
end

%% Analyze model results, pre and post
% Figure 4
if flags.run_model_analysis
    model_parameter_analyses(stats, D)
end

%% Run regressions on winning model from paper
if flags.run_regressions
    %% Run regressions on model parameters
    % Table 5 & Supplementary tables 7 & 8
    parameter_regressions(stats, fp);
end

%% Run cross-validation
if flags.run_cross_val
    % Figure 5
    cross_validation(stats);
end

end
