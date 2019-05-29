function behavioral_data_analyses(stats)

%% Correlation BIS and BDI
for i = 1:2
    [rho(i) p_0(i)]= corr(stats{i}.BIS_Total', stats{i}.BDI_Total');
    if i == 1
        fprintf('Pre DBS Corr, BIS and BDI: %0.2f (p=%0.3f)',rho(i),p_0(i));
    else
        fprintf('Post DBS Corr, BIS and BDI: %0.2f (p=%0.3f)',rho(i),p_0(i));
    end
end

%% Correlation, QUIP and LEDD
for i = 1:2
    [rho(i) p_0(i)]= corr(stats{i}.QUIP_Total', stats{i}.LEDD');
    if i == 1
        fprintf('Pre DBS Corr, QUIP and LEDD: %0.2f (p=%0.3f)',rho(i),p_0(i));
    else
        fprintf('Post DBS Corr, QUIP and LEDD: %0.2f (p=%0.3f)',rho(i),p_0(i));
    end
end

%% Correlation, other measures of impulsivity and LEDD
fields = {'ELF_RuleViolations','Hayling_ABErrorScore','DelayDiscount_K'};
for f = 1:numel(fields)
    for i = 1:2
        [rho(i) p_0(i)]= corr(stats{i}.(fields{f})', stats{i}.LEDD');
        if i == 1
            fprintf('Pre DBS Corr, %s and LEDD: %0.2f (p=%0.3f)\n',fields{f},rho(i),p_0(i));
        else
            fprintf('Post DBS Corr, %s and LEDD: %0.2f (p=%0.3f)\n',fields{f},rho(i),p_0(i));
        end
    end
end

%% Ttest differences, behavior

fprintf('Test pre-post differences in questionnaires\n');
fields = {'B_mean','cashoutPct','switchPct','gamblePct'};
for f = 1:length(fields)
    pre = stats{1}.behavior.(fields{f})';
    post = stats{2}.behavior.(fields{f})';
    [h(f) p_1(f)] = ttest(pre, post)
end
[corr_p] = bonf_holm(p_1)

%% Table 2 Section 1: Ttest differences, questionnaires
% BIS, subscales, EQ, QUIP

fprintf('Test pre-post differences in questionnaires\n');
fields = {'BIS_Total','BIS_Motor','BIS_Attentional','BIS_NonPlanning'}
% fields = {'BIS'};
for f = 1:length(fields)
    pre = stats{1}.(fields{f})';
    post = stats{2}.(fields{f})';
    [h(f) p_2(f)] = ttest(pre, post)
end
[corr_p] = bonf_holm(p_2)

%% Table 2 Section 2: 
fprintf('Test pre-post differences in impulsivity tasks\n');
fields = {'ELF_RuleViolations','Hayling_ABErrorScore','DelayDiscount_K'};

for f = 1:length(fields)
    pre = stats{1}.(fields{f})';
    post = stats{2}.(fields{f})';
    x1 = [repmat('a',38,1);repmat('b',38,1)];
    x2 = [pre;post];
    [tbl,chistat(f),p_2(f)] = crosstab(x1,x2);
end

[corr_p] = bonf_holm(p_2)


%% Supplementary Table 2:

fprintf('Test pre-post differences\n');
fields = {'BIS_Attentional','BIS_NonPlanning','BIS_Motor','Apathy_Total'}
for f = 1:length(fields)
    pre = stats{1}.(fields{f})';
    post = stats{2}.(fields{f})';
    [h(f) p_3(f)] = ttest(pre, post);
    fprintf('Test %s: p=%0.5f\n', fields{f}, p_3(f));
end
[corr_p,h] = bonf_holm(p_3);


%% Supplementary Table 3:

fprintf('Test pre-post differences\n');
fields = {'B_mean','switchPct','gamblePct'};
for f = 1:length(fields)
    pre = stats{1}.behavior.(fields{f})';
    post = stats{2}.behavior.(fields{f})';
    [h(f) p_4(f)] = ttest(pre, post);
    fprintf('Test %s: p=%0.5f\n', fields{f}, p_4(f));
end
[corr_p,h] = bonf_holm(p_4);
