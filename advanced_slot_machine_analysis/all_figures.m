addpath(genpath('~/Dropbox/PathologicalGambling/analysis'));
c = @cmu.colors;

%% Methods
% Simulation and histogram
load Final_trace.mat
%vis_trace(cT);


%% Results

%% Bet behav
clear
c = @cmu.colors;
load stats
% Bet Switching
sidx1 = find(strcmp(stats{1}.labels,'3935_0'));
sidx2 = find(strcmp(stats{1}.labels,'4605_0'));

hFig = figure(500);

hGCA(1) = subplot(1,2,1);
hPlot(1) = plot(stats{1}.data{sidx1}.bets,'*-','color',c('deep carrot orange'));
hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Bet size (min/max)');
hTitle(1) = title('Example Subject 1');

hGCA(2) = subplot(1,2,2);
hPlot(2) = plot(stats{1}.data{sidx2}.bets,'*-','color',c('deep carrot orange'));
hLabel(3) = xlabel('Trial No');
hLabel(4) = ylabel('Bet size (min/max)');
hTitle(2) = title('Example Subject 2');

[extra hTitle(3)] = suplabel('Betting Behaviour','t');

purty_plot(hFig, hGCA, hPlot,hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/betbehav.pdf


%% Machine switching
clear
c = @cmu.colors;
load stats
% Bet Switching
sidx1 = find(strcmp(stats{1}.labels,'3662_0'));
sidx2 = find(strcmp(stats{1}.labels,'3123_0'));

hFig = figure(501);

hGCA(1) = subplot(1,2,1);
hPlot(1) = bar(stats{1}.data{sidx1}.switches,'EdgeColor',c('fern green'),'FaceColor',c('fern green'));
hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Machine Switch (Y/N)');
hTitle(1) = title('Example Subject 1');


hGCA(2) = subplot(1,2,2);
hPlot(1) = bar(stats{1}.data{sidx2}.switches,'EdgeColor',c('fern green'),'FaceColor',c('fern green'));
hLabel(3) = xlabel('Trial No');
hLabel(4) = ylabel('Machine Switch (Y/N)');
hTitle(2) = title('Example Subject 2');

[extra hTitle(3)] = suplabel('Machine Switching Behaviour','t');

purty_plot(hFig, hGCA, [],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/mswitchbehav.pdf


%% Cashouts
clear
c = @cmu.colors;
load stats
% Bet Switching
sidx1 = find(strcmp(stats{1}.labels,'3836_0'));
sidx2 = find(strcmp(stats{1}.labels,'3616_0'));

hFig = figure(502);

hGCA(1) = subplot(1,2,1);
hPlot(1) = bar(stats{1}.data{sidx1}.cashout,'EdgeColor',c('glaucous'),'FaceColor',c('glaucous'));

hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Cashout (Y/N)');
hTitle(1) = title('Example Subject 1');


hGCA(2) = subplot(1,2,2);
hPlot(1) = bar(stats{1}.data{sidx2}.cashout,'EdgeColor',c('glaucous'),'FaceColor',c('glaucous'));
hLabel(3) = xlabel('Trial No');
hLabel(4) = ylabel('Cashout (Y/N)');
hTitle(2) = title('Example Subject 2');

[extra hTitle(3)] = suplabel('Cashout Behaviour','t');

purty_plot(hFig, hGCA, [],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/cashoutbehav.pdf

%% Gambles
clear
c = @cmu.colors;
load stats
% Bet Switching
sidx1 = 43;
sidx2 = 36;

hFig = figure(502);

hGCA(1) = subplot(1,2,1);
hPlot(1) = bar(stats{1}.data{sidx1}.gamble,'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));

hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Cashout (Y/N)');
hTitle(1) = title('Example Subject 1');


hGCA(2) = subplot(1,2,2);
hPlot(1) = bar(stats{1}.data{sidx2}.gamble,'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));
hLabel(3) = xlabel('Trial No');
hLabel(4) = ylabel('Cashout (Y/N)');
hTitle(2) = title('Example Subject 2');

[extra hTitle(3)] = suplabel('Extra Gamble Behaviour','t');

purty_plot(hFig, hGCA, [],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/gamblebehav.pdf




%% Reaction time
%{
clear
c = @cmu.colors;
load stats
% Bet Switching
sidx1 = 43;
sidx2 = 36;

hFig = figure(503);

hGCA(1) = subplot(1,2,1);
hPlot(1) = bar(stats{1}.data{sidx1}.cashout,'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));

hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Cashout (Y/N)');
hTitle(1) = title('Example Subject 1');


hGCA(2) = subplot(1,2,2);
hPlot(1) = bar(stats{1}.data{sidx2}.cashout,'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));
hLabel(3) = xlabel('Trial No');
hLabel(4) = ylabel('Cashout (Y/N)');
hTitle(2) = title('Example Subject 2');

[extra hTitle(3)] = suplabel('Extra Gamble Behaviour','t');

purty_plot(hFig, hGCA, [],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/cashoutbehav.pdf
%}

%% FE bar charts

c = @cmu.colors;
hFig = figure(504)
load allbinFE
load allcontFE
% n = 1 is the bet min/max response
% n = 2 is the bet switch 0/1 response
% n = 3 is the machine switch and bet switch response
% n = 4 is the machine switch, gamble and bet switch response
% n = 5 is the machine switch, gamble, cashout, and bet switch response
allFE = [allbinFE allcontFE];
%allFE = -allFE;

%load FEgrid
%allFE = FEgrid;

hGCA(1) = subplot(5,1,1);
hPlot(1) = bar(allFE(1,:),'EdgeColor',c('deep carrot orange'),'FaceColor',c('deep carrot orange'));
set(hGCA(1),'XTick',[1 2 3 4 5])
set(hGCA(1),'XTickLabel',{'Win/Loss(Gross)';'Win/Loss(Net)';'NearMiss/FakeWin';'Machine';'Performance'})
hLabel(1) = ylabel('Diff Negative FE');
hTitle(1) = title('Response: Bet min/max');

hGCA(2) = subplot(5,1,2);
hPlot(2) = bar(allFE(2,:),'EdgeColor',c('fern green'),'FaceColor',c('fern green'));
set(hGCA(2),'XTick',[1 2 3 4 5])
set(hGCA(2),'XTickLabel',{'Win/Loss(Gross)';'Win/Loss(Net)';'NearMiss/FakeWin';'Machine';'Performance'})
hLabel(2) = ylabel('Diff Negative FE');
hTitle(2) = title('Response: Bet Switch Y/N');

hGCA(3) = subplot(5,1,3);
hPlot(3) = bar(allFE(3,:),'EdgeColor',c('glaucous'),'FaceColor',c('glaucous'));
set(hGCA(3),'XTick',[1 2 3 4 5])
set(hGCA(3),'XTickLabel',{'Win/Loss(Gross)';'Win/Loss(Net)';'NearMiss/FakeWin';'Machine';'Performance'})
hLabel(3) = ylabel('Diff Negative FE');
hTitle(3) = title('Response: Bet and Machine Switch');

hGCA(4) = subplot(5,1,4);
hPlot(4) = bar(allFE(4,:),'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));
set(hGCA(4),'XTick',[1 2 3 4 5])
set(hGCA(4),'XTickLabel',{'Win/Loss(Gross)';'Win/Loss(Net)';'NearMiss/FakeWin';'Machine';'Performance'})
hLabel(4) = ylabel('Diff Negative FE');
hTitle(4) = title('Response: Bet and Machine Switch, Gamble');

hGCA(5) = subplot(5,1,5);
hPlot(5) = bar(allFE(5,:),'EdgeColor',c('goldenrod'),'FaceColor',c('goldenrod'));
set(hGCA(5),'XTick',[1 2 3 4 5])
set(hGCA(5),'XTickLabel',{'Win/Loss(Gross)';'Win/Loss(Net)';'NearMiss/FakeWin';'Machine';'Performance'})
hLabel(5) = ylabel('Diff Negative FE');
hTitle(5) = title('Response: All Switches/Cashouts/Gambles');

hLegend = [];
purty_plot(hFig, hGCA,hPlot,hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/FEbars.pdf

%% FE bar compare

c = @cmu.colors;
hFig = figure(505)

idx = [1 5]
hGCA(1) = subplot(5,1,1);
hPlot(1) = bar(allFE(1,idx),'EdgeColor',c('deep carrot orange'),'FaceColor',c('deep carrot orange'));
set(hGCA(1),'XTick',[1 2])
set(hGCA(1),'XTickLabel',{'Win/Loss(Gross)';'Machine'})
hTitle(1) = title('Response: Bet min/max');
hLabel(1) = ylabel('Diff Negative FE');

hGCA(2) = subplot(5,1,2);
hPlot(2) = bar(allFE(2,idx),'EdgeColor',c('fern green'),'FaceColor',c('fern green'));
set(hGCA(2),'XTick',[1 2])
set(hGCA(2),'XTickLabel',{'Win/Loss(Gross)';'Machine'})
hTitle(2) = title('Response: Bet Switch Y/N');
hLabel(2) = ylabel('Diff Negative FE');

hGCA(3) = subplot(5,1,3);
hPlot(3) = bar(allFE(3,idx),'EdgeColor',c('glaucous'),'FaceColor',c('glaucous'));
set(hGCA(3),'XTick',[1 2])
set(hGCA(3),'XTickLabel',{'Win/Loss(Gross)';'Machine'})
hTitle(3) = title('Response: Bet and Machine Switch');
hLabel(3) = ylabel('Diff Negative FE');

hGCA(4) = subplot(5,1,4);
hPlot(4) = bar(allFE(4,idx),'EdgeColor',c('deep coffee'),'FaceColor',c('deep coffee'));
set(hGCA(4),'XTick',[1 2])
set(hGCA(4),'XTickLabel',{'Win/Loss(Gross)';'Machine'})
hTitle(4) = title('Response: Bet and Machine Switch, Gamble');
hLabel(4) = ylabel('Diff Negative FE');

hGCA(5) = subplot(5,1,5);
hPlot(5) = bar(allFE(5,idx),'EdgeColor',c('goldenrod'),'FaceColor',c('goldenrod'));
set(hGCA(5),'XTick',[1 2])
set(hGCA(5),'XTickLabel',{'Win/Loss(Gross)';'Machine'})
hTitle(5) = title('Response: All Switches/Cashouts/Gambles');
hLabel(5) = ylabel('Diff Negative FE');

hLegend = [];
purty_plot(hFig, hGCA,hPlot,hLabel,hTitle,[]);
grid on
!cp purtyplot.pdf ../../drafts/figures/FEbars_zoom.pdf


%% Cluster differences

clust_diff
%% Plot actual responses over simulation
c = @cmu.colors;
load Final_trace
hFig = figure(506);
hold on
hGCA = gca;
h1 = plot(1:200,cT.betPerformance,':','color',c('silver'));grid on;
load stats
for i = [1:24 26:31 33:35 37:45]
	hPlot(i) = plot(1:length(stats{1}.data{i}.performance),stats{1}.data{i}.performance,'color',c('india green'));
end
hold on
hPlot(end+1) = plot(1:length(stats{1}.data{i}.performance),zeros(1,length(stats{1}.data{i}.performance)),'k','LineWidth',2);

hLabel(1) = xlabel('Trial No');
hLabel(2) = ylabel('Total Performance (cents)');
hTitle = title('Actual subject data and simulations');
hLegend = legend([h1(1) hPlot(1) hPlot(end)],'Simulated Data','Actual Data','Lost Game');
purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../drafts/figures/actperf_vsim.pdf

%%
load stats
hFig = figure(505);

n = 1;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.B_mean)
hTitle(n) = title('Bet Mean');
hLabel(2*n-1) = xlabel('Bet mean');
hLabel(2*n) = ylabel('Subjects');

n = 2;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.B_var)
hTitle(n) = title('Bet Variance');
hLabel(2*n-1) = xlabel('Bet Variance');
hLabel(2*n) = ylabel('Subjects');

n = 3;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.cashoutPct)
hTitle(n) = title('Cashout Pct');
hLabel(2*n-1) = xlabel('Cashout Pct');
hLabel(2*n) = ylabel('Subjects');

n = 4;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.switchPct)
hTitle(n) = title('Machine Switch Pct');
hLabel(2*n-1) = xlabel('Machine Switch Pct');
hLabel(2*n) = ylabel('Subjects');

n = 5;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.gamblePct)
hTitle(n) = title('Gamble Pct');
hLabel(2*n-1) = xlabel('Gamble Pct');
hLabel(2*n) = ylabel('Subjects');

n = 6;
hGCA(n) = subplot(3,2,n);
hist(stats{1}.gamblePct)
hTitle(n) = title('Final Perf');
hLabel(2*n-1) = xlabel('Final Perf');
hLabel(2*n) = ylabel('Subjects');


purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/subj_var.pdf

%% GMM comparison

load vb_fe

hFig = figure(506);
hGCA = gca;
bar(2:10,vb_fe,'EdgeColor','k','FaceColor','k');
hLabel(1) = xlabel('Number of Clusters');
hLabel(2) = ylabel('Negative Free Energy');
%hTitle = title('Model Comparison, VB GMM Clusters');
htitle = [];
purty_plot(hFig,hGCA,[],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/gmm_test.pdf

%%
load winning_workspace
hFig = figure(507);
hGCA = gca;
X = [omega; theta; beta];
y = stats{1}.BIS_Total;
[r,p,beta,rsquared,yhat]= calc_lin_reg(X,y, hFig, 'betatheta', 'BISTotal');

hPlot(1) = plot(1:47,(y-mean(y))/std(y),'r.-','LineWidth',2);
hold on
hPlot(2) = plot(1:47,yhat,'k--','LineWidth',2);
hLegend = legend('BIS score','Regression estimate');
hTitle=title('BIS regression on Model Parameters');
hLabel(1) = xlabel('Suject No');
hLabel(2) = ylabel('Value');
purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../drafts/figures/betamodelreg.pdf



%% FE comparison
clf
load allbinFE
c = @cmu.colors;
hFig = figure(508)
hGCA(1) = subplot(1,2,1);
hPlot(1) = bar(allbinFE(1,1),'EdgeColor',c('deep carrot orange'),'FaceColor',c('deep carrot orange'));
set(hGCA(1),'XLim',[0.5 1.5])
hLabel(1) = xlabel('Win/Loss Gross');
hLabel(2) = ylabel('Negative Free Energy');
hTitle(1) = title('HGF Binary Free Energy');
set(hGCA(1),'YLim',[-120 0]);

load 'rw_FE'
rw = mean(rw_FE);
hGCA(2) = subplot(1,2,2);
hPlot(2) = bar(rw,'EdgeColor',c('bistre'),'FaceColor',c('bistre'));
set(hGCA(2),'XLim',[0.5 1.5])
set(hGCA(2),'XTick',[1 2])
hLabel(3) = xlabel('Win/Loss Gross');
hLabel(4) = ylabel('Negative Free Energy');
hTitle(2) = title('Rescorla-Wagner Free Energy');
purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/rw_fecompare.pdf

%% y comparison
load bin_sens
c = @cmu.colors;
hFig = figure(506);
hGCA = gca;
aa = squeeze(bin_sens(:,1,:));
aa = aa(:,[1:9 11:36 38:end]);
binS = sum(aa,2)/43;
bar(1:4,binS(2:end,1),'EdgeColor',c('battleship grey'),'FaceColor',c('battleship grey'));
set(hGCA,'XTick',[1 2 3 4])
set(hGCA,'XTickLabel',{'Bet Switch';'Bet+Machine Switch';'Bet+Machine switch+Gamble';'Bet+Machine switch+Gamble+Cashout'})
hLabel(1) = xlabel('Switch Model');
hLabel(2) = ylabel('Sensitivity'); 
hTitle = title('Sensitivity Analysis Across Response Variables');
purty_plot(hFig,hGCA,[],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/bin_sens.pdf



%% Table of FE values
load FEgrid
perceptualModels = {'Win-loss Gross';'Win-loss Net';'Over-learn'; 'Full Perf';'Machine Perf'};
responseModels = {'All switches';'Bet/Machine switches, Gambles'; 'Bet and Machine switches';'Machine Switches';'Bet Min/Max'};
f1 = fopen('fe_table.tex','w');
fprintf(f1,'%s\n','\begin{table}[htb!]');
fprintf(f1,'%s\n','\begin{center}');
fprintf(f1,'%s\n','\begin{tabular}{l|c|c|c|c|c}');
fprintf(f1,'%s','& ');
for k = 1:length(perceptualModels)-1
	fprintf(f1,'%s &',perceptualModels{k});
end
fprintf(f1,'%s\\\\\n',perceptualModels{end});

for n = 1:length(responseModels)
	fprintf(f1,'%s &',responseModels{n});
	for j = 1:length(perceptualModels)-1
		fprintf(f1,'%0.2f & ',FEgrid(n,j));
	end
	fprintf(f1,'%0.2f\\\\\n ',FEgrid(n,end));
end
fprintf(f1,'%s\n','\end{tabular}');
fprintf(f1,'%s\n','\end{center}');
fprintf(f1,'%s\n','\end{table}');

fclose(f1);		


%% Omega/BIS regression
load ../all_analyses/riskup_sig2_beta/reg_results
load ../all_analyses/riskup_sig2_beta/parameter_workspace
load stats

beta = regs{7}.beta;

clf
hFig = figure(507);
hGCA = gca;
c = @cmu.colors;
bis = stats{1}.BIS_Total;

hPlot(1) = scatter(omega,bis,'.','MarkerFaceColor',c('fern green'),'MarkerEdgeColor',c('fern green'),'SizeData',500);
hold on
domain = -1.5:0.00001:2.5;
hPlot(2) = plot(domain,beta(2)*domain+beta(1),'color',c('deep carrot orange'),'LineWidth',2,'LineSmoothing', 'on');
hLabel(1) = xlabel('Omega values (demeaned, unity vol)');
hLabel(2) = ylabel('BIS score (demeeaned, normalized)');
hLegend = legend('Data','Fit');

hTitle = title('Omega and BIS regression results');

purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../paper/gambling_paper/figures/omegabisreg.pdf




%% Omega/BIS regression
load ../all_analyses/riskup_sig2_beta/reg_results
load ../all_analyses/riskup_sig2_beta/parameter_workspace
load stats

clf
hFig = figure(507);
hGCA = gca;
c = @cmu.colors;
bis = [stats{1}.BIS_Total];

bb = regs{7}.beta(2);
yhat = regs{7}.yhat;

hPlot(1) = scatter(omega,bis,'.','MarkerFaceColor',c('fern green'),'MarkerEdgeColor',c('fern green'),'SizeData',500);
hold on
set(gca,'XLim',[-5 15]);
hPlot(2) = plot(beta,yhat-mean(yhat),'color',c('deep carrot orange'),'LineWidth',2,'LineSmoothing', 'on');
hLabel(1) = xlabel('Omega values');
hLabel(2) = ylabel('BIS score');
hLegend = legend('Data','Fit');

hTitle = [];

purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);

!cp purtyplot.pdf ../../paper/gambling_paper/figures/omegabisreg.pdf


%% PG interest
c = @cmu.colors;
%load ../data/pgdata
hFig = figure(508);
hGCA = gca;
idx = find(pgdata(:,2)==1995);

bar(pgdata(idx:-1:1,3),'EdgeColor',c('deep carrot orange'),'FaceColor',c('deep carrot orange'));
set(hGCA,'XTick',1:idx)
set(hGCA,'XTIckLabel',[num2str(pgdata(idx:-1:1,2))])
hLabel(1) = xlabel('Year');
hLabel(2) = ylabel('Number of Papers');
hTitle = title('Papers published on Pathological Gambling, 1995-2012');
purty_plot(hFig,hGCA,[],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/pggrowthplot.pdf



%% BIS var

c = @cmu.colors;
hFig = figure(509);
hGCA = gca;
load stats
hist(stats{1}.BIS.Total);
h = findobj(hGCA,'Type','patch');
set(h,'FaceColor',c('fern green'),'EdgeColor','w')
hLabel(1) = xlabel('BIS Total Score');
hLabel(2) = ylabel('Number of Subjects');
hTitle= title('BIS Total Score Across Subjects');
purty_plot(hFig,hGCA,[],hLabel,hTitle,[]);
!cp purtyplot.pdf ../../drafts/figures/bishist.pdf

%% Sigmoid

hFig = figure(510);
hGCA = gca;
hold on;
x = -10:0.001:10;
y1 = sgm_test(x,1);
y2 = sgm_test(x,2);
y3 = sgm_test(x,0.5);
hPlot(1) = plot(x,y3,'LineWidth',2,'color',c('deep carrot orange'));
hPlot(2) = plot(x,y1, 'LineWidth',2,'color',c('glaucous'));
hPlot(3) = plot(x,y2, 'LineWidth',2,'color',c('fern green'));
hLegend = legend('Beta: 0.5','Beta: 1','Beta: 2');


hLabel(1) = xlabel('Input');
hLabel(2) = ylabel('Output');
hTitle = title('Softmax Response Function')
purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../drafts/figures/betasoftmax.pdf

%% Regression of BIS on beta
%% Omega/BIS regression
load winning_workspace
load stats

clf
hFig = figure(507);
hGCA = gca;
c = @cmu.colors;
origBeta = beta;
beta = beta - mean(beta);
bis = [stats{1}.BIS_Total];
bis = bis-mean(bis);

% Regression beta on BIS
X = [beta'];
y = stats{1}.BIS_Total';
bis = y;
y = y - mean(y);
regs7 = regstats(y,X,'linear');

bb = regs7.beta(2);
yhat = regs7.yhat;

hPlot(1) = scatter(beta,bis,'.','MarkerFaceColor',c('fern green'),'MarkerEdgeColor',c('fern green'),'SizeData',500);
hold on
set(gca,'XLim',[-5 15]);
hPlot(2) = plot(beta,yhat-mean(yhat),'color',c('deep carrot orange'),'LineWidth',2,'LineSmoothing', 'on');
hLabel(1) = xlabel('Beta values');
hLabel(2) = ylabel('BIS score');
hLegend = legend('Data','Fit');

hTitle = title('Beta and BIS regression results');

purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../paper/gambling_paper/figures/betabisreg.pdf

%% Trace for probability
c = @cmu.colors;

hFig = figure(510);
clf
hGCA = gca;
hold on;

load Final_trace

set(gca,'XLim',[1 10])

pp = cT.P;
pp(pp==0) = -1;

%hPlot(1) = bar(-10*(pp==-1),'EdgeColor',c('red'),'FaceColor',c('red'));
hold on
%hPlot(2) = bar(5*(pp==1),'EdgeColor',c('blue'),'FaceColor',c('blue'));
%hPlot(3) = bar(7*(pp==2),'EdgeColor',c('forest green (web)'),'FaceColor',c('forest green (web)'));
%hPlot(4) = bar(9*(pp==3),'EdgeColor',c('eggplant'),'FaceColor',c('eggplant'));
hold on
%hPlot(2) = plot([0; diff(cT.betPerformance(:,1))./cT.betPerformance(1:end-1,1)], 'LineWidth',2,'color',c('deep carrot orange'));

hPlot = plot(cT.betPerformance(18:28,1:10)/100-20,'k^--','LineWidth',2,'MarkerSize',8,'MarkerFaceColor','k','LineSmoothing','on');
%hPlot(3) = plot(x,y2, 'LineWidth',2,'color',c('fern green'));
hLegend = [];
%legend('Probability trace','Simulated Performance')
set(hGCA,'XTickLabel',{'W';'W';'NM';'L';'W';'W';'L';'L';'FW';'NM';'FW'},'XMinorTick','off');
hLabel(1) = xlabel('Trial type');
hLabel(2) = ylabel('Performance (EUR)');
hTitle = title('')
purty_plot(hFig,hGCA,hPlot,hLabel,hTitle,hLegend);
!cp purtyplot.pdf ../../paper/gambling_paper/figures/probability.pdf