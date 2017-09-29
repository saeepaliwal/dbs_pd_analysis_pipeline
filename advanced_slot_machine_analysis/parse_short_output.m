function [trialnum reaction bets performance switches current_machine cashout gamble didGamble gambleOutcome grade P lenOfPlay machine toppedUp gambleTime] = parse_short_output(headerfile, filename)

h = fopen(headerfile,'r');

while ~feof(h)
	line = fgetl(h);
	
	% Parse line into tokens
	parsed = [];
	[parsed{1} remain] = strtok(line,' ');
	while ~isempty(remain)
		[tok remain] = strtok(remain,' ');
		parsed{end+1} = tok;
	end

	if strcmp(parsed(1),'Name')
		continue;
	elseif strcmp(parsed(1),'Total')
		totaltrials = str2num(parsed{4});
		if totaltrials<50 
			totaltrials = 200+totaltrials;
		end
    end
end
fclose(h);
clear line parsed

if ~exist('totaltrials')
	totaltrials = 200;
end

f = fopen(filename,'r');

bets = zeros(1,totaltrials);
cash = zeros(1,totaltrials);
machine = [];
performance = [];

cashout = NaN(1,totaltrials);
switches = NaN(1,totaltrials);
grade = zeros(1,totaltrials);

gamble = NaN(1,totaltrials);
gambleStartTime = NaN(1,totaltrials);
gambleEndTime = NaN(1,totaltrials);
didGamble = NaN(1,totaltrials);
gambleOutcome = NaN(1,totaltrials);
noGamble = NaN(1,totaltrials);
checkedScores = NaN(1,totaltrials);
current_machine = zeros(1,totaltrials);

toppedUp = zeros(1,totaltrials);

P = [];
winloss = [];
visit = 0;

trialnum = [];

% Calculate reaction velocity
% structure: [time position1 position2];
startTime = zeros(totaltrials,3);
betTime = zeros(totaltrials,3);

training = false;
currenttrial = 0;
%while ~feof(f) & currenttrial<201

while ~feof(f)

	line = fgetl(f);
	
	% Parse line into tokens
	parsed = [];
	[parsed{1} remain] = strtok(line,' ');
	while ~isempty(remain)
		[tok remain] = strtok(remain,' ');
		parsed{end+1} = tok;
	end
	
	% Check if training
	if strcmp(parsed(1),'Trainingbegin')
		training = true;
	end
	
	if strcmp(parsed(1),'Trainingend')
		training = false;
	end
	
	if training
		continue;
	end
	tnum = [];
	% Parse tokens
	if strcmp(parsed(1),'Starting') & strcmp(parsed(2),'trial')
		tnum = str2num(parsed{4});
		if currenttrial>=200
			break;
		end
		trialnum = [trialnum tnum];
		currenttrial = trialnum(end);
		startTime(currenttrial,1:3) = [str2num(['' parsed{6} '']) str2num(['' parsed{8} '']) str2num(['' parsed{10} ''])];
	elseif strcmp(parsed(1),'Trial') & ~strcmp(parsed(3),'ended')
		tnum2 = str2num(parsed{2}(1:end-1));
		%if currenttrial>200
		%	tnum2 = tnum2+200;
		%end
		if currenttrial~=tnum2
			trialnum = [trialnum tnum2];
		 	currenttrial = trialnum(end);
		end
		P = [P str2num(parsed{4}(1))];
		if P(end) == 1
			grade(currenttrial) = str2num(parsed{6});
		end
	elseif strcmp(parsed(1),'Cashed')
		cashout(currenttrial) = 1;
		visit = visit+1;
	elseif strcmp(parsed(1),'Cancelled') & strcmp(parsed(2),'cashout')
		cashout(currenttrial) = NaN;
		visit = visit-1;
	elseif strcmp(parsed(1),'Summary:')
		machine(currenttrial) = str2num(['' parsed{4} '']);
		cash(currenttrial) = str2num(['' parsed{end} '']);
		performance(currenttrial) = machine(currenttrial) + cash(currenttrial);
	elseif strcmp(parsed(1),'Bet')
		bets(currenttrial) = str2num(['' parsed{3} '']);
		betTime(currenttrial,1:3) = [str2num(['' parsed{5} '']) str2num(['' parsed{7} '']) str2num(['' parsed{9} ''])];
	elseif strcmp(parsed(1),'Switching')
		switches(currenttrial) = 1;
    elseif strcmp(parsed(1),'Game')
        current_machine(currenttrial+1:end) = str2num(['' parsed{2} '']);
	elseif strcmp(parsed(1),'Done') & strcmp(parsed(2),'checking') & strcmp(parsed(3),'scores')
		checkedScores(currenttrial) = 1;
	elseif strcmp(parsed(1),'Decided') & strcmp(parsed(2),'to') & strcmp(parsed(3),'continue')
		switches(currenttrial) = NaN;
	elseif strcmp(parsed(1),'Extra') & strcmp(parsed(2),'gamble')
		gamble(currenttrial) = 1;
		gambleStartTime(currenttrial) = str2num(['' parsed{5} '']);
	elseif strcmp(parsed(1),'Decided') & strcmp(parsed(2),'to') & strcmp(parsed(3),'gamble')
		gambleEndTime = str2num(['' parsed{4} '']);
		didGamble(currenttrial) = 1;
	elseif strcmp(parsed(1),'Did') & strcmp(parsed(2),'not') & strcmp(parsed(3),'gamble:')
		noGamble(currenttrial) = 1;
	elseif strcmp(parsed(1),'Won') & strcmp(parsed(2),'extra') & strcmp(parsed(3),'gamble')
		gambleOutcome(currenttrial) = 1;
	elseif strcmp(parsed(1),'Top') & strcmp(parsed(2),'up:')
		if str2num(['' parsed{3} ''])==100
			toppedUp(currenttrial) = toppedUp(currenttrial)+1;
		end
	elseif strcmp(parsed(1),'Lost') 
		if length(parsed)>1 & strcmp(parsed(2),'extra') & strcmp(parsed(3),'gamble')
			gambleOutcome(currenttrial) = 0;
		end
    end
    
