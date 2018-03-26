function [y] = test_tapas_mpdcm_erp_int_host(fp)
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


fprintf(fp, '================\n Test %s\n================\n', fname);


[y, u, theta, ptheta] = tapas_mpdcm_erp_2_source_data_set();

ptheta.integ = 'rk4';

% Test whether there is any clear bug
try
    y = tapas_mpdcm_erp_int_host(u, theta, ptheta, 1);
    ty = y{:};
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


d = tapas_mpdcm_erp_load_test_dcm_data_set();
dcm = d;
theta = tapas_mpdcm_erp_transform_theta_host({dcm.P});

try
    y = tapas_mpdcm_erp_int_host(u, theta, ptheta, 1);
    ty = y{:};
    ty
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

