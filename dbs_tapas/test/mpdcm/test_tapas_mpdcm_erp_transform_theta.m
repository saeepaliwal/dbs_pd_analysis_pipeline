function test_tapas_mpdcm_erp_transform_theta(fp)
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

d = tapas_mpdcm_erp_load_test_data();
[y, u, ~, ptheta] = tapas_mpdcm_erp_standard_data_set();
dcm = d{1};


try
    tapas_mpdcm_erp_transform_theta({dcm.M.pE});
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


try
    ntheta = tapas_mpdcm_erp_transform_theta({dcm.M.pE});
    tapas_mpdcm_erp_int_check_input(u, ntheta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

n2u = cell(1, 2);
n2u(:) = u{1};
n2theta = cell(1, 2);
n2theta(:) = {dcm.M.pE};

try
    ntheta = tapas_mpdcm_erp_transform_theta(n2theta);
    tapas_mpdcm_erp_int_check_input(u, ntheta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