end

% Get length of play:
lenOfPlay = startTime(end)-startTime(1);

% Pull out gamble time
gambleTime = gambleEndTime-gambleStartTime;

% Fill out swithches/cashouts/gambles
if length(switches)<trialnum(end)
	switches(end+1:trialnum(end)) = 0;
end

if length(cashout<trialnum(end))
	cashout(end+1:trialnum(end)) = 0;
end

if length(gamble)<trialnum(end)
	gamble(end+1:trialnum(end)) = 0;
end

if length(gambleOutcome)<trialnum(end)
	gambleOutcome(end+1:trialnum(end)) = 0;
end

if length(grade)<trialnum(end)
	grade(end+1:trialnum(end)) = 0;
end

if length(gambleTime)<trialnum(end)
	gambleTime(end+1:trialnum(end)) = 0;
end

% Re-index
idx = find(bets~=0);
bets = bets(idx);
trialnum = trialnum(idx);
performance = performance(idx);
switches = switches(idx);
cashout = cashout(idx);
gamble = gamble(idx);
didGamble = didGamble(idx);
toppedUp = toppedUp(idx);
gambleOutcome = gambleOutcome(idx);
grade = grade(idx);
P = P(idx);
gambleTime = gambleTime(idx);

% Normalize P to win/loss/nearmiss
%%% -1 is loss
%%% 0 is near miss
%%% 1 is win
P(P==0) = -1;
P(P==2) = 0;


% Create bet index
%%% 0 is bet min
%%% 1 is bet max
betminmax = bets;
betminmax(betminmax == 20) = 0;
betminmax(betminmax == 60) = 1;

if strfind(headerfile,'david')
	[extra performance] = david_data_parse;
end

% Demean and construct reaction time:
startTime(find(cashout==1)) = NaN;
startTime(find(toppedUp==1)) = NaN;
startTime(find(switches==1)) = NaN;
startTime(find(checkedScores==1)) = NaN;
%reaction = betTime(:,1) - startTime(:,1);

%reaction = (sqrt((betTime(1:end-1,2)-startTime(2:end,2)).^2 + ...
%	(betTime(1:end-1,3)-startTime(2:end,3)).^2))./(betTime(2:end,1)-startTime(1:end-1,1));

%reaction = (betTime(:,1)-startTime(:,1))./(sqrt((betTime(:,3)-startTime(:,3)).^2 + (betTime(:,2)-startTime(:,2)).^2));
reaction = betTime(:,1)-startTime(:,1);
reaction = reaction(idx);

fclose(f);

function [trialnum starttime] = get_start_t(timefile)

t = fopen(timefile,'r');

while ~feof(t)
	
	line = fgetl(t);
	
	% Parse line into tokens
	parsed = [];
	[parsed{1} remain] = strtok(line,' ');
	while ~isempty(remain)
		[tok remain] = strtok(remain,' ');
		parsed{end+1} = tok;
	end
	
	if strcmp(parsed(1),'Starting')
		currenttrial = str2num(['' parsed{4} '']);
		trialnum(currenttrial) = currenttrial;
		starttime(currenttrial) = str2num(['' parsed{6} '']);
	end
end
starttime = starttime';
fclose(timefile);