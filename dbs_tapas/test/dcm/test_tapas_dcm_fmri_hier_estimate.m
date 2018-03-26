function test_tapas_dcm_fmri_hier_estimate(fp)
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

dcms = tapas_test_dcm_fmri_load_data();

for i = 1:numel(dcms)
    dcms{i}.options.detrend_u = 0;
end

model = struct();
inference = struct();
pars = struct();
pars.ndiag = 20;

% Test whether there is any clear bug
try
    tapas_dcm_fmri_hier_estimate(dcms, model, inference, pars);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

