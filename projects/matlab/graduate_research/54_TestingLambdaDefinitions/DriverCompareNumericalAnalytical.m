clc; clear; close all;

lower_bound = 0.01;
upper_bound = 3;
dxi = 0.0001;
j = 2;
a = pi/2;

schr_numerical = ComputeSchrNumerical( ...
    lower_bound, upper_bound, dxi, j, a);

schr_analytical = ComputeSchrAnalytical( ...
    lower_bound, upper_bound, j, a);

fprintf('schr numerical: %f\n', schr_numerical);
fprintf('schr analytical: %f\n', schr_analytical);

cshr_numerical = ComputeCshrNumerical( ...
    lower_bound, upper_bound, dxi, j, a);

cshr_analytical = ComputeCshrAnalytical( ...
    lower_bound, upper_bound, j, a);

fprintf('cshr numerical: %f\n', cshr_numerical);
fprintf('cshr analytical: %f\n', cshr_analytical);
