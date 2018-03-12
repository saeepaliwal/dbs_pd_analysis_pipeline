nice_colors
green = [0 0.5 0];
yellow = [1 0.85 0];
red = [ 0.9    0.0780    0.1840]

colormap(autumn)

bs{1} = reshape(stats{1}.allBetSwitch,100,38);
bs{2} = reshape(stats{2}.allBetSwitch,100,38);

trials = 1:100;
figure(301);
clf
subjects = [29 23 37];
t = 1;
for j = 1:length(subjects)
    i = subjects(j);
    for s = 1:2
        idx_m = find(stats{s}.allSwitches(:,i) ==1);
        idx_du = find(stats{s}.data{i}.gamble == 1);
        idx_bs = find(bs{s}(:,i)==1);
        
        subplot(3,2,t)
        hold on
        plot(trials,stats{s}.allPerf(:,i),'Color',[0.7 0.7 0.7],'LineWidth',3)
        plot(trials(idx_bs),stats{s}.allPerf(idx_bs,i),'.','MarkerFaceColor',yellow,'MarkerEdgeColor',yellow,'MarkerSize',20);
        p = plot(trials(idx_m),stats{s}.allPerf(idx_m,i),'.','MarkerEdgeColor',red,'MarkerFaceColor',red,'MarkerSize',20);
        plot(trials(idx_du),stats{s}.allPerf(idx_du,i),'b.','MarkerSize',20);
        
        if j == 1
            ylim([0 20000]);
        elseif j == 2
            ylim([0 4000]);
        elseif j == 3
            ylim([0 4000]);
        end
        if s == 1
            title(['Pre-DBS BIS-11 : ' sprintf('%d',stats{s}.BIS(i))]);
            ylabel(['Example ' sprintf('%d',j)]);
        elseif s == 2
            title(['Post-DBS BIS-11 : ' sprintf('%d',stats{s}.BIS(i))]);
        end
         ylabel('Bet size');
         xlabel('Trials');
        t =t+1;
    end
end

purty_plot(301,[D.FIGURES_DIR 'game_trace'],'pdf');