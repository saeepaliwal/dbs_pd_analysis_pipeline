function print_parameters_to_csv(stats,D);
%% Print to CSV
fid = fopen(D.PARAMETER_SPREADSHEET,'w');

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
            log(stats{s}.omega(i)),log(stats{s}.theta(i)),log(stats{s}.beta(i)),...
            stats{s}.B_mean(i),stats{s}.switchPct(i),...
            stats{s}.gamblePct(i), stats{s}.cashoutPct(i));
    end
end

fclose(fid);

