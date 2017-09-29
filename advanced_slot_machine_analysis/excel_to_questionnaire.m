function [q] = excel_to_questionnaire(FILENAME)
% Run function:
% [questionnaire_struct] = excel_to_questionnaire_struct(FILENAME, varargin: extra_fields)
[data text raw] = xlsread(FILENAME);
fields = text(1,2:end);

% %% Pull all total fields
% total_idx = [];
% for i = 1:length(fields)
%     if strfind(fields{i},'ID')
%         id_idx = i;
%     else      
%         total_idx = [total_idx i];
%     end
% end

total_idx = 1:size(data,2);
% 
% %% Pull extra fields
% if length(varargin)>0
%     for n = 1:length(varargin)
%         for m = 1:length(fields)
%             if strfind(fields{m},varargin(n))
%                 extra_idx = m;
%             end
%         end
%     end
% end

%% Append fields to structure
q = struct;
q.labels = text(2:end,1);
for k = total_idx
    fieldname = strrep(fields{total_idx(k)},' ','_');
    fieldname = strrep(fieldname,'-','_');
    fieldname = strrep(fieldname,'&','_');
    fieldname = strrep(fieldname,'(','_');
    fieldname = strrep(fieldname,')','_');
    fieldname = strrep(fieldname,'/','_');
    q.(fieldname) = data(:,total_idx(k));
end



