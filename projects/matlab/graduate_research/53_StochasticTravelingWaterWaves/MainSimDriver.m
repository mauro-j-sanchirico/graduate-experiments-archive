%% Simulation Driver for Wave Analysis
%% Analyzes traveling water wave heights

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 14);

addpath('Math/Integrals/CschIntegral');
addpath('Math/Integrals/SechIntegral');
addpath('Math/ModifiedExpansionSech2');
addpath('Analysis');


%% Build a modified sech-squared expansion

big_n = 50;
q = 2*big_n + 2;
r_fit = 10;
r_plot = 8.5;
n_list = 0:2*big_n;

sech2_coefs = ComputeModifiedNthCoefSech2(n_list, big_n, r_fit);

x = -r_plot:0.01:r_plot;
y_approx = polyval(fliplr(sech2_coefs), x);
y_true = sech(x).^2;

figure;
plot(x, y_true, 'linewidth', 6);
hold on;
plot(x, y_approx, 'linewidth', 2, 'color', 'g');
title('True and Approximate $$\mathrm{sech}^2(x)$$');
xlabel('$$x$$');
grid on;


%% Set parameters

% ------------------------------------------------------------------------
% Params
% ------------------------------------------------------------------------

alpha = 3;
delta = 0;
ka = 0.9;
kb = 1.2;
dk = 0.0001;
x_c = 5;
t_c = 1;
t_c_list = linspace(0, 2, 10);
x_c_list = linspace(0, 8, 10);
use_analytical_integrals = true;


%% Sweep t_c

u_bar_list_numerical = zeros(size(t_c_list));
u_bar_list_analytical = zeros(size(t_c_list));
sech2_max_arg_list = zeros(size(t_c_list));

for idx = 1:length(t_c_list)

    fprintf('Analyzing point %d ...\n', idx);
        
    % Run numerical simulation
    [k_numerical, u_numerical, u_bar_numerical, ~] = ...
        RunNumericalSimulation( ...
            alpha, delta, ka, kb, dk, x_c, t_c_list(idx));

    u_bar_list_numerical(idx) = u_bar_numerical;

    % Run analytical simulation
    [k_analytical, u_analytical, u_bar_analytical, sech2_max_arg] = ...
        RunAnalyticalSimulation( ...
            alpha, delta, ka, kb, dk, x_c, t_c_list(idx), ...
            sech2_coefs, use_analytical_integrals);
        
    sech2_max_arg_list(idx) = sech2_max_arg;
    u_bar_list_analytical(idx) = u_bar_analytical;
end

% Plot the max arg of the sech-squared that occurred during the sim run
figure;
plot(t_c_list, sech2_max_arg_list, 'kx', 'markersize', 10);
title('Maximum Argument of $$\mathrm{sech}^2(x)$$');
xlabel('$$t_c$$');
grid on; grid minor;

% Plot the Mean wave height at each time
figure('Renderer', 'painters', 'Position', [100 100 800 400]);
plot(t_c_list, u_bar_list_numerical, 'kx', 'markersize', 10);
hold on;
plot(t_c_list, u_bar_list_analytical, 'ko', 'markersize', 10);
%title(sprintf( ...
%    'Mean wave height for $$k \\in [%.2f, %.2f]$$ at $$x_c$$ = %.2f', ...
%    ka, kb, x_c));
xlabel('$$t_c$$');
ylabel('$$\bar{\eta}(x_c, t_c, k)$$');
grid on;
grid minor;
legend('Numerical', 'Analytical');
saveas(gcf, 'tc_sweep.png');


%% Sweep x_c

u_bar_list_numerical = zeros(size(x_c_list));
u_bar_list_analytical = zeros(size(t_c_list));
sech2_max_arg_list = zeros(size(x_c_list));

for idx = 1:length(x_c_list)
    
    fprintf('Analyzing point %d ...\n', idx);

    % Run numerical simulation
    [k_numerical, u_numerical, u_bar_numerical, sech2_max_arg] = ...
        RunNumericalSimulation( ...
            alpha, delta, ka, kb, dk, x_c_list(idx), t_c);
        
    u_bar_list_numerical(idx) = u_bar_numerical;
    sech2_max_arg_list(idx) = sech2_max_arg;
    
    % Run analytical simulation
    [k_analytical, u_analytical, u_bar_analytical, sech2_max_arg] = ...
        RunAnalyticalSimulation( ...
            alpha, delta, ka, kb, dk, x_c_list(idx), t_c, ...
            sech2_coefs, use_analytical_integrals);

    u_bar_list_analytical(idx) = u_bar_analytical;
    
end

figure;
plot(x_c_list, sech2_max_arg_list, 'kx', 'markersize', 10);
title('Maximum Argument of $$\mathrm{sech}^2(x)$$');
xlabel('$$x_c$$');
grid on; grid minor;

figure('Renderer', 'painters', 'Position', [100 100 800 400]);
plot(x_c_list, u_bar_list_numerical, 'kx', 'markersize', 10);
hold on;
plot(x_c_list, u_bar_list_analytical, 'ko', 'markersize', 10);
%title(sprintf( ...
%    'Mean wave height for $$k \\in [%.2f, %.2f]$$ at $$t_c$$ = %.2f', ...
%    ka, kb, t_c));
xlabel('$$x_c$$');
ylabel('$$\bar{\eta}(x_c, t_c, k)$$');
grid on;
grid minor;
legend('Numerical', 'Analytical');
saveas(gcf, 'xc_sweep.png');
