function test_tapas_mpdcm_erp_int(fp)
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


[y, u, theta, ptheta] = tapas_mpdcm_erp_standard_data_set();

ptheta.integ = 'euler';

% Test whether there is any clear bug
try
    y = tapas_mpdcm_erp_int(u, theta, ptheta);
    ty = y{:};
    ty(470:end)
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

d = tapas_mpdcm_erp_load_test_data();
dcm = d{1};
theta = tapas_mpdcm_erp_transform_theta({dcm.M.pE});

try
    y = tapas_mpdcm_erp_int(u, theta, ptheta);
    ty = y{:};
    ty
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

d = tapas_mpdcm_erp_load_test_data();
dcm = d{1};

theta = dcm.M.pE;
theta = tapas_mpdcm_erp_transform_theta({theta});

try
    y = tapas_mpdcm_erp_int(u, theta, ptheta);
    ty = y{:};
    ty
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

