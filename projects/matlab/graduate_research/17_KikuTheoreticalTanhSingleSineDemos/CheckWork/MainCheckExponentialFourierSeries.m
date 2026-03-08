%% Generate Fourier Series Animation
%% Show Fourier Series Changes wrt. Gamma

clc; clear; close all;

addpath('../Math');
addpath('../Math/ExponentialFourierSeries/');
addpath('../Math/LookupTables')


%% Test the exponential fourier series approx against the numerical one

% Gamma
gamma = 3.7;

% Number of inner sum terms should equal number of Fourier harmonics
M = 4;
L = 399;
num_fourier_harmonics = 5;

% Time
T = 2*pi;
dt = 0.00001;
t = 0:dt:T+dt;

% Sinusoid params
omega = 1;
phi = 0;
psi = omega*t + phi;

v = gamma.*sin(psi);
y_true = tanh(v);

[a_fourier_true, b_fourier_true, ...
 c_fourier_true, n_fourier_true] = ...
    ComputeNumericalFourierSeries(t, y_true, num_fourier_harmonics);
    
[a_fourier_exp, b_fourier_exp, ...
 c_fourier_exp, n_fourier_exp] = ...
    ComputeExponentialFourierSeries(gamma, num_fourier_harmonics, ...
                                    M, L);

b_fourier_true
b_fourier_exp
