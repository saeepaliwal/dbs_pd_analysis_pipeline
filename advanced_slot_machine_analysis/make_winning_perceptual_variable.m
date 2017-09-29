function [allU] = make_winning_perceptual_variable(subject_type, subject_num,stats,P)
% function [allU] = make_percepts(subject_type)
% subject_type in this 
% This function will make perceptual variable that will be the substrate
% for the perceptual variable
%
% As a reminder from the probability trace of the paradigm:
% 0 is a loss
% 1 is a real win
% 2 is a near miss
%
% -------------------------------------------------------------------------
% Author: Saee Paliwal, TNU

% Pull performance
perf = stats{subject_type}.data{subject_num}.performance;

% Percept: true win/loss (net)
u = [0 diff(perf)];
u = +(u>0); % This replaces all positive values with a 1
gam = stats{subject_type}.data{subject_num}.gamble;
%u(find(gam == 1)) = P(find(gam==1)); % This is to isolate the win/loss percept of the underlying trials
% u(find(u==2)) = 0; % fake wins are mapped to losses
allU{1} = u';
