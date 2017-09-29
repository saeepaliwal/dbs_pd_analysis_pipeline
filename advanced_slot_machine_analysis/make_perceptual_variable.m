function [allU] = make_perceptual_variable(subject_type, subject_num,stats,P)
% function [allU] = make_percepts(subject_type)
% subject_type in this 
% This function will make perceptual variable that will be the substrate
% for the perceptual variable
%
% As a reminder from the probability trace of the paradigm:
% 0 is a loss
% 1 is a real win
% 2 is a fake win
% 3 is a near miss
%
% -------------------------------------------------------------------------
% Author: Saee Paliwal, TNU


path(path,genpath(pwd));
perf = stats{subject_type}.data{subject_num}.performance;

% 1 Percept: binary, win/loss (gross)
wl_gross = P;
wl_gross(wl_gross == 3) = 0;
wl_gross(wl_gross == 2) = 1;
allU{1} = wl_gross';

% 2 Percept: true win/loss (net)
wl_net = [0 diff(perf)];
wl_net = +(wl_net>0); % This replaces all positive values with a 1
gam = stats{subject_type}.data{subject_num}.gamble;
wl_net(find(gam == 1)) = P(find(gam==1)); % This is to isolate the win/loss percept of the underlying trials
wl_net(find(wl_net==2)) = 0; % fake wins are mapped to losses
allU{2} = wl_net';

% 3 Percept: near misses and fake wins map to wins
near_miss = P;
near_miss(near_miss == 2) = 1; % fake wins map to wins
near_miss(near_miss == 3) = 1; % near misses map to wins
near_miss = near_miss';
near_miss = near_miss(1:length(perf));
allU{3} = near_miss;