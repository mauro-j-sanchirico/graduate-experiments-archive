%% Generate Fourier Series Animation
%% Show Fourier Series Changes wrt. Gamma

clc; clear; close all;

addpath('../Math');
addpath('../Math/TaylorFourierSeries/');
addpath('../Math/LookupTables/');

gif_file_name = '../Animations/TaylorFourierSeriesAnimation.gif';

set(groot, 'defaultTextInterpreter', 'latex');

default_blue = [0 0.4470 0.7410];


%% Sweep gamma and compute fourier series at each step

% Gamma sweep
d_gamma = 0.02;
gamma_sweep_up = 0:d_gamma:3;
gamma_sweep_down = 3:-d_gamma:0;
gamma_sweep = [gamma_sweep_up gamma_sweep_down];

% Time
T = 2*pi;
dt = 0.001;
t = 0:0.001:T+dt;

% Sinusoid params
omega = 1;
phi = 0;
psi = omega*t + phi;

% Approximation params
num_fourier_harmonics = 7;

% Number of inner sum terms should equal number of Fourier harmonics
num_inner_sum_terms = num_fourier_harmonics;

% Animate
h = figure('Renderer', 'painters', 'Position', [100 100 1400 600]);

% Delay time to start the animation
fps = 60;
delay_time = 1/fps;

for idx = 1:length(gamma_sweep)
    
    gamma = gamma_sweep(idx);
    v = gamma.*sin(psi);
    y_true = tanh(v);
    
    [a_fourier_true, b_fourier_true, c_fourier_true, n_fourier_true] = ...
        ComputeNumericalFourierSeries(t, y_true, num_fourier_harmonics);
    
    [a_fourier_taylor, b_fourier_taylor, ...
     c_fourier_taylor, n_fourier_taylor] = ...
        ComputeTaylorFourierSeries(gamma, num_fourier_harmonics, ...
                                   num_inner_sum_terms);
                               
    y_taylor_fourier = ComputeReconstructedFunctionFromFourierSeries( ...
        a_fourier_taylor, b_fourier_taylor, ...
        n_fourier_taylor, psi);
    
    y_error = abs(y_taylor_fourier - y_true);
    
    c_error = abs(c_fourier_true - c_fourier_taylor);
    
    % Plot v signal
    subplot(241)
    plot(psi, v, '-', 'color', default_blue);
    xlim([min(psi) max(psi)]);
    ylim([-max(gamma_sweep) max(gamma_sweep)]);
    xlabel('$$\psi$$');
    ylabel('$$v(\psi)$$');
    title('$$v(\psi) = \gamma sin(\psi)$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'0','\pi','2\pi'});
    
    % Plot y wrt. psi
    subplot(242)
    plot(psi, y_true, '-', 'color', default_blue, 'linewidth', 4);
    hold on;
    plot(psi, y_taylor_fourier, '-r', 'linewidth', 1);
    xlim([min(psi) max(psi)]);
    ylim([-max(gamma_sweep) max(gamma_sweep)]);
    xlabel('$$\psi$$');
    ylabel('$$y(\psi)$$')
    title('$$y(\psi) = tanh(\gamma sin(\psi))$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'0','\pi','2\pi'});
    
    % Plot y wrt. v 
    subplot(243)
    plot(v, y_true, '-', 'color', default_blue, 'linewidth', 4);
    hold on;
    plot(v, y_taylor_fourier, '-r', 'linewidth', 1);
    xlim([-max(gamma_sweep) max(gamma_sweep)]);
    ylim([-1.5 1.5]);
    xlabel('$$v(\psi)$$');
    ylabel('$$y(v(\psi))$$');
    title('$$y(v) = tanh(v)$$');
    grid on;
    grid minor;
    xticks(-max(gamma_sweep):5:max(gamma_sweep));
    
    % Plot the error |y_tf - y_true|
    subplot(244)
    semilogy(psi, y_error, 'color', default_blue);
    xlim([min(psi) max(psi)]);
    ylim([10^-10 10^7+1]);
    xlabel('$$\psi$$');
    ylabel('$$\epsilon$$');
    title('$$\epsilon = |y(\psi) - y_a(\psi)|$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'0','\pi','2\pi'});
    yticks(10.^(-10:7));
    
    % Plot gamma
    subplot(245)
    bh = bar(gamma);
    ylim([min(gamma_sweep) max(gamma_sweep)]);
    xticks([]);
    title('$$\gamma$$');
    grid on;
    grid minor;
    set(bh, 'FaceColor', default_blue);
    
    % Plot Fourier
    subplot(246)
    bh = bar(n_fourier_true, [c_fourier_true' c_fourier_taylor']);
    xlim([min(n_fourier_true) max(n_fourier_true)+1]);
    ylim([0 1.5]);
    title('Fourier Magnitudes for $$y(\psi)$$');
    grid on;
    grid minor;
    bh(1).FaceColor = default_blue;
    bh(2).FaceColor = 'r';
    
    % Plot Fourier in time domain 
    subplot(247);
    plot(psi, y_true, 'color', 'g', 'linewidth', 6)
    hold on;
    PlotFourierSeries( ...
        t, a_fourier_true, b_fourier_true, n_fourier_true, default_blue);
    hold on;
    PlotFourierSeries( ...
        t, a_fourier_taylor, b_fourier_taylor, n_fourier_taylor, 'r');
    xlim([min(psi) max(psi)]);
    ylim([-1.5 1.5]);
    xlabel('$$\psi$$');
    ylabel('$$\hat{y}(\psi)$$')
    title('Fourier approx. to $$y(\psi)$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'0','\pi','2\pi'});
    
    % Plot Fourier error
    subplot(248)
    bh = bar(n_fourier_true, c_error);
    xlim([min(n_fourier_true) max(n_fourier_true)+1]);
    ylim([0 1.5]);
    title('Fourier Errors $$|c - c_a|$$');
    grid on;
    grid minor;
    bh(1).FaceColor = default_blue;
    
    drawnow
    
    frame_image = getframe(h);
    im = frame2im(frame_image); 
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF File 
    if idx == 1
        imwrite(imind, cm, gif_file_name, 'gif', ...
                'DelayTime', delay_time, ...
                'Loopcount', inf); 
    else
        imwrite(imind, cm, gif_file_name, 'gif', ...
               'DelayTime', delay_time, ...
               'WriteMode', 'append');
    end
    
    clf;
end

