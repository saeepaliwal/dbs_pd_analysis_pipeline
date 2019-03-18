function [data] = tapas_test_linear_load_data()
%% Load the data for testing 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Get current location
f = mfilename('fullpath');

[tdir, ~, ~] = fileparts(f);

data = cell(3, 1);

dt = load(fullfile(tdir, 'data', 'data_20_4_10.mat'));
dt = dt.data;

data{1} = dt;

dt = load(fullfile(tdir, 'data', 'data_32_4_10.mat'));
dt = dt.data;

data{2} = dt;

dt = load(fullfile(tdir, 'data', 'data_48_4_10.mat'));
dt = dt.data;

data{3} = dt;


end

