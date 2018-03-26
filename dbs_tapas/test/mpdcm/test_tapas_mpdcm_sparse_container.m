function test_tapas_mpdcm_sparse_container(fp)
%% Test 
%
% fp -- Pointer to a file for the test output, defaults to 1
%

% aponteeduardo@gmail.com
%
% Author: Eduardo Aponte, TNU, UZH & ETHZ - 2015
% Copyright 2015 by Eduardo Aponte <aponteeduardo@gmail.com>
%
% Licensed under GNU General Public License 3.0 or later.
% Some rights reserved. See COPYING, AUTHORS.
%
% Revision log:
%
%

if nargin < 1
    fp = 1;
end

fname = mfilename();
fname = regexprep(fname, 'test_', '');


fprintf(fp, '================\n Test %s\n================\n', fname);

% Avoid weird problems
tapas_mpdcm_device_reset();
test_tapas_mpdcm_fmri_int_memory(fp, 'euler')

end

function test_tapas_mpdcm_fmri_int_memory(fp, integ)
%% Checks whether there is any segmentation error in a kamikaze way

[u0, theta0, ptheta] = standard_values(8, 8);

ptheta.integ = integ;

u = {u0};
theta = {theta0};

test_container(u, theta, ptheta);

%

u = cell(2, 1);
u(:) =  {u0};
theta = cell(2, 1);
theta(:) = {theta0};

test_container(u, theta, ptheta);

%

u = cell(2, 1);
u(:) =  {u0};
theta = cell(2, 8);
theta(:) = {theta0};

test_container(u, theta, ptheta);

%

u = cell(2, 1);
u(:) =  {u0};
theta = cell(2, 1);
theta(:) = {theta0};

test_container(u, theta, ptheta);

% Test the flags

u = cell(2, 1);
u(:) =  {u0};
theta = cell(2, 1);
theta0.fC = 0;
theta(:) = {theta0};
test_container(u, theta, ptheta);

% Test different dimensionality for u!

[u0, theta0, ptheta] = standard_values(8, 3);

ptheta.integ = integ;

test_container(u, theta, ptheta);

%

dim_u = 8;
dim_x = 8;

u0 = zeros(dim_u, 600);

u0(:, 1) = 20;
u0(:, 90) = 20;
u0(:, 180) = 20;
u0(:, 270) = 20;
u0(:, 360) = 20;
u0(:, 450) = 20;
u0(:, 540) = 20;

% Relaxation rate slope
rrs = 25;
% Oxigen extraction fraction E0
oef = 0.4;
% echo time
et = 0.04;  
% frequency offset of magnetized vessels
fomv = 40.3; 
% Venous volume fraction V0
vvf = 4.0;
% rho
rho = 4.3;

alpha = 0.32;
epsilon = 0.64;
gamma = 0.32;
K = 2.0;
tau = 1.0;

theta0 = struct('A', [], 'B', [], 'C', [], 'epsilon', [], ...
    'K', [], 'tau',  [], 'V0', 1.0, 'E0', 1.0, 'k1', 1.0, 'k2', 1.0, ...
    'k3', 1.0, 'alpha', 1.0, 'gamma', 1.0, 'dim_x', dim_x, 'dim_u', dim_u, ...
    'fA', 1, 'fB', 1, 'fC', 1 , 'fD', 0);

%%

theta0.A = -0.3*eye(dim_x, dim_x);
theta0.B = ones(dim_x, dim_x, dim_u);
theta0.C = eye(dim_x, dim_u);
theta0.D = zeros(dim_x, dim_x, dim_x);

%%

theta0.epsilon = epsilon*ones(dim_x, 1);
theta0.K = K*ones(dim_x, 1);
theta0.tau = tau*ones(dim_x, 1);

%%

theta0.alpha = alpha;
theta0.gamma = gamma;
theta0.E0 = oef;
theta0.V0 = vvf;
theta0.k1 = rho*fomv*et*oef;
theta0.k2 = epsilon*rrs*oef*et;
theta0.k3 = 1 - epsilon;

theta = {theta0};

ptheta = struct('dt', 1, 'udt', 0.125, 'dyu', 1.0, 'integ', integ);

u = cell(2, 1);
u(:) =  {u0};
theta = cell(2, 1);
theta(:) = {theta0};
test_container(u, theta, ptheta);

end


function [u, theta, ptheta] = standard_values(dim_x, dim_u)
%% Returns a parametrization that is expected to work properly

u = zeros(dim_u, 600);

u(:, 1) = 20;
u(:, 90) = 20;
u(:, 180) = 20;
u(:, 270) = 20;
u(:, 360) = 20;
u(:, 450) = 20;
u(:, 540) = 20;

theta = struct('A', [], 'B', [], 'C', [], 'epsilon', [], ...
    'K', [], 'tau',  [], 'V0', 1.0, 'E0', 0.7, 'k1', 1.0, 'k2', 1.0, ...
    'fA', 1, 'fB', 1, 'fC', 1, 'fD', 0, ...
    'k3', 1.0, 'alpha', 1.0, 'gamma', 1.0, 'dim_x', dim_x, 'dim_u', dim_u);

theta.A = -0.3*eye(dim_x);
theta.B = ones(dim_x, dim_x, dim_u);
theta.C = zeros(dim_x, dim_u);
theta.D = zeros(dim_x, dim_x, dim_x);

theta.epsilon = ones(dim_x, 1);
theta.K = ones(dim_x, 1);
theta.tau = ones(dim_x, 1);

ptheta = struct('dt', 1, 'dyu', 0.125, 'udt', 1);

end


function [ y ] = test_container(u, theta, ptheta)

fp = 1;
y = 1;
try
    m0 = tapas_mpdcm_device_memory();
    test_SparseContainer(theta);
    m1 = tapas_mpdcm_device_memory();
    if m0(1) ~= m1(1)
        d = dbstack();
        fprintf(fp, '   Not passed at line %d\n', d(1).line)
        fprintf(fp, 'Memory leak in GPU')
    else
        fprintf(fp, '    Passed\n')
    end
catch err
    d = dbstack();
    fprintf(fp, '   Not passed at line %d\n', d(1).line)
    fprintf(fp, getReport(err, 'extended'));    
end

end
