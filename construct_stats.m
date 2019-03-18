function stats = construct_stats(D)

if ~iscell(D.LIST_OF_SUBJECT_DIRECTORIES)
    subject_dir = {D.LIST_OF_SUBJECT_DIRECTORIES};
else
    subject_dir = D.LIST_OF_SUBJECT_DIRECTORIES;
end

stats = {};
for i = 1:length(subject_dir)
    stats{i} = output2mat(subject_dir{i});
end
