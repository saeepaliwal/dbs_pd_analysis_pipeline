function parameter_regressions(stats)
close all
 % This function prints the results reported in Table 5 of the manuscript


%% Run parameter regressions, pre and post
fields = {'BIS','UPDRS','ICD'};
for s = 1:2

    if s == 1
        fprintf('\n%s\n\n\n',['PRE-DBS regressions']);
    else
        fprintf('\n%s\n\n\n',['POST-DBS regressions']);
    end

    % Behavioral regressions
    for f = 1:length(fields)

        if strcmp(fields{f},'UPDRS')
            X = [stats{s}.omega stats{s}.beta];
            indep_vars = {'omega';'beta'};
        else
            X = [stats{s}.omega stats{s}.beta stats{s}.BDI'];
            indep_vars = {'omega';'beta';'BDI';'st'};
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

        reg_vals(r,stage,fields{f},indep_vars);
        reg_figs(r,y,X,fields{f}, indep_vars)


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

fields = {'BIS_MaxIncrease','ICD_MaxIncrease', 'UPDRS_MaxDecrease'};


stage = 'Param Pre';
for f = 1:length(fields)

    X = [stats{1}.omega stats{1}.beta stats{1}.BDI'];

    y = stats{2}.(fields{f}); % It's the same in stats{1} and stats{2}
    %y = stats{2}.BIS-stats{1}.BIS;
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    all_p(f) = r.fstat.pval;

    reg_vals(r,stage,fields{f},{'omega';'beta';'BDI';'st'})
    
    %reg_figs(r,y,X, fields{f},{'omega';'beta';'BDI'});

end

%% LEDD Change

stage = 'Param Change';
X = [stats{2}.omega-stats{1}.omega stats{2}.beta-stats{1}.beta];
%y = stats{2}.LEDD - stats{1}.LEDD;
y = stats{2}.LEDD_MaxDecrease;
r = regstats(y,X,'linear');
r.y = y;
r.X = X;
%all_p(f) = r.fstat.pval;

reg_vals(r,stage,'LEDD Change',{'\Delta\omega';'\Delta\beta'})
reg_figs(r,y,X,'LEDD Change', {'\Delta\omega';'\Delta\beta'})


%
% %% LEDD regressions
%
% for s = 1:2
%     X = stats{s}.LEDD';
%     y = stats{s}.BIS';
%
%     r = regstats(y,X,'linear');
%     r.y = y;
%     r.X = X;
%
%     if s == 1
%         stage = 'LEDD PRE-DBS';
%     else
%         stage = 'LEDD POST-DBS';
%     end
%     reg_vals(r,stage,'BIS',{'LEDD'})
% end
%
% % Change in LEDD
%
% X = stats{2}.LEDD' - stats{1}.LEDD';
% y = stats{2}.BIS'-stats{1}.BIS';
%
% r = regstats(y,X,'linear');
% r.y = y;
% r.X = X;
% all_p(f) = r.fstat.pval;
%
% reg_vals(r,stage,'Change in BIS',{'LEDD'})
%
%
%
% % Change in LEDD
%
% X = stats{2}.LEDD' - stats{1}.LEDD';
% y = stats{1}.BIS_MaxIncrease;
%
% r = regstats(y,X,'linear');
% r.y = y;
% r.X = X;
% all_p(f) = r.fstat.pval;
%
% reg_vals(r,stage,'Max BIS Increase',{'LEDD'})
