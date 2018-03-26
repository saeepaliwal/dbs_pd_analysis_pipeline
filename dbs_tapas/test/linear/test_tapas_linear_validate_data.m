function test_tapas_linear_validate_data(fp)
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

data = tapas_test_linear_load_data();
td = data{1};
y = td(:, 1);
u = td(:, 2);

% Test whether there is any clear bug
try
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end


td = data{1};
y = td(:, 1);
u = td(:, 2);
% Test whether there is any clear bug
try
    u{10} = zeros(20, 3);
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    if strcmp(err.identifier, 'tapas:linear:validate_data')
        fprintf(fp, '       Passed\n');
    else
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        fprintf(fp, getReport(err, 'extended'));
    end
end

td = data{1};
y = td(:, 1);
u = td(:, 2);
try
    u{9} = zeros(19, 4);
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    if strcmp(err.identifier, 'tapas:linear:validate_data')
        fprintf(fp, '       Passed\n');
    else
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        fprintf(fp, getReport(err, 'extended'));
    end
end

td = data{1};
y = td(:, 1);
u = td(:, 2);
try
    y{1} = zeros(20, 2);
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    if strcmp(err.identifier, 'tapas:linear:validate_data')
        fprintf(fp, '       Passed\n');
    else
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        fprintf(fp, getReport(err, 'extended'));
    end
end

td = data{1};
y = td(:, 1);
u = td(:, 2);
try
    y{1} = zeros(19, 1);
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    if strcmp(err.identifier, 'tapas:linear:validate_data')
        fprintf(fp, '       Passed\n');
    else
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        fprintf(fp, getReport(err, 'extended'));
    end
end

td = data{1};
y = td(:, 1);
u = td(:, 2);
try
    y{3} = zeros(19, 1);
    tapas_linear_validate_data(y, u);
    fprintf(fp, '       Passed\n');
catch err
    if strcmp(err.identifier, 'tapas:linear:validate_data')
        fprintf(fp, '       Passed\n');
    else
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        fprintf(fp, getReport(err, 'extended'));
    end
end

end

