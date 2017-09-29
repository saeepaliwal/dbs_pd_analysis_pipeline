function behavioral_regressions(exclude)
analysis = 'both';

%%
ANALYSES= {'PRE_DBS';'POST_DBS'};
load all_patients

bets = zeros(100,2,length(all_patients));
ms = zeros(length(all_patients),2);
gam = zeros(length(all_patients),2);
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
    ms(1:length(stats{1}.switchPct),k) = stats{1}.switchPct';
    gam(1:length(stats{1}.switchPct),k) = stats{1}.gamblePct';
end

for i = 1:length(all_patients)
    bet_mean_pre(i,:) = mean(bets(:,1,i));
    bet_var_pre(i,:) = var(bets(:,1,i));

    bet_mean_post(i,:) = mean(bets(:,2,i));
    bet_var_post(i,:) = var(bets(:,2,i));

    bet_mean_diff(i,:) = bet_mean_post(i) - bet_mean_pre(i);
    bet_var_diff(i,:) = bet_var_post(i) - bet_var_pre(i);
end

ms_diff = ms(:,2) - ms(:,1);
gam_diff = gam(:,2) - gam(:,1);

%% Load questionnaires
Q_STRUCT = '~/polybox/Projects/BreakspearCollab/results/questionnaire_struct.mat';
load(Q_STRUCT)

for i = 1:length(q.labels)
    out = regexp(q.labels(i),'\d*','Match');
    q_data(i) = str2double(out{:});
end

% Pull out excluded subjects
q_data = q_data(~ismember(q_data,exclude));
all_patients = all_patients(~ismember(all_patients,exclude));

[patient_list, q_idx, s_idx] = intersect(q_data,all_patients);

%% Anatomical regressions on behavior
if strcmp(analysis,'pre')
    fields = {'Pre_LEDD','Pre_CarerBIS_Total','Pre_BIS_Total','Pre_Hayling_ABErrorScore','Max_BIS_Change',...
        'Pre_ELF_RuleViolations','Case__Yes_No_','Pre_EQ_Total','Pre_CarerEQ_Total'};
    
    X = [bet_mean_pre ms(:,1) gam(:,1)];
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
    
    X = [bet_mean_post ms(:,2) gam(:,2) ];
    X = X(s_idx,:);
    
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end
   

elseif strcmp(analysis,'both')
    
    fields = {'LN_Max_HaylingABErrorScore_Change','Max_CarerBIS_Change','Max_BIS_Change','Max_QUIP_Change','Case__Yes_No_',...
        'Max_CarerEQ_Change','Max_EQ_Change'};
    
    X = [bet_mean_diff ms_diff gam_diff];
    X = X(s_idx,:);
   
    for f = 1:length(fields)
        y = q.(fields{f})(q_idx);
        reg_results{f} = regstats(y,X,'linear');
        display(sprintf('%s: %0.4f (%0.4f)',fields{f}, reg_results{f}.fstat.f,reg_results{f}.fstat.pval));
    end
    
end

keyboard


%% Behavioral correlations
% 
% bet = stats{1}.B_mean(s_idx);
% mswitch = stats{1}.switchPct(s_idx);
% gamble = stats{1}.gamblePct(s_idx);
% 
% % Bets
% [r,p] = corrcoef(bet,q.Pre_BIS_Total(q_idx))
% [r,p] = corrcoef(bet,q.Pre_CarerBIS_Total(q_idx))
% [r,p] = corrcoef(bet,q.Pre_LN_HaylingABErrorScore(q_idx))
% [r,p] = corrcoef(bet,q.Pre_LN_ELF_RuleViolations(q_idx))
% 
% 
% [r,p] = corrcoef(bet,q.Pre_ICD_Total(q_idx))
% 
% [r,p] = corrcoef(bet,q.Pre_QUIP_Total(q_idx))
% 








