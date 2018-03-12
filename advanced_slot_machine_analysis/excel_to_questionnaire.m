function [q] = excel_to_questionnaire(FILENAME)
% Run function:
% [questionnaire_struct] = excel_to_questionnaire_struct(FILENAME, varargin: extra_fields)
[data,text,raw] = xlsread(FILENAME);

fields = text(1,:);

%% Append fields to structure
q = struct;
q.labels = data(:,1);
for k = 1:size(data,2)
    fieldname = strrep(fields{k},' ','_');
    fieldname = strrep(fieldname,'-','_');
    fieldname = strrep(fieldname,'&','_');
    fieldname = strrep(fieldname,'(','_');
    fieldname = strrep(fieldname,')','_');
    fieldname = strrep(fieldname,'/','_');
    fieldname = strrep(fieldname,'.','_');
    q.(fieldname) = data(:,k);
end

% Fix gender, if it exists
if isfield(q,'Sex')
    for i = 1:size(data,1)
        if strcmp(raw{i+1,2},'F')
            q.Sex(i) = 1;
        else
            q.Sex(i) = 0;
        end
    end
end
