function behavioral_data_analyses(stats, D, plot_flag, fp)

n = 2;
n = n + 1;
if nargin < n
    plot_flag = 0;
end

n = n + 1;
if nargin < n
    fp = 1;
end

%% BIS and BDI

fprintf(fp, 'Correlation of BIS and BID\n');
for s = 1:2
    [h(s) p(s)]= corr(stats{s}.BIS',stats{s}.BDI');
    fprintf(fp, 'Session %d: r2 %0.2f p %0.3f\n', s, h(s), p(s));
end

fprintf(fp, 'Correlation of BIS and LED\n');
for s = 1:2
    [h(s) p(s)]= corr(stats{s}.BIS',stats{s}.LEDD');
    fprintf(fp, 'Session %d: r2 %0.3f p %0.3f\n', s, h(s), p(s));
end


fprintf(fp, 'Correlation of QUIP and LEDD\n');
for s = 1:2
    [h(s) p(s)]= corr(stats{s}.QUIP',stats{s}.LEDD');
    fprintf(fp, 'Session %d: r2 %0.2f p %0.5f\n', s, h(s), p(s));
end

%% Ttest differences, questionnaires
% BIS, subscales, EQ, QUIP

fprintf(fp, 'Test pre-post differences\n');
fields = {'BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional',...
    'BDI','QUIP','LEDD'};
for f = 1:length(fields)
    pre = stats{1}.(fields{f})';
    post = stats{2}.(fields{f})';
    [h(f) p(f) ci tstat] = ttest(pre, post);
    fprintf('Test %s: p=%0.5f\n', fields{f}, p(f));
    display(tstat)
end

%% Ttest differences in slot machine behavior, pre and post

fprintf(fp, 'Test differences in slot machine\n')
fields = {'bets';'machine_switches';'gamble';};
% Gamble = Double up
for f = 1:length(fields)
    pre = stats{1}.(fields{f});
    post = stats{2}.(fields{f});
    [h(f) p(f) ci tstat] = ttest(pre, post);
    fprintf(fp, 'Test %s: p=%0.3f\n', fields{f}, p(f));
    display(tstat)
end


end
