function test_tapas_vlinear_llh(fp)
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
data = tapas_test_linear_load_data();
td = data{1};
y = td(:, 1);
u = td(:, 2);

pars = struct();
inference = struct();
model = struct();

pars = tapas_linear_pars(pars);
data = tapas_linear_data(y, u, pars);
model = tapas_vlinear_model(model, pars);
inference = tapas_vlinear_inference(inference, pars);

data = tapas_linear_prepare_data(data, model, inference);
model = tapas_vlinear_prepare_model(data, model, inference);
inference = tapas_vlinear_prepare_inference(data, model, inference);
[state] = tapas_vlinear_init_state(data, model, inference);

% Test whether there is any clear bug
try
    tapas_vlinear_llh(state.graph{3}, state.graph{4}, ...
        model.graph{3}.htheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

% Test whether there is any clear bug
try
    [llh] = tapas_vlinear_llh(state.graph{3}, state.graph{4}, ...
        model.graph{3}.htheta);
    assert(size(llh, 1) == 1, 'llh shape is wrong');
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

% Test whether there is any clear bug
try
    [llh] = tapas_vlinear_llh(state.graph{3}, state.graph{4}, ...
        model.graph{3}.htheta);
    assert(size(llh, 2) == numel(pars.T), 'llh shape is wrong');
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

