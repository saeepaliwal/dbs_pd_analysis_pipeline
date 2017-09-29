function impulsivity_regressions(analysis, exclude)
% analysis can be 'pre', 'post', or 'both'

%% Load parameters
ANALYSIS_NAME = 'PRE_DBS';
STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];
PARS_WORKSPACE = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/parameter_workspace_hhgf.mat'];
load(PARS_WORKSPACE)
load(STATS_STRUCT);
stats_pre = stats;
omega_pre = log(pars.omega);
theta_pre = log(pars.theta);

% for i = 1:length(stats{1}.labels)
%     pe = sum(stats{1}.hgf.bin(i).traj.da,1);
%     pe_pre(i) = pe(2);
% end

ANALYSIS_NAME = 'POST_DBS';
STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];
PARS_WORKSPACE = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/parameter_workspace_hhgf.mat'];
load(PARS_WORKSPACE)
load(STATS_STRUCT);
stats_post = stats;
omega_post = log(pars.omega);
theta_post = log(pars.theta);

% for i = 1:length(stats{1}.labels)
%     pe = sum(stats{1}.hgf.bin(i).traj.da,1);
%     pe_post(i) = pe(2);
% end

%% Pull out equivalent patient indices
for i = 1:length(stats_pre{1}.labels)
    out = regexp(stats_pre{1}.labels(i),'\d*','Match');
    pre_data(i) = str2double(out{:});
end

for i = 1:length(stats_post{1}.labels)
    out = regexp(stats_post{1}.labels(i),'\d*','Match');
    post_data(i) = str2double(out{:});
end

[pre_and_post, pre_idx, post_idx] = intersect(pre_data,post_data);

display_figure = 0;
if display_figure
    [h_omega, p_omega] = ttest(omega_post(post_idx),omega_pre(pre_idx));
    [h_theta, p_theta] = ttest(theta_post(post_idx),theta_pre(pre_idx));
    
    figure(301)
    subplot(2,1,1);
    boxplot([omega_post(post_idx),omega_pre(pre_idx)]);
    subplot(2,1,2);
    boxplot([theta_post(post_idx),theta_pre(pre_idx)]);
    purty_plot(301,'~/polybox/Projects/BreakspearCollab/results/figures/model_pars','eps')
end

omega_diff = omega_post(post_idx)-omega_pre(pre_idx);
theta_diff = theta_post(post_idx)-theta_pre(pre_idx);

%pe_diff = pe_post(post_idx) - pe_pre(pre_idx);
%% Load questionnaires
Q_STRUCT = '~/polybox/Projects/BreakspearCollab/results/questionnaire_struct.mat';
load(Q_STRUCT)

%% Pull out equivalent patient indices

if strcmp(analysis,'post')
    for i = 1:length(stats_post{1}.labels)
        out = regexp(stats_post{1}.labels(i),'\d*','Match');
        stats_data(i) = str2double(out{:});
    end
elseif strcmp(analysis,'pre')
        for i = 1:length(stats{1}.labels)
        out = regexp(stats_pre{1}.labels(i),'\d*','Match');
        stats_data(i) = str2double(out{:});
        end
end

for i = 1:length(q.labels)
    out = regexp(q.labels(i),'\d*','Match');
    q_data(i) = str2double(out{:});
end

% Pull out excluded patients
q_data = q_data(~ismember(q_data,exclude));

% Construct relevant index with questionnaire data
if strcmp(analysis,'both')
    pre_and_post = pre_and_post(~ismember(pre_and_post,exclude));
    [patient_list, q_idx, s_idx] = intersect(q_data,pre_and_post);
else
    stats_data = stats_data(~ismember(stats_data,exclude));
    [patient_list, q_idx, s_idx] = intersect(q_data,stats_data);
end

%% Run behavioral regressions

if strcmp(analysis,'pre')

    fields = {'Pre_LEDD','Pre_CarerBIS_Total','Pre_BIS_Total','Pre_Hayling_ABErrorScore','Max_BIS_Change',...
        'Pre_ELF_RuleViolations','Case__Yes_No_','Pre_EQ_Total','Pre_CarerEQ_Total'};
    
    X = [omega_pre theta_pre];
    X = X(s_idx,:);
    
    % Behavioral regressions
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end
    
elseif strcmp(analysis,'post')
    
     fields = {'FU3_CarerBIS_Total','FU3_BIS_Total','FU3_BIS_NonPlanning','FU3_BIS_Attentional','FU3_LN_HaylingABErrorScore',...
        'FU3_LN_ELF_RuleViolations','LN_Max_HaylingABErrorScore_Change','Case__Yes_No_','FU3_EQ_Total','FU3_CarerEQ_Total'};
    
    X = [omega_post theta_post];
    X = X(s_idx,:);
    
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end

elseif strcmp(analysis,'both')

    X = [omega_diff(s_idx) theta_diff(s_idx)];
   
    fields = {'LN_Max_HaylingABErrorScore_Change','Max_CarerBIS_Change','Max_BIS_Change','Max_QUIP_Change','Case__Yes_No_',...
        'Max_CarerEQ_Change','Max_EQ_Change','Case__Yes_No_'};
    
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end

    
    % Writeup
    X = [omega_pre(s_idx) theta_pre(s_idx)];
    
    fields = {'Max_QUIP_Change','Max_BIS_Change','Max_CarerBIS_Change','Case__Yes_No_'};
    
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end
     
end
 










