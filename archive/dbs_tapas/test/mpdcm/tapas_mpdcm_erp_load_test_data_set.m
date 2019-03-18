function [] = tapas_mpdcm_erp_load_test_data_set()
%% Loads the data set.
%
% Input
%
% Output
%

% aponteeduardo@gmail.com
% copyright (C) 2016
%


Get current location
f = mfilename('fullpath');

[tdir, ~, ~] = fileparts(f);

d = cell(5, 1);

d{1} = load(fullfile(tdir, 'data', 'd1.mat'));
d{2} = load(fullfile(tdir, 'data', 'd2.mat'));


end % tapas_mpdcm_erp_load_test_data_set 

