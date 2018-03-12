function pd_subgroups(stats,D)
%% Check for different model
% for s = 1:2
%     for i = 1:length(stats{1}.labels)
%         if stats{s}.llh(i,1) > stats{s}.llh(i,2) 
%             winning_model(i,s) = 1;
%         elseif stats{s}.llh(i,2) > stats{s}.llh(i,1) 
%             winning_model(i,s) = 2;
%         end
%     end
% end

% diff_model = winning_model(:,2) - winning_model(:,1);

bis_change = sign(stats{2}.BIS'-stats{1}.BIS');
bis_idx{1} = find(stats{1}.BIS_MaxIncrease>=0);
bis_idx{2} = find(stats{1}.BIS_MaxIncrease<0);   
%%
% subplot(2,2,1)
% boxplot(log([stats{1}.omega(bis_i) stats{2}.omega(bis_i)]));
% subplot(2,2,2)
% boxplot([stats{1}.theta(bis_i) stats{2}.theta(bis_i)]); 
% subplot(2,2,3)
% boxplot([stats{1}.omega(bis_d) stats{2}.omega(bis_d)]);
% subplot(2,2,4)
% boxplot([stats{1}.theta(bis_d) stats{2}.theta(bis_d)]); 

%%
for b = 1:2
    [h  p] = ttest(stats{1}.omega(bis_idx{b}),...
        stats{2}.omega(bis_idx{b}))
  
    for s = 1:2        
        r = regstats(stats{s}.BIS(bis_idx{b}),[stats{s}.omega(bis_idx{b})...
            stats{s}.theta(bis_idx{b})],'linear');
        r.fstat
        
    end
end

%% Parameter differences
omega_diff = stats{2}.omega - stats{1}.omega; 
theta_diff = stats{2}.theta - stats{1}.theta;
beta_diff = stats{2}.beta - stats{1}.beta;
ledd_diff = stats{2}.LEDD' - stats{1}.LEDD';
bdi_diff = stats{2}.BDI' - stats{1}.BDI';
%% Define fields of interest
fields = {'LEDD','BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional',...
    'EQ','QUIP','BIS_MaxIncrease','EQ_MaxDecrease','QUIP_MaxIncrease','HaylingA','HaylingABError',...
    'Hayling_MaxIncrease'};
%fields = {'LEDD','BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional'};


%% Run behavioral regressions, pre and post
depvar = {'omega';'theta';'beta'};
for s = 1:2
    if s == 1
        fprintf('\n%s\n\n\n',['PRE-DBS regressions']);
    else
        fprintf('\n%s\n\n\n',['POST-DBS regressions']);
    end
    X = [stats{s}.omega stats{s}.theta stats{s}.BDI' ];
    % Behavioral regressions
    for f = 1:length(fields)
        y = stats{s}.(fields{f})';
        r = regstats(y,X,'linear');
        r.y = y;
        r.X = X;
        if s == 1
            stage = 'Param PRE-DBS';
        else
            stage = 'Param POST-DBS';
        end

        reg_vals(r,stage,fields{f});
        if r.fstat.pval < 0.05
            filename = [D.REGRESSION_DIR 'Param_' stage '_' fields{f} '.csv'];
            reg_to_table(r,fields{f},depvar, filename,1)
        end

        if contains(fields{f},'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = stats{2}.(fields{f})-stats{1}.(fields{f});
        end
    end
end

%% Run behavioral regressions, pre versus post
X = [omega_diff theta_diff];
depvar = {'omega_diff';'theta_diff';'beta_diff'};
stage = ' Param Diff';
fprintf('\n%s\n\n','Parameter differences and questionnaire differences');
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    reg_vals(r,stage,fields{f});
    if r.fstat.pval < 0.05
        filename = [D.REGRESSION_DIR 'Param_' stage '_' fields{f} '.csv'];
        reg_to_table(r,fields{f},depvar, filename,1)
    end
end

% %% Parameter diff predicting final value
% fprintf('\n%s\n\n','Parameter differences predicting FU3 values');
% X = [omega_diff theta_diff beta_diff];
% stage = 'Param Diff-to-Final';
% for f = 1:length(fields)
%     y = stats{2}.(fields{f});
%     r = regstats(y,X,'linear');
%     r.y = y;
%     r.X = X;
%     reg_vals(r,stage,fields{f});
%     if r.fstat.pval < 0.05
%         filename = [D.REGRESSION_DIR 'Param_' stage '_' fields{f} '.csv'];
%         reg_to_table(r,fields{f},depvar, filename,1)
%     end
% end

%% Pre predicting change
fprintf('\n%s\n\n','PRE-DBS predicting differences');
depvar = {'omega';'theta';'beta'};
X = [stats{1}.omega stats{1}.theta stats{1}.BDI']; 

stage = 'Param Pre-to-Change';
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    reg_vals(r,stage,fields{f});
end

y = stats{1}.Signif_Psych';
[b,dev,logit_stats] =  glmfit(X,y,'binomial','link','logit');
logit_stats.p

%% Pre predicting post
fprintf('\n%s\n\n','PRE-DBS predicting differences');
depvar = {'omega';'theta';'beta'};
X = [stats{1}.omega stats{1}.theta stats{1}.BDI']; 

stage = 'Param Pre-to-Post';
for f = 1:length(fields)
    y = stats{2}.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    reg_vals(r,stage,fields{f});
    if r.fstat.pval < 0.05
        filename = [D.REGRESSION_DIR 'Param' stage '_' fields{f} '.csv'];
        reg_to_table(r,fields{f},depvar, filename,1)
    end
end

y = stats{1}.Signif_Psych';
[b,dev,logit_stats] =  glmfit(X,y,'binomial','link','logit');
logit_stats.p


