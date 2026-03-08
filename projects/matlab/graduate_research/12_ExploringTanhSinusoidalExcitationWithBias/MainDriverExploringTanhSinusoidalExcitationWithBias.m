%% Exploring Hyperbolic Tangent Under Sinusoidal Excitation with Bias

clc; clear; close all;

addpath('Plotting');
addpath('Math');


%% Parameters

EPS = 10^-10;

% Network
w0 = 1;
w1 = 1;

% Excitations
A0 = -1;

A1 = 5;
omega1 = 4*pi;
phi1 = 0;

% Gains as seen by the tanh (gamma)
gamma = [A0*w0 A1*w1];

% Time
dt = 0.0001;
T = 2*pi/omega1;
t = 0:dt:T;


%% Compute the Signal At Input to the Hyperbolic Tangent

x0 = A0;
x1 = A1*sin(omega1*t + phi1);
SECS_TO_CYCLES = 1/T;
cycles = t*SECS_TO_CYCLES;

v = w0*x0 + w1*x1;

PlotInputSignal(cycles, v);


%% Compute the Signal At Output to the Hyperbolic Tangent

y = tanh(v);
PlotOutputSignal(cycles, v, y)


%% Compute the Fourier Coefficients

N = 25;
[a, b, n] = ComputeNumericalFourierSeries(t, y, N);
PlotFourierSeries(a, b, n);


%% Reconstruct the function from the coefficients

y_fourier = ReconstructFunctionFromFourierSeries(a, b, n, t);
PlotReconstructedOutputSignal(cycles, y_fourier, y);


%% Identify the Roots of the Argument to Tanh
%
% The roots can be used to identify areas where the exponential series
% approximation breaks down.  Integrating near these areas using the
% exponential series will cause the result to diverge.  The method used in
% the GetVRoots() function is analytic AND will always return the roots in
% sorted order!!  This is took some additional steps which are detailed in
% page 4+5 of notes on "Tanh Under Sinusoidal Excitation with Bias".
%

theta = GetVRoots(gamma, omega1, phi1);
theta = theta.*SECS_TO_CYCLES;
PlotInputSignalWithRoots(cycles, v, theta);


%% Apply the Exponential Series Approximation to the Tanh

M = 100;
y_exp = ComputeTanhExponentialSeries(v, M);
PlotReconstructedOutputSignalWithRoots(cycles, y_exp, y, theta);


%% Compute the Fourier Series Using the Exponential Approximation

M = 100;

[a, b, n] = ComputeExponentialFourierSeries( ...
    t, gamma(1), gamma(2), omega1, phi1, N, M);

y_exp_fourier = ReconstructFunctionFromFourierSeries(a, b, n, t);

PlotFourierSeries(a, b, n);
PlotReconstructedOutputSignalWithRoots(cycles, y_exp_fourier, y, theta)
