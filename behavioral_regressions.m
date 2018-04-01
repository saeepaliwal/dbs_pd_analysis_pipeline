function behavioral_regressions(stats)
% Runs results shown in Table 3


%% Define fields of interest
fields = {'BIS' ,'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};

%% Run behavioral regressions, pre and post
for s = 1:2
    if s == 1
        fprintf(1, '\n%s\n\n\n', 'PRE-DBS regressions');
    else
        fprintf(1, '\n%s\n\n\n', 'POST-DBS regressions');
    end

    % Behavioral regressions
    for f = 1:length(fields)
        
        X = [data.bets(:, s) data.machine_switches(:, s)...
                data.gamble(:, s) stats{s}.BDI'];
        
        y = stats{s}.(fields{f})';
        r = regstats(y, X, 'linear');
        r.y = y;
        r.X = X;
        if s == 1
            title = 'Behav PRE-DBS';
        else
            title = 'Behav POST-DBS';
        end

        all_p_t(f,:) = r.tstat.pval(2:end-1)';
        
        reg_vals(r, title, fields{f});

        if any(r.cookd>1)
            keyboard
        end

end

