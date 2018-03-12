function behavioral_regressions(stats)

%% Define fields of interest
fields = {'BIS' ,'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};
%fields = {'QUIP'};

%% Pull out behavioral data

for s = 1:2
    data.bets(:,s) = stats{s}.bets;
    data.machine_switches(:,s) = stats{s}.machine_switches
    data.gamble(:,s) = stats{s}.gamble;
    data.cashout(:,s) = stats{s}.cashout;
end


% Differences
data_fields = {'bets';'machine_switches';'gamble';'cashout'};
for d = 1:length(data_fields)
    new_field = [data_fields{d} '_diff'];
    data.(new_field) = data.(data_fields{d})(:,2)-...
        data.(data_fields{d})(:,1);
end

%% BIS and BDI regression
for i = 1:2
    [rho(i) p(i)]= corr(stats{i}.BIS', stats{i}.BDI');
end
[r2 p2] = corr(stats{2}.BIS'-stats{1}.BIS', stats{2}.BDI'-stats{1}.BDI');

%% Run behavioral regressions, pre and post
depvar = {'Bets';'Machine Switches';'Gamble'};
for s = 1:2
    if s == 1
        fprintf('\n%s\n\n\n',['PRE-DBS regressions']);
    else
        fprintf('\n%s\n\n\n',['POST-DBS regressions']);
    end

    % Behavioral regressions
    for f = 1:length(fields)
        
        if strcmp(fields{f},'QUIP')
            X = [data.bets(:,s) data.machine_switches(:,s)...
                data.gamble(:,s) stats{1}.LEDD'];
        else
            X = [data.bets(:,s) data.machine_switches(:,s)...
                data.gamble(:,s) stats{s}.BDI'];
        end
        
        y = stats{s}.(fields{f})';
        r = regstats(y,X,'linear');
        r.y = y;
        r.X = X;
        if s == 1
            title = 'Behav PRE-DBS';

        else
            title = 'Behav POST-DBS';
        end
        
        all_p_f(f,s) = r.fstat.pval;
        all_p_t(f,:) = r.tstat.pval(2:end-1)';
        
        reg_vals(r,title,fields{f});
       if any(r.cookd>1)
            keyboard
        end
        if contains(fields{f},'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = stats{2}.(fields{f})-stats{1}.(fields{f});
        end
    end
    
    
    post_hoc_t = reshape(all_p_t',12,1);
    [corr_t] = bonf_holm(post_hoc_t);
end


%% Run behavioral regressions, pre versus post
X = [data.bets_diff data.machine_switches_diff ...
    data.gamble_diff];
title = 'Behav Diff';
fprintf('\n%s\n\n','Behavior differences and questionnaire differences');
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,title,fields{f});
    if any(r.cookd>1)
        keyboard
    end
    
end
[h crit_p adj_p]=fdr_bh(all_p);
clear all_p

%% Pre predicting change
fprintf('\n%s\n\n','PRE-DBS behavior predicting differences');
X = [data.bets(:,1) data.machine_switches(:,1)...
    data.gamble(:,1) stats{1}.BDI'];
title = 'Behav Pre-to-Change';
for f = 1:length(fields)
    y = longitudinal.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,title,fields{f});
    if r.cookd > 1
        keyboard
    end
end
[h crit_p adj_p]=fdr_bh(all_p);
clear all_p
%% Pre predicting Post
fprintf('\n%s\n\n','PRE-DBS behavior predicting FU3');
X = [data.bets(:,1) data.machine_switches(:,1)...
    data.gamble(:,1) stats{1}.BDI'];
fields = {'ELF_MaxIncrease'}
title = 'Behav Pre-to-Post';
for f = 1:length(fields)
    y = stats{2}.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,title,fields{f});
    if any(r.cookd>1)
        keyboard
    end
end
[h crit_p adj_p]=fdr_bh(all_p);


y = stats{2}.Signif_Psych';
[b,dev,logit_stats] =  glmfit(X,y,'binomial','link','logit');
logit_stats.p





