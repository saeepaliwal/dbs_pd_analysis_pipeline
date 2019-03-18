function test_tapas_dcm_fmri_hier_prepare_inference(fp)
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

pars = struct();
model = struct();
inference = struct();

dcms = tapas_test_dcm_fmri_load_data();
pars = tapas_dcm_fmri_hier_pars(dcms, pars);
data = tapas_dcm_fmri_hier_data(dcms, pars);
model = tapas_dcm_fmri_hier_model(dcms, model, pars);
inference = tapas_dcm_fmri_hier_inference(dcms, inference, pars);

data = tapas_dcm_fmri_hier_prepare_data(data, model, inference);
model = tapas_dcm_fmri_hier_prepare_model(data, model, inference);

fprintf(fp, '================\n Test %s\n================\n', fname);

% Test whether there is any clear bug
try
    inference = tapas_dcm_fmri_hier_prepare_inference(data, model, inference);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

