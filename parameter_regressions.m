function parameter_regressions(stats)
close all
% This function prints the results reported in Table 5 of the manuscript


%% Run parameter regressions, pre and post
fields = {'BIS_Total','BIS_NonPlanning','BIS_Motor','BIS_Attentional',...
    'BIS_MaxIncrease', 'LEDD'};

% fields = {'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};
for s = 1:2
    
    if s == 1
        fprintf('\n%s\n\n\n',['PRE-DBS regressions']);
    else
        fprintf('\n%s\n\n\n',['POST-DBS regressions']);
    end
    
    %for t = 1:2
    %fprintf('\n%s %d\n',['Subtype'], t);
    
    % Behavioral regressions
    for f = 1:length(fields)
        
        if strcmp(fields{f},'LEDD')
            X = [stats{s}.omega stats{s}.beta];
            indep_vars = {'omega';'beta'};
        else
            X = [stats{s}.omega stats{1}.beta stats{s}.BDI_Total'];
            indep_vars = {'omega','beta','BDI'};
        end
        
        y = stats{s}.(fields{f})';
        
        % subtype_index = stats{1}.subtype==t;
        % r = regstats(y(subtype_index),X(subtype_index,:),'linear');
        r = regstats(y,X,'linear');
        r.y = y;
        r.X = X;
        if s == 1
            stage = 'Param PRE-DBS';
        else
            stage = 'Param POST-DBS';
        end
        
        reg_vals(r,stage,fields{f},indep_vars);
        %reg_figs(r,y,X,fields{f}, indep_vars)
        
        
        if contains(fields{f}, 'Max')
            longitudinal.(fields{f}) = stats{2}.(fields{f});
        else
            longitudinal.(fields{f}) = ...
                stats{2}.(fields{f}) - stats{1}.(fields{f});
        end
    end
    %end
end

%% Pre predicting max increase
fprintf('\n%s\n\n','PRE-DBS predicting max diff');

fields = {'BIS_MaxIncrease', 'UPDRS_MaxDecrease'};

%fields = {'BIS_Total','BIS_NonPlanning','BIS_Motor','BIS_Attentional'};


% stage = 'Param Pre';
% for f = 1:length(fields)
%
%     for t = 1:2
%
%     X = [stats{1}.omega stats{1}.beta stats{1}.BDI_Total'];
%
%
%     %y = stats{2}.(fields{f}); % It's theysame in stats{1} and stats{2}
%     y = stats{2}.(fields{f})-stats{1}.(fields{f});
%
%     r = regstats(y,X,'linear');
%     r.y = y;
%     r.X = X;
%     all_p(f) = r.fstat.pval;
%
%     reg_vals(r,stage,fields{f},{'omega';'beta';'BDI'})
%
%     %reg_figs(r,y,X, fields{f},{'omega';'beta';'BDI'});
%
% end

%% LEDD Change

stage = 'Param Change';
X = [stats{1}.omega-stats{2}.omega stats{1}.beta-stats{2}.beta];
%y = stats{2}.LEDD - stats{1}.LEDD;
y = stats{2}.LEDD_MaxDecrease;
% y(16) = []
% X(16,:) = []
r = regstats(y,X,'linear');
r.y = y;
r.X = X;

reg_vals(r,stage,'LEDD Change',{'\Delta\omega';'\Delta\beta'})
reg_figs(r,y,X,'LEDD Change', {'\Delta\omega';'\Delta\beta'})

%%
stage = 'Param Change';
X = [stats{1}.omega-stats{2}.omega stats{1}.beta-stats{2}.beta stats{1}.BDI_Total'-stats{2}.BDI_Total'];
%y = stats{2}.LEDD - stats{1}.LEDD;
y = stats{2}.BIS_MaxIncrease;
r = regstats(y,X,'linear');
r.y = y;
r.X = X;

reg_vals(r,stage,'Max BIS Increase',{'\Delta\omega';'\Delta\beta'; 'BDI'})
reg_figs(r,y,X,'Max BIS Increase', {'\Delta\omega';'\Delta\beta';'BDI'})

%%
pre_post_BIS_change = stats{2}.BIS_Total-stats{1}.BIS_Total;
pre_post_LEDD_change = stats{2}.LEDD-stats{1}.LEDD;
[cc, p] = corrcoef(pre_post_BIS_change', pre_post_LEDD_change')


[cc, p] = corrcoef(stats{1}.BIS_MaxIncrease', stats{1}.LEDD_MaxDecrease')

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
