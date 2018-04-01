function parameter_regressions(stats)
 % This function prints the results reported in Table 5 of the manuscript
%% Define fields of interest
fields = {'BIS';'BIS_Attentional';'BIS_NonPlanning';'BIS_Motor'}

%% Define fields of interest
fields = {'BIS', 'BIS_Attentional', 'BIS_Motor', 'BIS_NonPlanning'};

%% Run behavioral regressions, pre and post
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

        if contains(fields{f}, 'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = ...
                stats{2}.(fields{f}) - stats{1}.(fields{f});
        end
    end
end

%% Pre predicting max  change
fprintf('\n%s\n\n','PRE-DBS predicting max diff');
depvar = {'omega';'theta';'beta'};
fields = {'BIS_MaxIncrease'};
X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI']; 
stage = 'Param Pre';
for f = 1:length(fields)
    y = stats{1}.(fields{f}); % It's the same in stats{1} and stats{2}
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;
    reg_vals(r,stage,fields{f});
end
