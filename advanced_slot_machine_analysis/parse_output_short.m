function [no_gamble, cashout, lenOfPlay, machine, bet_size, account, pressed_stop] = parse_output_short(filename)

f = fopen(filename,'r');
totaltrials = 105;
cashout = zeros(1,totaltrials);
no_gamble = ones(1,totaltrials);
bet_size = zeros(1,totaltrials);
pressed_stop = zeros(1,totaltrials);
account = [];
trialnum = [1];
training = false;
currenttrial = 1;
buttonscreen = true;
startTime = NaN;
endTime = NaN;
machine = ones(1,totaltrials);
while ~feof(f)
    
    line = fgetl(f);

    parsed = [];
    [parsed{1} remain] = strtok(line,' ');
    while ~isempty(remain)
        [tok remain] = strtok(remain,' ');
        parsed{end+1} = tok;
    end

    tnum = [];
    if strcmp(parsed(1),'Trial') & length(parsed)==7
        tnum = str2num(parsed{2}(1:end-1))+1;
        
        if trialnum(end) ~= tnum
            trialnum = [trialnum tnum];
            currenttrial = trialnum(end);
        end
    elseif strcmp(parsed(1),'Did') & strcmp(parsed(2),'not') & strcmp(parsed(3),'gamble')
        no_gamble(currenttrial) = 0;
    elseif length(parsed)==6 & strcmp(parsed(3),'Stopping')
        pressed_stop(currenttrial) = 1;
    elseif strcmp(parsed(1),'Cashing') & strcmp(parsed(2),'out')
        cashout(currenttrial) = 1;
    elseif strcmp(parsed(1),'Summary')
       [bet extra] = strtok(parsed(3),'A');
       [bet size] = strtok(bet,':');
       bet_size(currenttrial) = str2num(size{:}(2:end));
       account(currenttrial) = str2num(parsed{4}(2:end-1));
    elseif strcmp(parsed(1),'Did') & strcmp(parsed(2),'not')& strcmp(parsed(3),'cash')
        cashout(currenttrial) = 0;
    elseif strmatch('machines',parsed)
        machine(currenttrial) = str2num(parsed{7});
    elseif strcmp(parsed(1),'ButtonScreen') & buttonscreen == true;
        buttonscreen = false;
        startTime = str2num(parsed{3});
    elseif strcmp(parsed(1),'Exiting')
        endTime = str2num(parsed{3});
    end
    
   
end
% Get length of play:
lenOfPlay = endTime - startTime;
fclose(f);

