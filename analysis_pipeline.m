
%% Pull in all paths
addpath(genpath('./advanced_slot_machine_analysis'));
addpath(genpath('./tools'));
addpath(genpath('./spm12'));
addpath(genpath('./dbs_tapas/'));

%% Set analysis flags

fp = 1;

% Invert HHGF
flags.run_hhgf = 1;

% Load questionnaire and anatomical data
flags.load_q_and_a = 1;

% Print parameters to CSV (for Phil)
flags.print_parameters_to_csv = 0;

% Post-hoc statistical analyses
flags.run_figures_tables = 0;
flags.run_cross_validation = 0;

%% Clear workspace and define values

% Main directory

D.PROJECT_FOLDER = '/home/saee/Analyses/DBS_PD/';


% Data directories
D.LIST_OF_SUBJECT_DIRECTORIES = {[D.PROJECT_FOLDER 'PRE_DBS'];...
    [D.PROJECT_FOLDER '/POST_DBS']};
D.SPREADSHEET_DIR = [D.PROJECT_FOLDER 'data_spreadsheets/'];

% Results directories
D.RESULTS_DIR = [D.PROJECT_FOLDER 'saee_rerun/'];
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
STATS_HHGF = [D.RESULTS_DIR 'stats_HHGF_RW_Freebeta.mat'];
STATS_ALL_DATA = [D.RESULTS_DIR 'stats_ALL_DATA_RW_FreeBeta.mat'];

PARAMETER_SPREADSHEET = [D.RESULTS_DIR 'DBS_PD_pre_post_parameters.csv'];

%% Run models
if flags.run_hhgf
    stats = hhgf_analysis(STATS_PRE, STATS_POST);
end

%% Print parameters to csv
if flags.print_parameters_to_csv
    print_parameters_to_csv();
end

%% Load questionnaire and anatomical data
if flags.load_q_and_a
    load(STATS_HHGF);
    stats = load_questionnaires_and_anatomical_data(stats, D);
    save(STATS_ALL_DATA,'stats');
else
    load(STATS_ALL_DATA);
end


%% Run regressions on winning model from paper
if flags.run_figures_tables
    
    %% Table 2 and Supplementary table 2:
    % Questionnaire and slot machine behavior
    behavioral_data_analyses(stats, D)
    
    %% Table 3: Run regressions on behavioral data
    behavioral_regressions(stats);
    
    %% Table 4 and Figure 3: Model comparison and winning model parameters,
    % Pre and Post DBS
    model_parameter_analyses(stats, D)
  
    %% Regressions of BIS on model parameters   
    % Table 5 & Supplementary tables 7 & 8
    parameter_regressions(stats);
end

%% Run cross-validation
if flags.run_cross_validation
    
    %% Runs and prints Figure 5 
    cross_validation(stats, D);
end
