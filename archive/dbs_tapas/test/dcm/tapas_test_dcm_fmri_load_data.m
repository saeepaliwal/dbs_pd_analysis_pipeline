function [data] = tapas_test_dcm_fmri_load_data()
%% Load the data for testing 
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

% Get current location
f = mfilename('fullpath');

[tdir, ~, ~] = fileparts(f);

data = cell(9, 1);

for i = 1:9
    fname = sprintf('dcmmodel.1.%02d.0.mat', i);
    tdcm = load(fullfile(tdir, 'data', fname));
    data{i} = tdcm.DCM;
end

end

