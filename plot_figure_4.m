function plot_figure_4(fname, stats)
%% Scatter plots
figure(1)
clf
msize = 800

[h_omega, p_omega] = ttest(stats{1}.omega, stats{2}.omega);
[h_beta, p_beta] = ttest(stats{1}.beta,stats{2}.beta);
[h_bis, p_bis] = ttest(stats{1}.BIS_Total,stats{2}.BIS_Total);

subplot(3,4,1);
hold on
h = boxplot([stats{1}.omega, stats{2}.omega],'Symbol','k.');
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

subplot(3,4,2);
hold on
h = boxplot([stats{1}.beta,stats{2}.beta],'Symbol','k.');
g = findobj(gca,'Tag','Box');
patch(get(g(2),'XData'),get(g(2),'YData'),[102 170 215]/255);
patch(get(g(1),'XData'),get(g(1),'YData'),[230 151 116]/255);
set(h([1:6 8:end]),'Color',[50 50 50]/255,'LineStyle','-','LineWidth',1.5)
set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
set(gca,'children',flipud(get(gca,'children')))
if p_omega<0.05
    sigstar({{'Pre','Post'}},p_beta);
end
title('\beta')

subplot(3,4,3);
hold on

h = boxplot([stats{1}.BIS_Total' stats{2}.BIS_Total'],'Symbol','k.');
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

subplot(3,4,4);
hold on
h = boxplot([stats{1}.LEDD' stats{2}.LEDD'],'Symbol','k.');
g = findobj(gca,'Tag','Box');
patch(get(g(2),'XData'),get(g(2),'YData'),[102 170 215]/255);
patch(get(g(1),'XData'),get(g(1),'YData'),[230 151 116]/255);
set(h,'Color',[50 50 50]/255,'LineStyle','-','LineWidth',1.5)
set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
set(gca,'children',flipud(get(gca,'children')))
if p_omega<0.05
    sigstar({{'Pre','Post'}},p_bis);
end
title('LEDD')


subplot(3,4,5)
scatter(stats{1}.BIS_Total, stats{1}.omega, msize,'Marker','.')
ylim([-9 -4.5])
ylabel('\omega_{pre-DBS}')
xlabel('BIS pre-DBS')


subplot(3,4,6)
scatter(stats{1}.BIS_Total, stats{1}.beta, msize, 'Marker','.')
ylim([0 15])
ylabel('\beta_{pre-DBS}')
xlabel('BIS pre-DBS')

subplot(3,4,7)
scatter(stats{1}.BIS_MaxIncrease,stats{2}.omega-stats{1}.omega,msize,[0.5 0.5 0.5],...
    'Marker','.')
ylabel('\Delta\omega')
xlabel('Max BIS Increase')

subplot(3,4,8)
scatter(stats{1}.LEDD_MaxDecrease,stats{2}.omega-stats{1}.omega,msize, [0.5 0.5 0.5],...
    'Marker','.')
ylabel('\Delta\omega')
xlabel('Max LEDD Decrease')

subplot(3,4,9)
scatter(stats{2}.BIS_Total,stats{2}.omega, msize,[232 152 117]/255, 'Marker','.')
ylim([-9 -4.5])
ylabel('\omega_{post-DBS}')

xlabel('BIS post-DBS')


subplot(3,4,10)
scatter(stats{2}.BIS_Total, stats{2}.beta,msize, [232 152 117]/255,'Marker','.')
xlabel('BIS post-DBS')
ylim([0 15])
ylabel('\beta_{post-DBS}')

subplot(3,4,11)
scatter(stats{1}.BIS_MaxIncrease, stats{2}.beta-stats{1}.beta,msize,[0.3 0.3 0.3],...
    'Marker','.')
xlabel('Max BIS Increase')
ylabel('\Delta\beta')

subplot(3,4,12)
scatter(stats{1}.LEDD_MaxDecrease, stats{2}.beta-stats{1}.beta,msize,[0.3 0.3 0.3],...
    'Marker','.')
xlabel('Max LEDD Decrease')
ylabel('\Delta\beta')

%purty_plot(1,['./BIS_parameter_relatonships_Rev2Pt1'],'tiff')
purty_plot(1,fname,'png')