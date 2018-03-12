function behavioral_data_analyses(stats, D)

%% Correlation of BIS and task impulsivity
for s = 1:2
    f1 = {'HaylingA';'HaylingABError';'ELF';'Discount'};
    f2 = {'BIS_NonPlanning','BIS_Motor','BIS_Attentional'};
    
    for i = 1:4
        for j = 1:3
            [r(i,j,s) p(i,j,s)] = corr(stats{s}.(f1{i})', stats{s}.(f2{j})');
        end
    end
end

%% Behavior across timepoints (legacy figure)

quest = {'BIS','QUIP','Apathy','BDI','EQ','Anxiety','UPDRS','LEDD','ELF','Hayling','Discount'};
timepoints = {'Pre';'FU1';'FU2';'FU3';'FU4'};

% Load time data
quest_data = {};
A = {};
for i = 1:numel(quest)
    filename = [D.SPREADSHEET_DIR quest{i} '_Timepoints.xlsx'];
    A.data = xlsread(filename);
    quest_data.(quest{i}) = A;
end

% Construct figure
figure(102)
for i = 1:numel(quest)
    
    subplot(3,4,i)
    h = boxplot(quest_data.(quest{i}).data, 'Symbol','k.');
    g = findobj(gca,'Tag','Box');
    for j = 1:5
        patch(get(g(j),'XData'),get(g(j),'YData'),[0.7 0.7 0.7]);
    end
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    set(gca,'children',flipud(get(gca,'children')))
    set(gca,'XTickLabels',{'Pre';'FU1';'FU2';'FU3';'FU4'});
    
    for k = 2:5
        
        [h p] = ttest(quest_data.(quest{i}).data(:,1),quest_data.(quest{i}).data(:,k));
        if p<0.05
            sigstar({{'Pre',timepoints{k}}},p);
        end
    end

    title(quest{i});
end

purty_plot(102,[D.FIGURES_DIR 'behavior_timepoints'],'pdf')


%% BIS and BDI

for s = 1:2
    [h(s) p(s)]= corr(stats{s}.BIS',stats{s}.BDI');
end


%% Ttest differences, questionnaires
% BIS, subscales, EQ, QUIP

fields = {'BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional',...
    'BDI','QUIP','LEDD'};
for f = 1:length(fields)
    pre = stats{1}.(fields{f})';
    post = stats{2}.(fields{f})';
    [h(f) p(f) ci tstat] = ttest(pre,post);
end

plot_names = {'BIS','BIS NonPlanning','BIS Motor','BIS Attentional',...
    'BDI','QUIP','LEDD'};
figure(101)
for f = 1:4
    subplot(1,4,f);
    h = boxplot([stats{1}.(fields{f})' stats{2}.(fields{f})'], 'Symbol','k.');
    g = findobj(gca,'Tag','Box');
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    if f == 1
        set(h(7),'Color','w');
        set(h(14),'Color','w');
    end
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    
    
    if p(f)<0.05
        sigstar({{'Pre','Post'}},p(f));
    end
    title(plot_names{f});
    
end

purty_plot(101,[D.FIGURES_DIR 'questionnaire_behavior1'],'eps')

figure(102)
for f = 5:7
    subplot(1,3,f-4);
    h = boxplot([stats{1}.(fields{f})' stats{2}.(fields{f})'], 'Symbol','k.');
    g = findobj(gca,'Tag','Box');
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    if f == 1
        set(h(7),'Color','w');
        set(h(14),'Color','w');
    end
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    
    
    if p(f)<0.05
        sigstar({{'Pre','Post'}},p(f));
    end
    title(plot_names{f});
    
end


purty_plot(102,[D.FIGURES_DIR 'questionnaire_behavior2'],'pdf')

%% Ttest differences in slot machine behavior, pre and post

fields = {'bets';'machine_switches';'gamble';};
for f = 1:length(fields)
    pre = stats{1}.(fields{f});
    post = stats{2}.(fields{f});
    [h(f) p(f) ci tstat] = ttest(pre,post);
    
end

%% Plots of slot machine behavior

plot_names = {'Bets';'Machine switches';'Gamble'};
figure(101)
for f = 1:length(fields)
    subplot(1,3,f);
    h = boxplot([stats{1}.(fields{f}),stats{2}.(fields{f})], 'Symbol','k.');
    g = findobj(gca,'Tag','Box');
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    if f == 1
        set(h(7),'Color','w');
        set(h(14),'Color','w');
    end
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    
    
    if p(f)<0.05
        sigstar({{'Pre','Post'}},p(f));
    end
    title(plot_names{f});
    
end

purty_plot(101,[D.FIGURES_DIR 'slot_behavior'],'pdf')

