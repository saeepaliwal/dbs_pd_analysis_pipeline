function stats = hhgf_analysis(STATS_PRE, STATS_POST,D)
%% Pre DBS

% Run analyses
[pre_stats] = hhgf_analysis_wrapper(STATS_PRE,D);
%% Post DBS

% Run analyses
[post_stats] = hhgf_analysis_wrapper(STATS_POST,D);

%% Combine stats

for i = 1:length(pre_stats{1}.labels)
    if ~strcmp(pre_stats{1}.labels{i}(1:end-4), ...
        post_stats{1}.labels{i}(1:end-5))
        error('Labels are not aligned correctly!');
    end
end

stats{1} = pre_stats{1};
stats{2} = post_stats{1};

end
