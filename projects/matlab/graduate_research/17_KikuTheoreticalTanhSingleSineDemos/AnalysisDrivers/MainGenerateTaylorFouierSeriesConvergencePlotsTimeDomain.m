%% Generate Taylor/Fourier Series Convergence Plots
%% Setup

clc; clear; close all;

addpath('../Math');
addpath('../Math/TaylorFourierSeries/');
addpath('../Math/LookupTables/');

gif_file_name = '../Animations/FourierSeriesAnimation.gif';

set(groot, 'defaultTextInterpreter','latex');

default_blue = [0 0.4470 0.7410];


%% Sweep Gamma and Plot Convergence wrt. M for N Harmonics

% Gamma sweep
gamma_sweep = pi/8:pi/8:5*pi/8;

% Time
T = 2*pi;
dt = 0.001;
t = 0:0.001:T+dt;

% Sinusoid params
omega = 1;
phi = 0;
psi = omega*t + phi;

% Series params
model_orders = 1:7;

mse = zeros(size(model_orders));

h = figure('Renderer', 'painters', 'Position', [200 400 800 600]);

for gamma_idx = 1:length(gamma_sweep)
    
    gamma = gamma_sweep(gamma_idx);
    
    fprintf('Analyzing gamma = %f\n', gamma);
    
    y_true = tanh(gamma.*sin(psi));
    
    for M_idx = 1:length(model_orders)
        
        M = model_orders(M_idx);
        
        fprintf('* Analyzing M = %i\n', M);
        
        [a_theorem, b_theorem, c_theorem, n_theorem] = ...
            ComputeTaylorFourierSeries(gamma, M, M);

        y_theorem = ComputeReconstructedFunctionFromFourierSeries( ...
            a_theorem, b_theorem, n_theorem, t);
        
        mse(M_idx) = mean((y_true - y_theorem).^2);
        
    end
    
    semilogy(model_orders, mse, 'linewidth', 3);
    xlabel('$$Model\ Order\ (M)$$');
    ylabel('$$MSE(y, y_a)$$');
    title('Convergence\ Analysis');
    hold on
    grid on;
    grid minor;

end

legend( ...
    '\gamma = \pi/8', ...
    '\gamma = \pi/4', ...
    '\gamma = 3\pi/8', ...
    '\gamma = \pi/2', ...
    '\gamma = 5\pi/8' ...
);

saveas(h, '../Figures/TaylorFourierConvergencePlotTimeDomain.png');
