function stats = load_FU4_and_anatomical_data(stats, D)

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
    elseif contains(all_fields{f},'FU4')
        subj = [2];
        new_field = erase(all_fields{f},'_FU4');
        new_field = erase(new_field,'_z');
    elseif contains(all_fields{f},'FU1') || contains(all_fields{f},'FU2') || contains(all_fields{f},'FU3')
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
    for i = 1:length(stats{s}.labels)
        N = 1:length(stats{s}.data{i}.bets);
        stats{s}.bets(i) = mean(stats{s}.data{i}.bets);
        stats{s}.all_bets(N,i) = stats{s}.data{i}.bets;
        stats{s}.machine_switches(i,s) = sum(stats{s}.data{i}.machineSwitches);
        stats{s}.gamble(i) = sum(stats{s}.data{i}.gamble);
        stats{s}.cashout(i) = sum(stats{s}.data{i}.cashout);
    end
end
