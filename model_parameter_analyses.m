function model_parameter_analyses(stats, D)
% Calculates the reuslts shown in Table 4 and prints Figure 3
fields = {'BIS';'BIS_Attentional';'BIS_NonPlanning';'BIS_Motor'};

%% Distribution characteristics, pre and post model parameters
for p  = {'omega','theta','beta'}
    for i = 1:2
        fprintf('%s%d -- Mean: %0.3f (%0.3f, %0.3f-%0.3f)\n',p{:},i,mean(log(stats{i}.(p{:}))), ...
        std(log(stats{i}.(p{:}))),min(log(stats{i}.(p{:}))), max(log(stats{i}.(p{:}))))
    end
end

%% T Test on pre and post model parameters
display_figure = 1;
if display_figure
    [h_omega, p_omega] = ttest(log(stats{1}.omega),log(stats{2}.omega));
    [h_theta, p_theta] = ttest(log(stats{1}.theta),log(stats{2}.theta));
    [h_beta, p_beta] = ttest(stats{1}.beta,stats{2}.beta);
    [h_bis, p_bis] = ttest(stats{1}.BIS,stats{2}.BIS);
    figure(301)
    clf
    subplot(1,3,1);
    hold on
    h = boxplot([log(stats{1}.omega),log(stats{2}.omega)],'Symbol','k.');
    g = findobj(gca,'Tag','Box'); 
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    if p_omega<0.05
        sigstar({{'Pre','Post'}},p_omega);
    end
    title('\omega')
    
    subplot(1,3,2);
    h = boxplot([log(stats{1}.theta),log(stats{2}.theta)],'Symbol','k.');
    
    g = findobj(gca,'Tag','Box'); 
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h([1:6 8:end]),'Color','k','LineStyle','-','LineWidth',1)
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))

    if p_theta<0.05
        sigstar({{'Pre','Post'}},p_theta);
    end
    title('\vartheta')

    subplot(1,3,3);
    h = boxplot([stats{1}.beta,stats{2}.beta],'Symbol','k.');
    g = findobj(gca,'Tag','Box'); 
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    set(h(14),'Color','w')
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    if p_beta<0.05
        sigstar({{'Pre','Post'}},p_beta);
    end
    title('\beta')
    
    
    purty_plot(301,[D.FIGURES_DIR 'model_pars'],'pdf')
end

%% Model comparison figure
grey = [0.7 0.7 0.7];
figure(101)
clf
hold on

b=bar([stats{1}.FE_grid], ...
    'FaceColor',grey,'EdgeColor','none');
%title('Group-level free energy, pre-DBS');
xticks(1:3);
xticklabels({'Std';'UD';'RW'});
ylim([-1942 -1935])
% set(gca,'YTick',[-1946 -1944 -1942 -1940 -1938 -1936],...
%     'YTickLabels',{'-2700';'-1944';'-1942';'-1940';'-1938';'-1936'});
% plot([0.5 0.65], [-1945 -1944.8],'k','LineWidth',2);
% plot([0.5 0.65], [-1944.8 -1944.6],'k','LineWidth',2);
ylabel('Free energy')
purty_plot(101,[D.FIGURES_DIR 'model_comparison'],'tiff')

%% Scatter plots
figure(1)
clf
msize = 800

subplot(3,3,1);
hold on
h = boxplot([log(stats{1}.omega),log(stats{2}.omega)],'Symbol','k.');
g = findobj(gca,'Tag','Box');
patch(get(g(2),'XData'),get(g(2),'YData'),[102 170 215]/255);
patch(get(g(1),'XData'),get(g(1),'YData'),[230 151 116]/255);
set(h,'Color',[50 50 50]/255,'LineStyle','-','LineWidth',1.5)
set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
set(gca,'children',flipud(get(gca,'children')))
if p_omega<0.05
    sigstar({{'Pre','Post'}},p_omega);
end
title('\omega')

subplot(3,3,2);
hold on
h = boxplot([log(stats{1}.theta),log(stats{2}.theta)],'Symbol','k.');
g = findobj(gca,'Tag','Box');
patch(get(g(2),'XData'),get(g(2),'YData'),[102 170 215]/255);
patch(get(g(1),'XData'),get(g(1),'YData'),[230 151 116]/255);
set(h([1:6 8:end]),'Color',[50 50 50]/255,'LineStyle','-','LineWidth',1.5)
set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
set(gca,'children',flipud(get(gca,'children')))
if p_omega<0.05
    sigstar({{'Pre','Post'}},p_theta);
end
title('\vartheta')

subplot(3,3,3);
hold on

h = boxplot([stats{1}.BIS' stats{2}.BIS'],'Symbol','k.');
g = findobj(gca,'Tag','Box');
patch(get(g(2),'XData'),get(g(2),'YData'),[102 170 215]/255);
patch(get(g(1),'XData'),get(g(1),'YData'),[230 151 116]/255);
set(h,'Color',[50 50 50]/255,'LineStyle','-','LineWidth',1.5)
set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
set(gca,'children',flipud(get(gca,'children')))
if p_omega<0.05
    sigstar({{'Pre','Post'}},p_bis);
end
title('BIS')


subplot(3,3,4)
scatter(stats{1}.BIS,log(stats{1}.omega), msize,'Marker','.')
ylabel('\omega_{pre-DBS}')

subplot(3,3,5)
scatter(stats{2}.BIS,log(stats{2}.omega), msize,[232 152 117]/255, 'Marker','.')
ylabel('\omega_{post-DBS}')

subplot(3,3,6)
scatter(stats{1}.BIS_MaxIncrease,log(stats{1}.omega),msize, 'Marker','.')
ylabel('\omega_{pre-DBS}')

subplot(3,3,7)
scatter(stats{1}.BIS,log(stats{1}.theta), msize, 'Marker','.')
ylabel('\vartheta_{pre-DBS}')
xlabel('BIS pre-DBS')


subplot(3,3,8)
scatter(stats{2}.BIS,log(stats{2}.theta),msize, [232 152 117]/255,'Marker','.')
xlabel('BIS post-DBS')
ylabel('\vartheta_{post-DBS}')

subplot(3,3,9)
scatter(stats{1}.BIS_MaxIncrease, log(stats{1}.theta),msize, 'Marker','.')
xlabel('Max BIS Increase')
ylabel('\vartheta_{pre-DBS}')

purty_plot(1,['./BIS_parameter_relatonships_Rev2Pt1'],'tiff')

end    
