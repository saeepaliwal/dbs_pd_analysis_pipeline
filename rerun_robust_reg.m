%% Load data

S1 = '~/polybox/Projects/DBS_ParkinsonsPatients/eduardo_rerun/stats_ALL_DATA_EduardoRerun.mat';
S2 = '~/polybox/Projects/DBS_ParkinsonsPatients/results/FinalStats/stats_ALL_DATA.mat';

load(S1);
for i = 1:2
    rerun{i}.omega = stats{i}.omega;
    rerun{i}.theta = stats{i}.theta;
end

load(S2);
for i = 1:2
    orig{i}.omega = stats{i}.omega;
    orig{i}.theta = stats{i}.theta;
end

%% Run behavioral regression
y1 = stats{1}.BIS_Attentional';
X1 = [stats{1}.bets stats{1}.machine_switches stats{1}.gamble stats{1}.BDI'];
r_behav = regstats(y1,X1,'linear');
reg_vals(r_behav, 'BIS Slot machine behav','BIS Attentional',{'Bets';'MS';'DU';'BDI'});

%% Run parameter regressions, Pre DBS and BIS Non-planning

y2 = stats{1}.BIS_NonPlanning';
X2 = [log(orig{1}.omega) log(orig{1}.theta) stats{1}.BDI'];
% y2 = y2(run_idx_pre);
% X2 = X2(run_idx_pre,:);
r_pre_orig = regstats(y2,X2,'linear');
reg_vals(r_pre_orig,'Pre DBS model Params',...
    'BIS Non-planning',{'omega';'theta';'BDI'});

y3 = stats{1}.BIS_NonPlanning';
X3 = [log(rerun{1}.omega) log(rerun{1}.theta) stats{1}.BDI'];
% y3 = y3(run_idx_pre);
% X3 = X3(run_idx_pre,:);
r_pre_rerun = regstats(y3,X3,'linear');
reg_vals(r_pre_rerun,'Pre DBS model Params',...
    'BIS Non-planning',{'omega';'theta';'BDI'});

%% Parameter regression, Post-DBS and BIS Attentional

y4 = stats{2}.BIS_NonPlanning';
X4 = [log(orig{2}.omega) log(orig{2}.theta) stats{2}.BDI'];
% y4 = y4(run_idx_post);
% X4 = X4(run_idx_post,:);
r_post_orig = regstats(y4,X4,'linear');
reg_vals(r_post_orig,'Post DBS model Params',...
    'BIS Attentional',{'omega';'theta';'BDI'});

y5 = stats{2}.BIS_NonPlanning';
X5 = [log(rerun{2}.omega) log(rerun{2}.theta) stats{2}.BDI'];
% y5 = y5(run_idx_post);
% X5 = X5(run_idx_post,:);
r_post_rerun = regstats(y5,X5,'linear');
reg_vals(r_post_rerun,'Pre DBS model Params',...
    'BIS Non-planning',{'omega';'theta';'BDI'});

