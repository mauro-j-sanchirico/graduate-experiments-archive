%% Sine Gaussian Train
%% Represents a Sine Wave as a Train of Gaussians

clc; clear; close all;

addpath('./Math');


%% Setup

% frequencies and periods
omega_vect = [1 2 3]';
P_vect = 2*pi./omega_vect;

% Phase shifts - not considered in this analysis
phi_vect = [0 0 0]';

% Amplitudes
A_vect = [1 1 1]';

% Bias
A0 = 0.5;

% Number of signals
N_s = length(omega_vect) + 1;

% Master period and master frequency
P_M = double(lcm(sym(P_vect)));
omega_M = 2*pi/P_M;

% Time
dt = 0.01;
t = 0:dt:P_M;
t_mat = repmat(t, length(omega_vect), 1);

% Sinusoid argument vector psi
phi_mat = repmat(phi_vect, 1, length(t));
psi_mat = diag(omega_vect)*t_mat + phi_mat;
x_0_mat = diag(A_vect)*sin(psi_mat);

% Append bias signal
A0_vect = ones(1, length(t))*A0;
x_0_mat = [A0_vect; x_0_mat];
t_mat = [t; t_mat];

% First layer hidden weights
w_vect_0 = ones(1, N_s);

% Second layer hidden weights
w_vect_1 = 1;

% Signal at input to the nonlinearity
v = sum(diag(w_vect_0)*x_0_mat);

% Get the gaussian distribution matrix
d = GetGaussian(t, t, dt);

% Cubing before...
% figure;
% plot(t, sin(t).*sum(d.^3) * dt^3);
% 
% % Cubing after...
% figure;
% plot(t, sum(d).^3 * dt^3);

d1 = GetGaussian(t, 2, dt);
d2 = GetGaussian(t, 1, dt);
sum_of_distributions = d1 + d2;
sum_cubed = sum.^3;
d13 = d1.^3;
d23 = d2.^3;
sum_of_cubes = d13 + d23;

figure;
plot(t, d1, 'linewidth', 6);
hold on;
plot(t, d2, 'linewidth', 6);
plot(t, sum, 'linewidth', 2);

figure;
plot(t, sum_cubed, 'linewidth', 6);
hold on
plot(t, sum_of_cubes, 'linewidth', 2);

sum(sum_cubed)*dt

sum(sum_of_cubes)*dt




