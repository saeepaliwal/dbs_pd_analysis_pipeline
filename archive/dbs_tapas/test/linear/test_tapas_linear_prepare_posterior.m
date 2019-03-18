function test_tapas_linear_prepare_posterior(fp)
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
model = tapas_linear_model(model, pars);
inference = tapas_linear_inference(inference, pars);

data = tapas_linear_prepare_data(data, model, inference);
model = tapas_linear_prepare_model(data, model, inference);
inference = tapas_linear_prepare_inference(data, model, inference);
[state] = tapas_linear_init_state(data, model, inference);

ns = 5000;
states = cell(ns * 2, 1);

for i = 1:ns
    [state] = tapas_mh_mc3_sample_node(data, model, inference, state, 2);
    [sstate, ~] = tapas_linear_get_stored_state(data, ...
         model, inference, state);
    states{i * 2 - 1} = sstate;
    [state] = tapas_mh_mc3_sample_node(data, model, inference, state, 2);
    [sstate, ~] = tapas_linear_get_stored_state(data, ...
         model, inference, state);
    states{i * 2 } = sstate;
end

% Test whether there is any clear bug
try
    tapas_linear_prepare_posterior(data, model, inference, states);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

% Test whether there is any clear bug
try
    posterior = tapas_linear_prepare_posterior(data, model, inference, states);
    fprintf(fp, 'fe: %0.5f\n', posterior.fe);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

