function test_tapas_mh_mc3_arc(fp)
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

nc = 10;
nr = 10;

nllh = zeros(nc, nr);
nlpp = zeros(nc, nr);

ollh = zeros(nc, nr);
olpp = zeros(nc, nr);

ratio = 0;

t = ones(1, nr);


% Test whether there is any clear bug
try
    tapas_mh_mc3_arc(ollh, olpp, nllh, nlpp, ratio, t);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

% Test whether there is any clear bug
try
    [v] = tapas_mh_mc3_arc(ollh, olpp, nllh, nlpp, ratio, t);
    if ~ all(size(v) == [nc, nr])
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    end
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    fprintf(fp, getReport(err, 'extended'));
end

end

