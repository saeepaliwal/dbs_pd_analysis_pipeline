function test_tapas_dcm_fmri_hier_init_state(fp)
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
inference = tapas_dcm_fmri_hier_prepare_inference(data, model, inference);

fprintf(fp, '================\n Test %s\n================\n', fname);

% Test whether there is any clear bug
try
    tapas_dcm_fmri_hier_init_state(data, model, inference);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

try
    state = tapas_dcm_fmri_hier_init_state(data, model, inference);
    for i = 1:numel(state.graph{2}.y)
        assert(size(state.graph{2}.y{i}, 2) == 1, ...
            'Second dimension of graph{2}.y.mu is not correct.');
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

try
    state = tapas_dcm_fmri_hier_init_state(data, model, inference);
    for i = 1:numel(state.graph{3}.y)
        assert(size(state.graph{3}.y{i}.mu, 2) == 1, ...
            'Second dimension of graph{3}.y.mu is not correct.');
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

np = size(model.graph{4}.htheta.y.mu, 1);

try
    state = tapas_dcm_fmri_hier_init_state(data, model, inference);
    for i = 1:numel(state.graph{2}.y)
        assert(size(state.graph{2}.y{i}, 1) == np, ...
            'First dimension of graph{2}.y.mu is not correct.');
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

try
    state = tapas_dcm_fmri_hier_init_state(data, model, inference);
    for i = 1:numel(state.graph{3}.y)
        assert(size(state.graph{3}.y{i}.mu, 1) == np, ...
            'First dimension of graph{3}.y.mu is not correct.');
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

try
    state = tapas_dcm_fmri_hier_init_state(data, model, inference);

    for i = 1:numel(state.graph{4}.y)
        assert(isfield(state.graph{4}.y{i}, 'k'), ...
            'Graph{4}.y.k is missing.');
        assert(isfield(state.graph{4}.y{i}, 't'), ...
            'Graph{4}.y.t is missing.');
        assert(isfield(state.graph{4}.y{i}, 'mu'), ...
            'Graph{4}.y.mu is missing.');
        assert(size(state.graph{4}.y{i}.mu, 1) == np, ...
            'First dimension of graph{4}.y.mu is not correct.');
        assert(size(state.graph{4}.y{i}.mu, 2) == 1, ...
            'Second dimension of graph{4}.y.mu is not correct.');
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

