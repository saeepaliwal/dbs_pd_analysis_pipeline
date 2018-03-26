function test_tapas_mpdcm_erp_int_check_input(fp)
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

try
    tapas_mpdcm_erp_int_check_input(u, theta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

