function plot_figure_4(fname, stats)
%% Scatter plots
figure(1)
clf
msize = 800

[h_omega, p_omega] = ttest(stats{1}.omega, stats{2}.omega);
[h_beta, p_beta] = ttest(stats{1}.beta,stats{2}.beta);
[h_bis, p_bis] = ttest(stats{1}.BIS_Total,stats{2}.BIS_Total);

subplot(3,3,1);
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

subplot(3,3,2);
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

subplot(3,3,3);
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


subplot(3,3,4)
scatter(stats{1}.BIS_Total, stats{1}.omega, msize,'Marker','.')
ylabel('\omega_{pre-DBS}')

subplot(3,3,5)
scatter(stats{2}.BIS_Total,stats{2}.omega, msize,[232 152 117]/255, 'Marker','.')
ylabel('\omega_{post-DBS}')

subplot(3,3,6)
scatter(stats{1}.BIS_MaxIncrease,stats{1}.omega,msize, 'Marker','.')
ylabel('\omega_{pre-DBS}')

subplot(3,3,7)
scatter(stats{1}.BIS_Total, stats{1}.beta, msize, 'Marker','.')
ylabel('\beta_{pre-DBS}')
xlabel('BIS pre-DBS')


subplot(3,3,8)
scatter(stats{2}.BIS_Total, stats{2}.beta,msize, [232 152 117]/255,'Marker','.')
xlabel('BIS post-DBS')
ylabel('\beta_{post-DBS}')

subplot(3,3,9)
scatter(stats{1}.BIS_MaxIncrease, stats{1}.beta,msize, 'Marker','.')
xlabel('Max BIS Increase')
ylabel('\beta_{pre-DBS}')

%purty_plot(1,['./BIS_parameter_relatonships_Rev2Pt1'],'tiff')
purty_plot(1,fname,'png')