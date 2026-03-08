%% Generate Taylor/Fourier Series Convergence Plots
%% Setup

clc; clear; close all;

addpath('../Math');
addpath('../Math/TaylorFourierSeries/');
addpath('../Math/LookupTables/')

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

% Series Params
num_fourier_harmonics_N = 8;
num_inner_sum_terms_M = 1:9;
n = 0:num_fourier_harmonics_N;

b1_theorem = zeros(size(num_inner_sum_terms_M));
b1_error = zeros(size(num_inner_sum_terms_M));

b3_theorem = zeros(size(num_inner_sum_terms_M));
b3_error = zeros(size(num_inner_sum_terms_M));

b5_theorem = zeros(size(num_inner_sum_terms_M));
b5_error = zeros(size(num_inner_sum_terms_M));

b7_theorem = zeros(size(num_inner_sum_terms_M));
b7_error = zeros(size(num_inner_sum_terms_M));

h = figure('Renderer', 'painters', 'Position', [200 400 800 600]);

for gamma_idx = 1:length(gamma_sweep)
    
    gamma = gamma_sweep(gamma_idx);
    
    fprintf('Analyzing gamma = %f\n', gamma);
    
    y = tanh(gamma.*sin(psi));
    
    [~, b_true, ~, ~] = ...
        ComputeNumericalFourierSeries(t, y, num_fourier_harmonics_N);
    
    b1_true = b_true(n == 1);
    b3_true = b_true(n == 3);
    b5_true = b_true(n == 5);
    b7_true = b_true(n == 7);
    
    for M_idx = 1:length(num_inner_sum_terms_M)
        
        M = num_inner_sum_terms_M(M_idx);
        
        fprintf('* Analyzing M = %i\n', M);
        
        [~, b_theorem, ~, ~] = ComputeTaylorFourierSeries( ...
            gamma, num_fourier_harmonics_N, M);
        
        b1_theorem(M_idx) = b_theorem(n == 1);
        b3_theorem(M_idx) = b_theorem(n == 3);
        b5_theorem(M_idx) = b_theorem(n == 5);
        b7_theorem(M_idx) = b_theorem(n == 7);
        
    end
    
    b1_error = abs(b1_true - b1_theorem);
    b3_error = abs(b3_true - b3_theorem);
    b5_error = abs(b5_true - b5_theorem);
    b7_error = abs(b7_true - b7_theorem);
    
    subplot(221);
    semilogy(num_inner_sum_terms_M, b1_error, 'linewidth', 2);
    hold on;
    grid on;
    grid minor;
    xlabel('$$Model\ Order\ (M)$$');
    ylabel('$$|b_1 - \hat{b_1}| $$');
    title('$$Convergence\ Analysis\ for\ b_1$$');
    
    subplot(222);
    semilogy(num_inner_sum_terms_M, b3_error, 'linewidth', 2);
    hold on;
    grid on;
    grid minor;
    xlabel('$$Model\ Order\ (M)$$');
    ylabel('$$|b_3 - \hat{b_3}| $$');
    title('$$Convergence\ Analysis\ for\ b_3$$');
    
    subplot(223);
    semilogy(num_inner_sum_terms_M, b5_error, 'linewidth', 2);
    hold on;
    grid on;
    grid minor;
    xlabel('$$Model\ Order\ (M)$$');
    ylabel('$$|b_5 - \hat{b_{5}}| $$');
    title('$$Convergence\ Analysis\ for\ b_5$$');
    
    subplot(224);
    semilogy(num_inner_sum_terms_M, b7_error, 'linewidth', 2);
    hold on;
    grid on;
    grid minor;
    xlabel('$$Model\ Order\ (M)$$');
    ylabel('$$|b_7 - \hat{b_7}| $$');
    title('$$Convergence\ Analysis\ for\ b_7$$');
    
end

saveas(h, '../Figures/TaylorFourierConvergencePlot.png');