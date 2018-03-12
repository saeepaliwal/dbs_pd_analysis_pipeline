function stats = load_questionnaires_and_anatomical_data(stats, D)
%% Pull in questionnaire data


Q_ANATOMICAL_FILE = [D.SPREADSHEET_DIR 'TimepointMaxAnatomical_Raw.xlsx'];

[q] = excel_to_questionnaire(Q_ANATOMICAL_FILE);
all_fields = fieldnames(q);
all_fields = setdiff(all_fields,'labels');
% Merge
for f = 1:length(all_fields)
    if contains(all_fields{f},'PRE')
        subj = [1];
        new_field = erase(all_fields{f},'_PRE');
        new_field = erase(new_field,'_z');
    elseif contains(all_fields{f},'FU3')
        subj = [2];
        new_field = erase(all_fields{f},'_FU3');
        new_field = erase(new_field,'_z');
    elseif contains(all_fields{f},'FU1') || contains(all_fields{f},'FU2') || contains(all_fields{f},'FU4')
        continue
    else
        subj = [1 2];
        new_field = all_fields{f};
    end
    
    for n  = subj
        num_labels = length(stats{n}.labels);
        for i = 1:num_labels
            str = stats{n}.labels{i};
            num = regexp(str,'\d');
            pat_num = str2num(str(num));
            idx = find(q.ID==pat_num);
            stats{n}.(new_field)(i) = q.(all_fields{f})(idx);
        end
    end
end

%% Load behavioral data

for s = 1:2
    P = length(stats{1}.labels);
    stats{s}.bets = zeros(P,1);
    stats{s}.machine_switches = zeros(P,1);
    stats{s}.gamble = zeros(P,1);
    stats{s}.cashout = zeros(P,1);
    stats{s}.all_bets = zeros(100,P,1);
    stats{s}.all_perf = zeros(100,P,1);
    for i = 1:length(stats{s}.labels)
        idx = max(find(stats{s}.data{i}.bets>0));
        N = 1:length(stats{s}.data{i}.bets);
        bet_increases = diff(stats{s}.data{i}.bets(1:idx));
        incr_idx = find(bet_increases>0);
        bet_increases = bet_increases(incr_idx);
        stats{s}.bets(i) = mean(bet_increases);
        stats{s}.all_bets(N,i) = stats{s}.data{i}.bets;
        stats{s}.machine_switches(i) = sum(stats{s}.data{i}.machineSwitches);
        stats{s}.gamble(i) = sum(stats{s}.data{i}.gamble);
        stats{s}.cashout(i) = sum(stats{s}.data{i}.cashout);
        stats{s}.perf(i) = mean(stats{s}.data{i}.performance(1:idx));
    end
end

