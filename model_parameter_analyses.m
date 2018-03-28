function model_result_analyses(stats, D)

%% T Test on pre and post model parameters
display_figure = 0;
if display_figure
    [h_omega, p_omega] = ttest(log(stats{1}.omega),log(stats{2}.omega));
    [h_theta, p_theta] = ttest(log(stats{1}.theta),log(stats{2}.theta));
    [h_beta, p_beta] = ttest(stats{1}.beta,stats{2}.beta);
    %[h_lr, p_lr] = ttest(stats{1}.learning_rate,stats{2}.learning_rate);
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

bar([stats{1}.FE_grid([1 2]) -1947], ...
    'FaceColor',grey,'EdgeColor','k');
title('Group-level free energy, pre-DBS');
xticks(1:3);
xticklabels({'Std';'UD';'RW'});
ylim([-1948 -1935])
set(gca,'YTick',[-1946 -1944 -1942 -1940 -1938 -1936],...
    'YTickLabels',{'-2700';'-1944';'-1942';'-1940';'-1938';'-1936'});
plot([0.5 0.65], [-1945 -1944.8],'k','LineWidth',2);
plot([0.5 0.65], [-1944.8 -1944.6],'k','LineWidth',2);
ylabel('Free energy')
purty_plot(101,[D.FIGURES_DIR 'model_comparison'],'tiff')


end    
