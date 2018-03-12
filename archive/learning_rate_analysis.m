function stats = learning_rate_analysis(stats)
%% Pre learning rate

for s = 1:2
    t = 1;
    for i = 1:length(stats{1}.labels)
        c = tapas_hgf_binary_config;
        inputs = stats{s}.hhgf_est{1}.data(i).u;
        pvec = c.priormus;
        pvec(13) = stats{s}.omega(i);
        pvec(14) = stats{s}.theta(i);
        sim = tapas_simModel(inputs, 'tapas_hgf_binary',...
            pvec, ...
            'tapas_softmax_binary', stats{s}.beta(i));
        learning_rate = sim.traj.psi(:,2:3);
        mean_lr(t,:,s) = mean(learning_rate,1);
        var_pre(t,:,s) = std(learning_rate,1);
        
        t = t+1;
    end
end


stats{1}.learning_rate = mean_lr(:,:,1);
stats{2}.learning_rate = mean_lr(:,:,2);
%%
figure(1)
boxplot([stats{1}.learning_rate stats{2}.learning_rate])
[a,b,c,d] = ttest(stats{1}.learning_rate,stats{2}.learning_rate)


%%
% for s = 1:2
%     field = 'LEDD'
%     r_ledd{s} = regstats(stats{s}.LEDD',stats{s}.learning_rate);
%     r_ledd{s}.fstat
% end

%%
[a b] = corr([stats{1}.LEDD stats{2}.LEDD]',[stats{1}.learning_rate' stats{2}.learning_rate']')

% %%
% for s = 1:2
%     r_l1{s} = regstats(stats{s}.learning_rate, [stats{s}.omega...
%         stats{s}.theta],'linear');
% end

%%
s = 2;
figure(101)
clf
field = 'QUIP';
quest_diff = stats{2}.(field)-stats{1}.(field);
idx1 = find(quest_diff<=0);
idx2 = find(quest_diff>0);
aa = [ones(1,length(idx1)) 2*ones(1,length(idx2))] ;

%
subplot(1,4,1)
boxplot(log([stats{s}.omega(idx1)' stats{s}.omega(idx2)'])',aa')
set(gca,'XTickLabel',{'Decrease';'Increase'})
title('Omega')

%
subplot(1,4,2)
boxplot(log([stats{s}.theta(idx1)' stats{s}.theta(idx2)'])',aa')
set(gca,'XTickLabel',{'Decrease';'Increase'})
title('Theta')


subplot(1,4,3)
boxplot([stats{s}.learning_rate(idx1,1)' stats{s}.learning_rate(idx2,1)']',aa')
a = stats{s}.learning_rate(idx1,1);
b  = stats{s}.learning_rate(idx2,1);
[h p] = ttest2(a,b)
title('Learning rate, x_1 to x_2')

set(gca,'XTickLabel',{'Decrease';'Increase'})
if p<0.05
    sigstar({{'Decrease';'Increase'}},p);
    
end

subplot(1,4,4)
boxplot([stats{s}.learning_rate(idx1,2)' stats{s}.learning_rate(idx2,2)']',aa')
a = stats{s}.learning_rate(idx1,2);
b  = stats{s}.learning_rate(idx2,2);
[h p] = ttest2(a,b);
title('Learning rate , x_2 to x_3')
set(gca,'XTickLabel',{'Decrease';'Increase'})
if p<0.05
    sigstar({{'Decrease';'Increase'}},p);
    ylim([0 20])
end

