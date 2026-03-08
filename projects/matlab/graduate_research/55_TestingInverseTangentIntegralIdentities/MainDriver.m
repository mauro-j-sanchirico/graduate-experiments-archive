%% Testing Inverse Tangent Integral Identities
%% Tests identities for solving integrals x^n * sech(a*x + b)

clc; clear; close all;

%% Define some test parameters

% Parameters
a = pi/2;
b = 1i*pi/2;
j = 2;

% Bounds of integration
dx = 0.0001;
x0 = 0;
x1 = 6;

%% Test the integral numerically and analytically

ComputeSechLinearArgIntegralNumerically( ...
    a, b, j, x0, x1, dx)

ComputeSechLinearArgIntegralAnalytically( ...
    a, b, j, x0, x1)