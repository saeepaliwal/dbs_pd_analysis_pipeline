function parameter_regressions(stats)
 % This function prints the results reported in Table 5 of the manuscript
%% Define fields of interest
fields = {'BIS';'BIS_Attentional';'BIS_NonPlanning';'BIS_Motor'}

%% Run behavioral regressions, pre and post
% Table 
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

        if contains(fields{f},'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = stats{2}.(fields{f})-stats{1}.(fields{f});
        end
    end
    
    [h crit_p adj_p]=fdr_bh(all_p(:,s));
end


%% Pre predicting max BIS increase
fields = {'BIS_MaxIncrease'}; 
fprintf('\n%s\n\n','Table 5: PRE-DBS predicting max diff');
depvar = {'omega';'theta';'beta'};
X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI']; 
stage = 'Param Pre';
for f = 1:length(fields)
    y = stats{1}.(fields{f});
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,stage,fields{f});

end


