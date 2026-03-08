%% Generate Exponential Fourier Series Convergence Plots
%% Shows Convergence of the Exponential Fourier Series wrt M and L

clc; clear; close all;

addpath('../Math');
addpath('../Math/ExponentialFourierSeries/');
addpath('../Math/LookupTables/');

set(groot, 'defaultTextInterpreter', 'latex');

default_blue = [0 0.4470 0.7410];


%% Plot mean square error wrt a grid of M and L points

% Gamma param
gamma = 1;

% Time
T = 2*pi;
dt = 0.001;
t = 0:0.001:T+dt;

% Sinusoid params
omega = 1;
phi = 0;
psi = omega*t + phi;

% Approximation params
num_fourier_harmonics = 4;

% Generate a grid of M and L points
M_sweep = 1:5;
L_sweep = 1:5:150;

% Make an LxM grid
[M_grid, L_grid] = meshgrid(M_sweep, L_sweep);

mse_b = zeros(size(M_grid));

% TODO: Sweep gamma and generate a plot at each sweep

for M_idx = 1:length(M_sweep)
    
    fprintf('Processing M_idx = %i/%i\n', M_idx, length(M_sweep));
    
    for L_idx = 1:length(L_sweep)
        
        M = M_grid(L_idx, M_idx);
        L = L_grid(L_idx, M_idx);
        
        v = gamma.*sin(psi);
        y_true = tanh(v);
        
        [a_fourier_true, ...
         b_fourier_true, ...
         c_fourier_true, ...
         n_fourier_true] = ComputeNumericalFourierSeries( ...
                               t, y_true, num_fourier_harmonics);

        [a_fourier_exp, ...
         b_fourier_exp, ...
         c_fourier_exp, ...
         n_fourier_exp] = ComputeExponentialFourierSeries( ...
                              gamma, num_fourier_harmonics, M, L);

        delta_b = b_fourier_true - b_fourier_exp;
        mse_b(L_idx, M_idx) = mean(delta_b.^2);
        
    end
    
end

h = figure('Renderer', 'painters', 'Position', [100 0 800 600]);

surf(M_grid, L_grid, log10(mse_b));

title_str = sprintf( ...
    'Convergence Plot over M and L for gamma = %f', gamma);

title(title_str);
xlabel('$$Exponential\ Expansion\ Order\ M$$');
ylabel('$$Taylor\ Expansion\ Order\ L$$');
zlabel('$$Error\ log10(MSE(b, b_a))$$');
view([-75 70]);

save_str = sprintf( ...
    '../Figures/ExponentialFourierConvergencePlotGamma%f.png', gamma);

saveas(h, save_str);

