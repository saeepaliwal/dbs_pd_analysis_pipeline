function stats = exclude_subjects(exclude,stats)

for s = 1:2
    idx = 0;
    for e = exclude
        fields = fieldnames(stats{s});
        fields = setdiff(fields,{'hhgf_est','rw_est','winning_model',...
            'data','FE_grid','bms_results','response_models'});
 
        for i = 1:length(stats{s}.labels)
            str= stats{s}.labels{i};
            num = regexp(str,'\d');
            pat_num = str2num(str(num));
            if pat_num==e
                idx = i;
            end
        end
        for f = 1:length(fields)
            if strcmp(fields{f},'all_bets')
                stats{s}.(fields{f})(:,idx) = [];
            else
                stats{s}.(fields{f})(idx) = [];
            end
        end
    end
end
