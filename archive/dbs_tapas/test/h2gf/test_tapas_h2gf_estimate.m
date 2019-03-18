function test_tapas_h2gf_estimate(fp)
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

data = tapas_test_h2gf_load_data();

mdata = struct('y', cell(size(data, 1), 1), 'u', []);

for i = 1:size(data, 1);
    mdata(i).y = data{i, 10}.GP.y;
    mdata(i).u = data{i, 10}.GP.u;
end

model = data{1, 10}.GP.r;
model = rmfield(model, 'y');
model = rmfield(model, 'u');

model.c_prc.priormus = model.c_prc.priormus';
model.c_obs.priormus = model.c_obs.priormus';

% Test whether there is any clear bug
try
    tapas_h2gf_estimate(mdata, model);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


end

