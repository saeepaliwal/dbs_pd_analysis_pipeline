function test_tapas_h2gf_mh_estimate(fp)
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

[data] = tapas_test_h2gf_load_data();

% Test whether there is any clear bug
try
    data = data{1}.GP.r;
    data.c_obs = ioio_constant_voltemp_exp_config();
    data.c_opt.opt_algo = @tapas_quasinewton_optim;
    tapas_h2gf_vb_estimate(data);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

