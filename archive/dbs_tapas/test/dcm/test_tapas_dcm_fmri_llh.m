function test_tapas_dcm_fmri_llh(fp)
%% Test 
%
% fp -- Pointer to a file for the test output, defaults to 1
%
% aponteeduardo@gmail.com
% copyright (C) 2016
%

if nargin < 1
    fp = 1;
end

fname = mfilename();
fname = regexprep(fname, 'test_', '');

dcms = tapas_test_dcm_fmri_load_data();
[y, u, theta, ptheta] = tapas_mpdcm_fmri_tinput(dcms);

ptheta.theta0 = theta;
ptheta.integ = 'rk4';
theta = tapas_mpdcm_fmri_get_parameters(theta, ptheta);

fprintf(fp, '================\n Test %s\n================\n', fname);

data = struct('y', {y}, 'u', {u});

% Test whether there is any clear bug
try
    tapas_dcm_fmri_llh(data, theta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

dcms = tapas_test_dcm_fmri_load_data();
[y, u, theta, ptheta] = tapas_mpdcm_fmri_tinput(dcms);

theta = repmat(theta, 1, 5);

ptheta.theta0 = theta;
ptheta.integ = 'rk4';
theta = tapas_mpdcm_fmri_get_parameters(theta, ptheta);

fprintf(fp, '================\n Test %s\n================\n', fname);

data = struct('y', {y}, 'u', {u});

% Test whether there is any clear bug
try
    tapas_dcm_fmri_llh(data, theta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

