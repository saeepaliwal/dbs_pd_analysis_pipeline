function stats = output2mat(output_dir)
% Makes stats structure for subjects.
% Subjects should be a vector of integers
%% Applies various incarnations of the HGF to the gambling paradigm
%
% Pull in candidate trace
% 0 is a loss
% 1 is a real win
% 2 is a fake win
% 3 is a near miss

stats = [];

% Pull all subject names
allnames = dir(output_dir);
isub = [allnames(:).isdir];
subjects = {allnames(isub).name};
subjects(ismember(subjects,{'.','..'})) = [];

% Group variables
allReaction = [];
allBets = [];
allBetSwitch = [];
allPerf = [];
allDiffPerf = [];
allVol = [];
allSwitch = [];
allCashout = [];
allMachine = [];

if length(subjects) == 0
    error('output2mat: No subjects found in directory. Check path variables');
end

% Individual Effects: pull out patient-by-patient stats
for i = 1:length(subjects)
    
    stats.labels(i) = subjects(i);
    subject_name = subjects{i};
    subdir = [output_dir '/' subject_name '/1/'];
    subdir = [output_dir subject_name '/1/'];
    
    if ~exist(subdir)
        subdir = [output_dir '/' subject_name '/'];
    end

    cd(subdir);
    if exist('./1','dir')
        cd 1;
    end
    d = dir('output*.mat');
    t = dir('*.txt');
    % Vars to define:
    % bets, P, current_machine,switches, performance, gamble, win grade, gambleOutcome,
  

    if length(d)>0
        load(d.name);
        % Pull in variables:
        current_machine = machine_sequence;
        [no_gamble, cashout, lenOfPlay] = parse_output_short(t.name);
    else
        load result_sequence     
        [no_gamble, cashout, lenOfPlay, current_machine, bet_size, account] = parse_output_short(t.name);
    end
       
    % Performance

    end_idx = length(account);
    performance = account(6:end);
    
    % Machine
    current_machine = current_machine(6:end_idx);
    
    % Bet
    bets = double(bet_size(6:end_idx));
    
    % Cashout
    cashout = cashout(6:end_idx)';
    
    % Probability trace
    P = str2num(result_sequence(6:end_idx,1));
    
    % Machine Switches
    switches = [0 diff(current_machine)];
    switches = (switches~=0)';
    
    % Gamble
    gamble = str2num(result_sequence(6:end_idx,end-1));
    gambleOutcome = str2num(result_sequence(6:end_idx,end));
    no_gamble = no_gamble(6:end_idx);
    gamble = gamble.*no_gamble';
    gambleOutcome = gambleOutcome.*no_gamble';
     
    % Win grade
    win=(P==1);
    grade = str2num(result_sequence(6:end_idx,2)).*win;
    
    % Fix dimensions:
    if length(bets)<100
        bets(end+1:100) = 0;
        grade(end+1:100) = 0;
        performance(end+1:100) = 0;
        gamble(end+1:100) = 0;
        cashout(end+1:100) = 0;
        switches(end+1:100) = 0;
        current_machine(end+1:100) = 0;
    end
    
    % Summary statistics:
    % Variance of bet behaviour
    stats.B_var(i) = var(bets);
    
    % Mean of bet behav
    stats.B_mean(i) = mean(bets);
        
    % Percentage cashouts:
    stats.cashoutPct(i) = sum(nansum(cashout))/length(cashout);
    
    % Percentage switches:
    stats.switchPct(i) = sum(nansum(switches))/length(switches);
    
    % Percentage gamble:
    stats.gamblePct(i) = sum(gamble)/length(gamble);
        
    % Percentage Switch Bets: Added Rike
    
    stats.switchbetPct(i) = 1-(length(find(diff(bets)==0))/length(bets));
    
    % Performance score
    stats.finalPerf(i) = performance(end);
    
    % Length of play
    stats.lenPlay(i) = lenOfPlay;
    
    % All Bets
    allBets = [allBets bets'];
    
    % All Bet Switch
    allBetSwitch = [allBetSwitch 0 diff(bets)];
    
    % All Performance
    allPerf = [allPerf performance'];
    
    % All machine
    allMachine = [allMachine current_machine'];
    
    % All Switches
    allSwitch = [allSwitch switches];
    
    % All Cashouts
    allCashout = [allCashout cashout'];
    
    % Save trajectories
    stats.data{i}.name = subject_name;
    stats.data{i}.bets = bets;
    stats.data{i}.machineSwitches = switches;
    stats.data{i}.cashout = cashout;
    stats.data{i}.gamble = gamble;
    stats.data{i}.gambleOutcome = gambleOutcome;
    stats.data{i}.grade = grade;
    stats.data{i}.probabilityTrace = P;
    stats.data{i}.lenOfPlay = lenOfPlay;
    stats.data{i}.current_machine = current_machine;
    stats.data{i}.performance = performance;
 end


% Aggregate variables
stats.allBets = allBets;
stats.allReaction = allReaction;
stats.allPerf = allPerf;
stats.allDiffPerf = allDiffPerf;
stats.allBetSwitch = +(allBetSwitch~=0);
stats.allSwitches = allSwitch;
stats.allCashout = allCashout;
stats.allMachine = allMachine;



