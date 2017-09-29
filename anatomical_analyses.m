function anatomical_analyses(exclude)

%% Load model parameters
ANALYSIS_NAME = 'PRE_DBS';
STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];
PARS_WORKSPACE = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/parameter_workspace_hhgf.mat'];
load(PARS_WORKSPACE)
load(STATS_STRUCT);
stats_pre = stats;
omega_pre = log(pars.omega);
theta_pre = log(pars.theta);

ANALYSIS_NAME = 'POST_DBS';
STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_DoubleHGF_' ANALYSIS_NAME '.mat'];
PARS_WORKSPACE = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/parameter_workspace_hhgf.mat'];
load(PARS_WORKSPACE)
load(STATS_STRUCT);
stats_post = stats;
omega_post = log(pars.omega);
theta_post = log(pars.theta);

%% Load behavioral results
load all_patients
ANALYSES= {'PRE_DBS';'POST_DBS'};
load all_patients

bets = zeros(100,2,length(all_patients));
for k = 1:length(ANALYSES)
    ANALYSIS_NAME = ANALYSES{k};
    STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_' ANALYSIS_NAME '.mat'];
    load(STATS_STRUCT);
    
    for i = 1:length(stats{1}.labels)
        
        out = regexp(stats{1}.labels(i),'\d*','Match');
        num = str2double(out{:});
        
        idx = find(all_patients == num);
        
        bets(:,k,idx) = stats{1}.data{i}.bets;
    end
%     ms(:,k) = stats{1}.switchPct;
%     gam(:k) = stats{1}.gamblePct;
end

for i = 1:length(all_patients)
    bet_mean_pre(i,:) = mean(bets(:,1,i));
    bet_var_pre(i,:) = var(bets(:,1,i));

    bet_mean_post(i,:) = mean(bets(:,2,i));
    bet_var_post(i,:) = var(bets(:,2,i));

    bet_mean_diff(i,:) = bet_mean_post(i) - bet_mean_pre(i);
    bet_var_diff(i,:) = bet_var_post(i) - bet_var_pre(i);
end



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

omega_diff = -omega_post(post_idx)+omega_pre(pre_idx);
theta_diff = theta_post(post_idx)-theta_pre(pre_idx);

omega_post = omega_post(post_idx);
theta_post = theta_post(post_idx);

%% Load questionnaires
Q_STRUCT = '~/polybox/Projects/BreakspearCollab/results/questionnaire_struct.mat';
load(Q_STRUCT)

ANATOMICAL_FILE = '~/polybox/Projects/BreakspearCollab/results/anatomical_struct.mat';
load(ANATOMICAL_FILE)

for i = 1:length(q.labels)
    out = regexp(q.labels(i),'\d*','Match');
    q_labels(i) = str2double(out{:});
end

for i = 1:length(ad.labels)
    out = regexp(ad.labels(i),'\d*','Match');
    ad_labels(i) = str2double(out{:});
end

% Pull out excluded patients
pre_and_post = pre_and_post(~ismember(pre_and_post,exclude));
ad_labels = ad_labels(~ismember(ad_labels,exclude));
all_patients = all_patients(~ismember(all_patients,exclude));

[patient_list, q_idx, a_idx] = intersect(q_labels,ad_labels);
[patient_list2, s_idx, a2_idx] = intersect(pre_and_post, ad_labels);
[patient_list3, b_idx, a3_idx] = intersect(all_patients,ad_labels);

% Run all regressions
d_assoc = [ad.Right_Contact_Distance_To_Associative ad.Left_Contact_Distance_To_Associative];
vat_assoc = [ad.Right_Associative_Percentage_VAT_Overlap ad.Left_Associative_Percentage_VAT_Overlap];
ratio_assoc = [ad.Right_Associative_Motor_VATRatio ad.Left_Associative_Motor_VATRatio];

d_limbic = [ad.Right_Contact_Distance_To_Limbic ad.Left_Contact_Distance_To_Limbic];
ratio_limbic = [ad.Right_Limbic_Motor_VATRatio ad.Left_Limbic_Motor_VATRatio];

motor_overlap = [ad.Right_Motor_Percentage_VAT_Overlap ad.Left_Motor_Percentage_VAT_Overlap];

fields = {'Max_QUIP_Change','Max_BIS_Change','Case__Yes_No_','Max_EQ_Change','Max_CarerEQ_Change','FU3_EQ_Total','FU3_CarerEQ_Total'};

%% Anatomical regressions on behavior
X = [motor_overlap];
X = X(a_idx,:);

% Behavioral regressions
for f = 1:length(fields)
    y = q.(fields{f})(q_idx);
    reg_results{f} = regstats(y,X,'linear');
    display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
end

%% Parameter regression
X = [ratio_limbic];
X = X(a2_idx,:);
y = omega_diff(s_idx);
param_reg = regstats(y,X,'linear');
display(sprintf('Omega diff: %0.4f (%0.4f)', param_reg.fstat.f,param_reg.fstat.pval));

%% Prediction error regression
% X = [distance];
% X = X(a2_idx,:);
% y = pe_diff(s_idx);
% param_reg = regstats(y,X,'linear');
% display(sprintf('PE diff: %0.4f (%0.4f)', param_reg.fstat.f,param_reg.fstat.pval));

%% Parameters post, behavior
y = omega_post(s_idx);
X = [motor_overlap];
X = X(a2_idx,:);
param_reg = regstats(y,X,'linear');
display(sprintf('Omega post: %0.4f (%0.4f)', param_reg.fstat.f,param_reg.fstat.pval));

%% Slot machine behavior
y = bet_mean_diff(b_idx);
X = [d_assoc];
X = X(a3_idx,:);
param_reg = regstats(y,X,'linear');
display(sprintf('Bet mean diff: %0.4f (%0.4f)', param_reg.fstat.f,param_reg.fstat.pval));


 