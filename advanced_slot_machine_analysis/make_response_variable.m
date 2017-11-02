function [allY] = make_response_variable(subject_type, subject_num,stats)
% [allY] = make_response_variable(subject_type, subject_num)
% function [allY] = make_response(subject_type)
% This function will generate the various response variables as a substrate
% for the response variable of the HGF
%
% -------------------------------------------------------------------------
% Author: Saee Paliwal, TNU

% 1. All bet switches: This is a 1 when you change bets up and 0 when
% you keep the same bet or switch down
betswitchup = stats{subject_type}.data{subject_num}.bets';
betswitchup(betswitchup == 60) = 1;
betswitchup(betswitchup == 20) = 0;
betswitchup = [0; diff(betswitchup)];
betswitchup(find(betswitchup==-1)) = 0;

% 2. Bet switch up, gamble
gamble = stats{subject_type}.data{subject_num}.gamble';
betupgam = nansum([betswitchup gamble],2); % sums every row together
betupgam = +(betupgam~=0);

% 3. Bet switch up, gamble, cashout
cashout = stats{subject_type}.data{subject_num}.cashout';
bugamcash = nansum([betswitchup gamble cashout],2);
bugamcash = +(bugamcash~=0);

% 4. Bet switch up, machine switch, gamble, cashout
machineSwitch = stats{subject_type}.data{subject_num}.machineSwitches';
allswitch = nansum([betswitchup machineSwitch gamble cashout],2);
allswitch = +(allswitch~=0);
% 
% if PAPER
%     allY{1} = allswitch;
% else
%     allY{1} = betswitchup;
%     allY{2} = betupgam;
%     allY{3} = bugamcash;
%     allY{4} = allswitch;
% end

allY{1} = allswitch;