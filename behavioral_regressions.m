function behavioral_regressions(stats)
% Runs results shown in Table 3

%% Define fields of interest
fields = {'BIS' ,'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};

%% Run behavioral regressions, pre and post
fields = {'BIS_Total' ,'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};

for s = 1:2
    if s == 1
        fprintf(1, '\n%s\n\n\n', 'PRE-DBS regressions');
    else
        fprintf(1, '\n%s\n\n\n', 'POST-DBS regressions');
    end
    
    % Behavioral regressions
    for f = 1:length(fields)
        
        X = [stats{s}.behavior.B_mean' stats{s}.behavior.switchPct'...
            stats{s}.behavior.gamblePct', stats{s}.BDI_Total'];
        
        y = stats{s}.(fields{f})';
        r = regstats(y, X, 'linear');
        r.y = y;
        r.X = X;
        if s == 1
            title = 'Behav PRE-DBS';
        else
            title = 'Behav POST-DBS';
        end
        
        %all_p_t(f,:) = r.tstat.pval(2:end-1)';
        
        %reg_vals(r)
        reg_vals(r, title, fields{f},{'bets','ms','gamble','BDI'});
        
%         if any(r.cookd>1)
%             keyboard
%         end
        
    end
end


%% Run behavioral regressions, pre to post
fields = {'LEDD_MaxDecrease'};
X = [stats{2}.behavior.B_mean'-stats{1}.behavior.B_mean'...
    stats{2}.behavior.switchPct'-stats{1}.behavior.switchPct'...
    stats{2}.behavior.gamblePct'- stats{1}.behavior.gamblePct'...
    stats{2}.BDI_Total'-stats{1}.BDI_Total'];

%y = stats{2}.BIS'-stats{1}.BIS';
y = stats{1}.BIS_MaxIncrease;
r = regstats(y, X, 'linear');
r.y = y;
r.X = X;

title = 'BIS change with behavior change';
reg_vals(r, title,fields{1}, {'Bets','MS','Gamble','BDI'});

