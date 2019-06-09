%function test_recoverability(chm_recovery)
%%
figure(101)
subplot(1,3,1)
om_plot_gt = [-5 -3.5 -2];
om_plot_recovered = [[recovered_omega(:,1); recovered_omega(:,2); ...
    recovered_omega(:,3)] [recovered_omega(:,4); recovered_omega(:,5); ...
    recovered_omega(:,6)]...
    [recovered_omega(:,7); recovered_omega(:,8); ...
    recovered_omega(:,9)]];


ax = errorbar(om_plot_gt,mean(om_plot_recovered,1),...
std(om_plot_recovered,1), 'Marker','.', 'MarkerSize',50,'LineWidth',4);
xlim([-5.5 -1.5])
xlabel('Ground truth \omega')
ylabel('Recovered \omega')
title('\omega')


subplot(1,3,2)
th_plot_gt =[ -7 -4 -1];
th_plot_recovered = [[recovered_theta(:,1); recovered_theta(:,4); recovered_theta(:,7)]...
    [recovered_theta(:,2); recovered_theta(:,5); ...
    recovered_theta(:,8)]...
    [recovered_theta(:,3); recovered_theta(:,6); ...
    recovered_theta(:,9)]];


ax = errorbar(th_plot_gt,mean(th_plot_recovered,1),...
std(th_plot_recovered,1), 'Marker','.', 'MarkerSize',50,'LineWidth',4);
xlim([-7.5 -0.5])
xlabel('Ground truth \vartheta')
ylabel('Recovered \vartheta')
title('\vartheta')


subplot(1,3,3)
be_plot_gt =[4 8 12];
be_plot_recovered = [[recovered_beta(:,1); recovered_beta(:,2); recovered_beta(:,3)]...
    [recovered_beta(:,4); recovered_beta(:,5); ...
    recovered_beta(:,6)]...
    [recovered_beta(:,7); recovered_beta(:,8); ...
    recovered_beta(:,9)]];


ax = errorbar(be_plot_gt,mean(be_plot_recovered,1),...
std(be_plot_recovered,1), 'Marker','.', 'MarkerSize',50,'LineWidth',4);
xlim([3.5 12.5])
xlabel('Ground truth \beta')
ylabel('Recovered \beta')
title('\beta')

purty_plot(101,'./figures/parameter_recovery','png')
%xlim