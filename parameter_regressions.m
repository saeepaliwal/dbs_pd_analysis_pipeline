function parameter_regressions(stats)

%% Parameter differences
omega_diff = log(stats{2}.omega) - log(stats{1}.omega); 
theta_diff = log(stats{2}.theta) - log(stats{1}.theta);
beta_diff = log(stats{2}.beta) - log(stats{1}.beta);

ledd_diff = stats{2}.LEDD' - stats{1}.LEDD';
bdi_diff = stats{2}.BDI' - stats{1}.BDI';

    
%% Define fields of interest
fields = {'BIS'}
  %  ,'BIS_Attentional','BIS_Motor','BIS_NonPlanning','QUIP','UPDRS'};

%% Run behavioral regressions, pre and post
depvar = {'omega';'theta';'beta'};
for s = 1:2
    if s == 1
        fprintf('\n%s\n\n\n',['PRE-DBS regressions']);
    else
        fprintf('\n%s\n\n\n',['POST-DBS regressions']);
    end
   
    % Behavioral regressions
    for f = 1:length(fields)
        
        if strcmp(fields{f},'QUIP')
            X = [log(stats{s}.omega) log(stats{s}.theta) stats{s}.LEDD'];
        else
            X = [log(stats{s}.omega) log(stats{s}.theta) stats{s}.BDI'];
        end
        

        y = stats{s}.(fields{f})';
        r = regstats(y,X,'linear');
        r.y = y;
        r.X = X;
        if s == 1
            stage = 'Param PRE-DBS';
        else
            stage = 'Param POST-DBS';
        end
        all_p(f,s) = r.fstat.pval;
        all_p_t(f,:) = r.tstat.pval(2:3);
        reg_vals(r,stage,fields{f});
%         if any(r.cookd > 1)
%             keyboard
%         end

        if contains(fields{f},'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = stats{2}.(fields{f})-stats{1}.(fields{f});
        end
    end
    
    [h crit_p adj_p]=fdr_bh(all_p(:,s));
end

clear all_p
% 
% %% Run behavioral regressions, pre predicting post
% X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI']; 
% stage = 'Pre predicting post';
% fprintf('\n%s\n\n','Pre parameters predicting post');
% for f = 1:length(fields)
%     y = stats{2}.(fields{f});
%     r = regstats(y,X,'linear');
%     r.y = y;
%     r.X = X;
%     all_p(f) = r.fstat.pval;
%     reg_vals(r,stage,fields{f});
%     if any(r.cookd > 1)
%         keyboard
%     end
% end
% 
% [h crit_p adj_p]=fdr_bh(all_p);
% clear all_p
%% Run behavioral regressions, change predicting change
fields = {'BIS'};
X = [omega_diff theta_diff];

stage = ' Param Diff';
fprintf('\n%s\n\n','Parameter differences and questionnaire differences');
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,stage,fields{f});
    if any(r.cookd > 1)
        keyboard
    end
end

[h crit_p adj_p]=fdr_bh(all_p);
clear all_p


%% Pre predicting change
fprintf('\n%s\n\n','PRE-DBS predicting differences');
depvar = {'omega';'theta';'beta'};
X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI']; 
stage = 'Param Pre';
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,stage,fields{f});

end
[h crit_p adj_p]=fdr_bh(all_p);
% 
% %% Run behavioral regressions, pre versus post
% fields = {'QUIP'};
% X = [omega_diff theta_diff ledd_diff];
% 
% depvar = {'omega_diff';'theta_diff';'beta_diff'};
% stage = ' Param Diff';
% fprintf('\n%s\n\n','Parameter differences and questionnaire differences');
% for f = 1:length(fields)
%     y = longitudinal.(fields{f});
%     r = regstats(y,X,'linear');
%     r.y = y;
%     r.X = X;
%     all_p(f) = r.fstat.pval;
%     reg_vals(r,stage,fields{f});
%     if any(r.cookd > 1)
%         keyboard
%     end
% end
% 
% [h crit_p adj_p]=fdr_bh(all_p);
% clear all_p

%% Pre predicting max  change
fprintf('\n%s\n\n','PRE-DBS predicting max diff');
depvar = {'omega';'theta';'beta'};
X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI']; 
fields = {'BIS_MaxIncrease'}; 
stage = 'Param Pre';
for f = 1:length(fields)
    y = stats{2}.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,stage,fields{f});

end
[h crit_p adj_p]=fdr_bh(all_p);
% y = stats{2}.Signif_Psych';
% [b,dev,logit_stats] =  glmfit(X,y,'binomial','link','logit');
% logit_stats.p



