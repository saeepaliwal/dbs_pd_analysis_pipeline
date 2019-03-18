function [data] = tapas_test_h2gf_load_data()
%% Load the data for testing 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Get current location
f = mfilename('fullpath');

[tdir, ~, ~] = fileparts(f);

data = load(fullfile(tdir, 'data', 'hgfs.mat'));
data = data.results;

end

