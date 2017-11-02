%% Pre DBS
% Specify paths for data saving
ANALYSIS_NAME = 'PRE_DBS';
LIST_OF_SUBJECT_DIRECTORIES = ['~/polybox/Projects/DBS_ParkinsonsPatients/' ANALYSIS_NAME];
PATH_TO_RESULTS_FOLDER = ['~/polybox/Projects/DBS_ParkinsonsPatients/results/' ANALYSIS_NAME '/'];

% Run winning model from Paliwal Petzschner et al 2014
PAPER = 1;
HHGF = 1;

%STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];

% Run analyses
all_analysis_wrapper

%% Post DBS

% Specify paths for data saving
ANALYSIS_NAME = 'POST_DBS';
LIST_OF_SUBJECT_DIRECTORIES = ['~/polybox/Projects/DBS_ParkinsonsPatients/' ANALYSIS_NAME];
PATH_TO_RESULTS_FOLDER = ['~/polybox/Projects/DBS_ParkinsonsPatients/results/' ANALYSIS_NAME '/'];

% Run winning model from Paliwal Petzschner et al 2014
PAPER = 1;
HHGF = 1;

%STATS_STRUCT = ['~/polybox/Projects/DBS_ParkinsonsPatients/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];

% Run analyses
all_analysis_wrapper

%% Pull in questionnaire data
if questionnaires
    Q_FILE = '~/polybox/Projects/BreakspearCollab/Longitudinal_Data_Subjects_TNU.xlsx';
    
    [q] = excel_to_questionnaire(Q_FILE)
    
    save('~/polybox/Projects/BreakspearCollab/results/questionnaire_struct.mat','q');
end
%% Pull in anatomical data
if anatomical
    ANATOMICAL_FILE = '~/polybox/Projects/BreakspearCollab/Anatomical_Data_TNU.xlsx';
    [ad] = excel_to_questionnaire(ANATOMICAL_FILE);
    
    save('~/polybox/Projects/BreakspearCollab/results/anatomical_struct.mat','ad');
end


