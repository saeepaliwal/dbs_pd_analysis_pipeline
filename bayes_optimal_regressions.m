function bayes_optimal_regressions

analysis = 'both';
load all_patients


PARS_WORKSPACE = ['~/polybox/Projects/BreakspearCollab/results/co_hgf_workspace.mat'];
load(PARS_WORKSPACE)
kappa_pre = kappa(:,1);
omega_pre = omega(:,1);
theta_pre = theta(:,1);

kappa_post = kappa(:,2);
omega_post = omega(:,2);
theta_post = theta(:,2);

kappa_diff = diff(kappa,2);
omega_diff = diff(omega,2);
theta_diff = diff(theta,2);

%% Load questionnaires
Q_STRUCT = '~/polybox/Projects/BreakspearCollab/results/questionnaire_struct.mat';
load(Q_STRUCT)

for i = 1:length(q.labels)
    out = regexp(q.labels(i),'\d*','Match');
    q_data(i) = str2double(out{:});
end

[patient_list, q_idx, s_idx] = intersect(q_data,all_patients);

exclude = [];

q_idx = q_idx(~ismember(q_idx,exclude));
s_idx = s_idx(~ismember(s_idx,exclude));


%% Run regressions
if strcmp(analysis,'pre')

    X = [kappa_pre(s_idx) omega_pre(s_idx) theta_pre(s_idx)];
    
    y = q.Pre_LEDD(q_idx);
    pre_reg_ledd = regstats(y,X,'linear');
    pre_reg_ledd.fstat
    
    y = q.Pre_CarerBIS_Total(q_idx);
    pre_reg_carer_bis = regstats(y,X,'linear');
    pre_reg_carer_bis.fstat
    
    y = q.Pre_BIS_Total(q_idx);
    pre_reg_bis = regstats(y,X,'linear');
    pre_reg_bis.fstat
    
    y = q.Pre_Hayling_ABErrorScore(q_idx);
    pre_reg_hayling = regstats(y,X,'linear');
    pre_reg_hayling.fstat
    
    y = q.Max_BIS_Change(q_idx);
    pre_bis_change = regstats(y,X,'linear');
    pre_bis_change.fstat
    
    y = q.Pre_ELF_RuleViolations(q_idx);
    pre_reg_rule = regstats(y,X,'linear');
    pre_reg_rule.fstat
    
    y = q.LN_Max_HaylingABErrorScore_Change(q_idx);
    pre_reg_haylingchange = regstats(y,X,'linear');
    pre_reg_haylingchange.fstat
    
    y = q.Case__Yes_No_(q_idx);
    pre_case = regstats(y,X,'linear');
    pre_case.fstat
    
    y = q.Pre_EQ_Total(q_idx);
    pre_eq = regstats(y,X,'linear')
    pre_eq.fstat

    y = q.Pre_CarerEQ_Total(q_idx);
    pre_carereq = regstats(y,X,'linear')
    pre_carereq.fstat

elseif strcmp(analysis,'post')
    
    X = [kappa_post(s_idx) omega_post(s_idx) theta_post(s_idx)];
    
    y = q.FU1_CarerBIS_Total(q_idx);
    post_reg_carer_bis = regstats(y,X,'linear');
    post_reg_carer_bis.fstat
    
    y = q.FU3_BIS_Total(q_idx);
    post_reg_bis = regstats(y,X,'linear');
    post_reg_bis.fstat

    y = q.FU1_LN_HaylingABErrorScore(q_idx);
    post_reg_hayling = regstats(y,X,'linear');
    post_reg_hayling.fstat
    
    y = q.FU2_LN_ELF_RuleViolations(q_idx);
    post_reg_rule = regstats(y,X,'linear');
    post_reg_rule.fstat
    
    y = q.LN_Max_HaylingABErrorScore_Change(q_idx);
    post_reg_haylingchange = regstats(y,X,'linear');
    post_reg_haylingchange.fstat
 
    y = q.Case__Yes_No_(q_idx);
    post_case = regstats(y,X,'linear');
    post_case.fstat
    
    y = q.FU3_EQ_Total(q_idx);
    post_eq = regstats(y,X,'linear');
    post_eq.fstat

    y = q.FU3_CarerEQ_Total(q_idx);
    post_carereq = regstats(y,X,'linear');
    post_carereq.fstat

elseif strcmp(analysis,'both')
    
    X = [omega_diff(s_idx) theta_diff(s_idx)];

    y = q.LN_Max_HaylingABErrorScore_Change(q_idx);
    diff_reg_haylingchange = regstats(y,X,'linear');
    diff_reg_haylingchange.fstat

    y = q.Max_CarerBIS_Change(q_idx);
    diff_reg_bischange = regstats(y,X,'linear');
    diff_reg_bischange.fstat

    y = q.Max_BIS_Change(q_idx);
    diff_reg_bischange = regstats(y,X,'linear');
    diff_reg_bischange.fstat

    y = q.Max_QUIP_Change(q_idx);
    diff_reg_quipchange = regstats(y,X,'linear');
    diff_reg_quipchange.fstat

    y = q.Case__Yes_No_(q_idx);
    diff_reg_case = regstats(y,X,'linear');
    diff_reg_case.fstat

    y = q.Max_CarerEQ_Change(q_idx);
    diff_reg_carereq = regstats(y,X,'linear')
    diff_reg_carereq.fstat

    y = q.Max_EQ_change(q_idx);
    diff_reg_eq = regstats(y,X,'linear')
    diff_reg_eq
    
keyboard
end

keyboard