function regs = all_regressions(printbeta, questionnaire, subject_type,stats,PAPER,parameter_workspace)

%% Regression of parametrs on readouts and BIS
load(parameter_workspace)

if PAPER
    omega = pars.omega';
    theta = pars.theta';
end
    
% Demean and scale to unity vol
omega = omega-mean(omega);
omega = omega/std(omega);

theta = theta-mean(theta);
theta = theta/std(theta);

if exist('bbeta')
    bbeta = bbeta - mean(bbeta);
    bbeta = bbeta/std(bbeta);
end
if PAPER
    X = [omega theta];
    try
      y = eval(['stats{' sprintf('%d',subject_type) '}.' questionnaire]);
    catch e
        error('Could not find specified questionnaire');
    end 
    regs = regstats(y,X,'linear');
    
else
    
    %% All model pars
    %X = [omega' theta' bbeta'];
    
    if printbeta
        X = [omega theta];
    else
        X = [omega theta];
    end
    
    % Regression on BIS
    y = stats{1}.BIS_Total';
    regs{1} = regstats(y,X,'linear');
    
    % Regression on bet mean
    y = stats{1}.B_mean';
    regs{2} = regstats(y,X,'linear');
    
    % Regression on Bet Switch Pct
    y = stats{1}.switchbetPct';
    regs{3} = regstats(y,X,'linear');
    
    % Regression on Machine Switch Pct
    y = stats{1}.switchPct';
    regs{4} = regstats(y,X,'linear');
    
    % Regression on Cashout
    y = stats{1}.cashoutPct';
    regs{5} = regstats(y,X,'linear');
    
    % Regression on Gamble
    y = stats{1}.gamblePct';
    regs{6} = regstats(y,X,'linear');
    
    
    %% Some model pars
    
    % Regression omega on BIS
    X = [omega];
    y = stats{1}.BIS_Total';
    regs{7} = regstats(y,X,'linear');
    
    % Regression theta on BIS
    X = [theta];
    y = stats{1}.BIS_Total';
    regs{8} = regstats(y,X,'linear');
    
    % Regression bbeta on BIS
    %if printbeta
    %	X = [bbeta];
    %	y = stats{1}.BIS_Total';
    %	regs{9} = regstats(y,X,'linear');
    %end
    % Panel regression of everything on the BIS
    X = [stats{1}.betswitch_up_Pct' stats{1}.gamblePct' stats{1}.switchPct' stats{1}.cashoutPct'];
    y = stats{1}.BIS_Total';
    regs{10} = regstats_w_sse(y,X,'linear');
    % To get BIC:  -0.5*regs{10}.sse - 0.5*4*log(size(X,1))
    
    
    % Panel regression of everything on the BIS
    X = [stats{1}.betswitch_up_Pct' stats{1}.gamblePct' stats{1}.switchPct' stats{1}.cashoutPct' omega];
    y = stats{1}.BIS_Total';
    regs{11} = regstats(y,X,'linear');
    
    % Regressions with BIS subscales:
    X = [omega theta];
    y = stats{1}.BIS_Attention'+ stats{1}.BIS_CognitiveInstability';
    regs{12} = regstats(y,X,'linear');
    
    y = stats{1}.BIS_Motor' + stats{1}.BIS_Perserverance';
    regs{13} = regstats(y,X,'linear');
    
    
    y = stats{1}.BIS_SelfControl' + stats{1}.BIS_CognitiveComplexity';
    regs{14} = regstats(y,X,'linear');
    
    
    y = stats{1}.SPQRS_Reward';
    regs{15} = regstats(y,X,'linear');
    
    y = stats{1}.SPQRS_Punish';
    regs{16} = regstats(y,X,'linear');
    %{

y = stats{1}.upps_sensationSeeking';
regs{18} = regstats(y,X,'linear');

y = stats{1}.sssv_total';
regs{18} = regstats(y,X,'linear');


    %}
end



