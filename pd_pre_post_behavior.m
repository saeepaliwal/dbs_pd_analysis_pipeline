function pd_pre_post_behavior(exclude)
ANALYSES= {'PRE_DBS';'POST_DBS'};
load all_patients

bets = zeros(100,2,length(all_patients));
for k = 1:length(ANALYSES)
    ANALYSIS_NAME = ANALYSES{k};
    STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_' ANALYSIS_NAME '.mat'];
    load(STATS_STRUCT);
   
    for i = 1:length(stats{1}.labels)
        
        out = regexp(stats{1}.labels(i),'\d*','Match');
        num = str2double(out{:});
        
        idx = find(all_patients == num);
        
        bets(:,k,idx) = stats{1}.data{i}.bets;
        machine_switches(:,k,idx) = stats{1}.data{i}.machineSwitches;
        gamble(:,k,idx) = stats{1}.data{i}.gamble;
    end
end

%% Figure
M = 5;
D = 5;
N = 5;
figure(101)
clf

%toplot = [1 4 23];

for j = 1:size(bets,3)
    %i = toplot(j);
    subplot(6,6,j);
    [n1,x1] = hist(log(bets(:,1,j)),M);
    hold on;
    [n2,x2] = hist(log(bets(:,2,j)),M);
    
    bar(x2,n2/N/diff(x2(1:2)))
    bar(x1,n1/N/diff(x1(1:2)))
    
    
    aa = get(gca,'child');
    set(aa(1),'FaceColor','b','EdgeColor','none');
    set(aa(2),'FaceColor','r','EdgeColor','none');
    title(all_patients(i));
    
end

% purty_plot(101,'~/polybox/Projects/BreakspearCollab/results/figures/pre_post_bet','eps')

%% Density estimates, bet behavior pre and post

for j = 1:size(bets,3)
    [q, xq] = ksdensity(bets(:,1,j)); 
    q = q';
    [p, xp] = ksdensity(bets(:,2,j));
    p = p';
    KL(j) = q'*log(q)-q'*log(p);
end

figure(102)
plot(all_patients,KL)

keyboard


%% 










