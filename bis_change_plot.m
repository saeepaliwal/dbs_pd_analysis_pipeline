%% T Test on pre and post model 
fields = {'BIS';'BIS_Attentional';'BIS_NonPlanning';'BIS_Motor'};
figure(1);
for f = 1:numel(fields)
    field = fields{f};
    x1 = stats{1}.(field);
    x2 = x1+stats{1}.([field '_MaxIncrease']);
    [h p] = ttest(x1,x2);
    
    subplot(2,2,f);
    
    h = boxplot([x1' x2'],'Symbol','k.');
    g = findobj(gca,'Tag','Box'); 
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))
    
    if p<0.05
        sigstar({{'Pre','Post'}},p);
    end
    title(strrep(fields{f},'_',' '));
end


%% T Test on pre and post model 
fields = {'bets';'machine_switches';'gamble'};
field_names = {'Bets';'Machine Switches';'Double-up'};
figure(2)
for f = 1:numel(fields)
    field = fields{f};
    x1 = stats{1}.(field);
    x2 = stats{2}.(field);
    [h p] = ttest(x1,x2);
    
    subplot(1,3,f);
    
    h = boxplot([x1 x2],'Symbol','k.');
    g = findobj(gca,'Tag','Box'); 
    patch(get(g(2),'XData'),get(g(2),'YData'),'w');
    patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
    set(h,'Color','k','LineStyle','-','LineWidth',1)
    set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
    set(gca,'children',flipud(get(gca,'children')))

    
    if p<0.05
        sigstar({{'Pre','Post'}},p);
    end
    title(field_names{f});
end


% 
% display_figure = 0;
% if display_figure
%     [h_omega, p_omega] = ttest(log(stats{1}.omega),log(stats{2}.omega));
%     [h_theta, p_theta] = ttest(log(stats{1}.theta),log(stats{2}.theta));
%     [h_beta, p_beta] = ttest(stats{1}.beta,stats{2}.beta);
%     %[h_lr, p_lr] = ttest(stats{1}.learning_rate,stats{2}.learning_rate);
%     figure(301)
%     clf
%     subplot(2,2,1);
%     hold on
%     h = boxplot([log(stats{1}.omega),log(stats{2}.omega)],'Symbol','k.');
%     g = findobj(gca,'Tag','Box'); 
%     patch(get(g(2),'XData'),get(g(2),'YData'),'w');
%     patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
%     set(h,'Color','k','LineStyle','-','LineWidth',1)
%     set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
%     set(gca,'children',flipud(get(gca,'children')))
%     if p_omega<0.05
%         sigstar({{'Pre','Post'}},p_omega);
%     end
%     title('\omega')
%     
%     subplot(1,3,2);
%     h = boxplot([log(stats{1}.theta),log(stats{2}.theta)],'Symbol','k.');
%     
%     g = findobj(gca,'Tag','Box'); 
%     patch(get(g(2),'XData'),get(g(2),'YData'),'w');
%     patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
%     set(h([1:6 8:end]),'Color','k','LineStyle','-','LineWidth',1)
%     set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
%     set(gca,'children',flipud(get(gca,'children')))
% 
%     if p_theta<0.05
%         sigstar({{'Pre','Post'}},p_theta);
%     end
%     title('\vartheta')
% 
%     subplot(1,3,3);
%     h = boxplot([stats{1}.beta,stats{2}.beta],'Symbol','k.');
%     g = findobj(gca,'Tag','Box'); 
%     patch(get(g(2),'XData'),get(g(2),'YData'),'w');
%     patch(get(g(1),'XData'),get(g(1),'YData'),[0.7 0.7 0.7]);
%     set(h,'Color','k','LineStyle','-','LineWidth',1)
%     set(h(14),'Color','w')
%     set(gca,'XTick',[1 2],'XTickLabels',{'Pre';'Post'});
%     set(gca,'children',flipud(get(gca,'children')))
%     if p_beta<0.05
%         sigstar({{'Pre','Post'}},p_beta);
%     end
%     title('\beta')
%     
%     
%     purty_plot(301,[D.FIGURES_DIR 'model_pars'],'pdf')
% end
