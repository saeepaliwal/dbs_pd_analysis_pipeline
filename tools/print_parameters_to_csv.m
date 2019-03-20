function print_parameters_to_csv(stats,D)
%% Print to CSV
fid = fopen(D.PARAMETER_SPREADSHEET,'w');
N = sum(stats{1}.allBets>0,1);
bet_mean = sum(stats{1}.allBets,1)./N;
m_switch = sum(stats{1}.allSwitches,1)./N;


for s = 1:length(stats)
    if s == 1
        fprintf(fid,'%s\n','Pre-DBS');
    elseif s == 2
        fprintf(fid,'%s\n','Post-DBS');
    end
    
    fprintf(fid,'%s\n',['Patient Name,Omega,Theta,Beta,'...
        'AvgBetSize,MachineSwitchPct,GamblePct,CashoutPct']);
    
    for i = 1:length(stats{s}.labels)
        fprintf(fid,'%s,%0.4f,%0.4f,%0.4f,%0.2f,%0.2f,%0.2f,%0.2f\n',stats{s}.labels{i},...
            stats{s}.omega(i),stats{s}.theta(i), stats{s}.beta(i),...
            bet_mean(i),m_switch(i),...
        stats{s}.gamblePct(i), stats{s}.cashoutPct(i));
    end
end

fclose(fid);


