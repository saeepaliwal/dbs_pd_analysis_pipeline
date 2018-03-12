
%% Print to CSV
fid = fopen(PARAMETER_SPREADSHEET,'w');

for s = 1:2
    if s == 1
        fprintf(fid,'%s\n','Pre-DBS');
    elseif s == 2
        fprintf(fid,'%s\n','Post-DBS');
    end
    
    fprintf(fid,'%s\n',['Patient Name,Omega,Theta,Beta,'...
        'BetSize,MachineSwitch,Gamble,Cashout']);
    
    for i = 1:length(stats{s}.labels)
        fprintf(fid,'%s,%0.4f,%0.4f,%0.4f,%0.4f,%d,%d,%d\n',stats{s}.labels{i},...
            stats{s}.omega(i),stats{s}.theta(i),stats{s}.beta(i),...
            stats{s}.bets(i),stats{s}.machine_switches(i),...
            stats{s}.gamble(i), stats{s}.cashout(i));
    end
end

fclose(fid);

