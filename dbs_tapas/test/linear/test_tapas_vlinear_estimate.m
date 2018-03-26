function test_tapas_vlinear_estimate(fp)
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
model = struct();
inference = struct();

data = tapas_test_linear_load_data();
td = data{1};
y = td(:, 1);
u = td(:, 2);

pars.nburnin = 100;
pars.niter = 200;

% Test whether there is any clear bug
try
    posterior = tapas_vlinear_estimate(y, u, model, inference, pars);
    fprintf(1, 'fe: %0.5f\n', posterior.fe);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

pars = struct();

% Test whether there is any clear bug
try
    posterior = tapas_vlinear_estimate(y, u, model, inference, pars);
    fprintf(1, 'fe: %0.5f\n', posterior.fe);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

end

