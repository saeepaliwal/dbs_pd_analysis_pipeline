function test_tapas_dcm_fmri_hier_model(fp)
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

pars = struct();
dcms = tapas_test_dcm_fmri_load_data();
pars = tapas_dcm_fmri_hier_pars(dcms, pars);
model = struct();

% Test whether there is any clear bug
try
    tapas_dcm_fmri_hier_model(dcms, model, pars);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

% Test whether there is any clear bug
try
    model = tapas_dcm_fmri_hier_model(dcms, model, pars);
    tapas_validate_model(model);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

end

