function [q] = excel_to_questionnaire(FILENAME)
% Run function:
% [questionnaire_struct] = excel_to_questionnaire_struct(FILENAME, varargin: extra_fields)
[data,text,raw] = xlsread(FILENAME);

fields = text(1,:);


textfields = {'ID','Gender','Clinical_Subtype','Tremor_Akinesia_Subtype',...
    'ICD','Side_of_Onset'};

%% Append fields to structure
q = struct;
for labelNum = 2:length(raw(:,1))
    q.labels{labelNum-1,1} = strrep(raw{labelNum,1},'_','');
end

for k = 2:size(raw,2)
    fieldname = strrep(fields{k},' ','_');
    fieldname = strrep(fieldname,'-','_');
    fieldname = strrep(fieldname,'&','_');
    fieldname = strrep(fieldname,'(','_');
    fieldname = strrep(fieldname,')','_');
    fieldname = strrep(fieldname,'/','_');
    fieldname = strrep(fieldname,'.','_');
    
    if any(contains(textfields,fieldname))
        q.(fieldname) = raw(2:end,k);
    else
        for l = 2:size(raw,1)
            q.(fieldname)(l-1,1) = raw{l,k};
        end
    end
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


