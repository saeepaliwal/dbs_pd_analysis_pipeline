function [dest] = copy_fields(dest, origin)
%% 
%
% Input
%
% Output
%

% aponteeduardo@gmail.com
% copyright (C) 2018
%

tfields = fields(origin);

for i = 1:numel(tfields)
    dest.(tfields{i}) = origin.(tfields{i});
end

end
