function stats = hhgf_analysis(STATS_PRE, STATS_POST, flags)
%% Pre DBS
% Specify paths for data saving
ANALYSIS_NAME = 'PRE_DBS_RERUN';

% Run winning model from Paliwal Petzschner et al 2014
PAPER = 1;
HHGF = 1;

STATS_STRUCT = STATS_PRE;

% Run analyses
hhgf_analysis_wrapper

clear stats

%% Post DBS

% Specify paths for data saving
ANALYSIS_NAME = 'POST_DBS_RERUN';

% Run winning model from Paliwal Petzschner et al 2014
PAPER = 1;
HHGF = 1;

STATS_STRUCT = STATS_POST;

% Run analyses
hhgf_analysis_wrapper

clear stats
%% Combine stats

pre = load(STATS_PRE);
post = load(STATS_POST);

for i = 1:length(pre.stats{1}.labels)
    if ~strcmp(pre.stats{1}.labels{i}(1:end-4),post.stats{1}.labels{i}(1:end-5))
        error('Labels are not aligned correctly!');
    end
end

clear stats
stats{1} = pre.stats{1};
stats{2} = post.stats{1};


end
