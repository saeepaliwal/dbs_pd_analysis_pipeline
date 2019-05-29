function stats = construct_stats(D, subjects_to_include)

if ~iscell(D.LIST_OF_SUBJECT_DIRECTORIES)
    subject_dir = {D.LIST_OF_SUBJECT_DIRECTORIES};
else
    subject_dir = D.LIST_OF_SUBJECT_DIRECTORIES;
end

stats = {};
for i = 1:length(subject_dir)
    stats{i} = output2mat(subject_dir{i}, subjects_to_include);
end

for i = 1:length(stats{1}.labels)
    if ~strcmp(stats{1}.labels{i},stats{2}.labels{i})
        error('Labels are not aligned correctly!');
    end
end

cd(D.PROJECT_FOLDER)