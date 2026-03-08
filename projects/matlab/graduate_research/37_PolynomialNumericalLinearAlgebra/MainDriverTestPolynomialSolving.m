%% Test Polynomial Numerical Linear Algebra Framework
%% Tries to Solve Different Polynomial Systems Using Maculay Matricies

clc; clear; close all;
set(0, 'defaultTextInterpreter', 'latex');
rng(1);

addpath('./PolynomialNumericalLinearAlgebra/');
addpath('./PolynomialSystems/');


%% Test the polynomial system from the example

% f1 = 5.3*x1^2 + 9*x2*x3 - 1
% f2 = 2*x1^3 + 0.5*x2^2 - 7.89*x3 - 94
% f3 = x1 - 2.13

polynomial_system_p{1,1} = [5.3 9 -1];             % Coefficients
polynomial_system_p{1,2} = [2 0 0; 0 1 1; 0 0 0];  % Exponents

polynomial_system_p{2,1} = [2 0.5 -7.89 -94];            % Coefficients
polynomial_system_p{2,2} = [3 0 0; 0 2 0; 0 0 1; 0 0 0]; % Exponents

polynomial_system_p{3,1} = [1 -2.13];      % Coefficients
polynomial_system_p{3,2} = [1 0 0; 0 0 0]; % Exponents

% Solve the polynomial system
[found_roots_r, d, c, ns, check, cr, digits] = ...
    sparf(polynomial_system_p);

% Should be very small numbers
f_evaluated_roots = EvaluatePolynomialSystem( ...
    polynomial_system_p, found_roots_r);

% Verify that all roots are less than the threshold
threshold_epsilon = 1e-8;
valid_flags = TestPolynomialSystemRoots( ...
    polynomial_system_p, found_roots_r, threshold_epsilon);

fprintf('Roots (x_1 x_2 ... x_M):\n\n');
disp(found_roots_r);

fprintf('Polynomial evaluated at roots:\n\n');
disp(f_evaluated_roots);

fprintf('Root validity flags:\n\n');
disp(valid_flags);

