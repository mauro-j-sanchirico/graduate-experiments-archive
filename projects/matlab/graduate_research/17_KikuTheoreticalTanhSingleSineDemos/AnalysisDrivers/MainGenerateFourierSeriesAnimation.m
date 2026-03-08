%% Generate Fourier Series Animation
%% Show Fourier Series Changes wrt. Gamma

clc; clear; close all;

addpath('../Math');

gif_file_name = '../Animations/FourierSeriesAnimation.gif';

set(groot, 'defaultTextInterpreter','latex');

default_blue = [0 0.4470 0.7410];


%% Sweep gamma and compute fourier series at each step

% Gamma sweep
d_gamma = 0.1;
gamma_sweep_up = 0:d_gamma:10;
gamma_sweep_down = 10:-d_gamma:0;
gamma_sweep = [gamma_sweep_up gamma_sweep_down];

% Time
T = 2*pi;
dt = 0.001;
t = 0:0.001:T+dt;

% Sinusoid params
omega = 1;
phi = 0;
psi = omega*t + phi;

num_fourier_harmonics = 25;

% Animate
h = figure('Renderer', 'painters', 'Position', [100 100 1400 600]);

% Delay time to start the animation
fps = 60;
delay_time = 1/fps;

for idx = 1:length(gamma_sweep)
    
    gamma = gamma_sweep(idx);
    v = gamma.*sin(psi);
    y = tanh(v);
    
    [a_fourier, b_fourier, c_fourier, n_fourier] = ...
        ComputeNumericalFourierSeries(t, y, num_fourier_harmonics);
    
    subplot(231)
    plot(psi, v);
    xlim([min(psi) max(psi)]);
    ylim([-max(gamma_sweep) max(gamma_sweep)]);
    xlabel('$$\psi$$');
    ylabel('$$v(\psi)$$');
    title('$$v(\psi) = \gamma sin(\psi)$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'$$0$$','$$\pi$$','$$2\pi$$'});
    
    subplot(232)
    plot(psi, y);
    xlim([min(psi) max(psi)]);
    ylim([-1.5 1.5]);
    xlabel('$$\psi$$');
    ylabel('$$y(\psi)$$')
    title('$$y(\psi) = tanh(\gamma sin(\psi))$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'$$0$$','$$\pi$$','$$2\pi$$'});
    
    subplot(233)
    plot(v, y);
    xlim([-max(gamma_sweep) max(gamma_sweep)]);
    ylim([-1.5 1.5]);
    xlabel('$$v(\psi)$$');
    ylabel('$$y(v(\psi))$$');
    title('$$y(v) = tanh(v)$$');
    grid on;
    grid minor;
    xticks(-max(gamma_sweep):5:max(gamma_sweep));
    
    subplot(234)
    bh = bar(gamma);
    ylim([min(gamma_sweep) max(gamma_sweep)]);
    xticks([]);
    title('$$\gamma$$');
    grid on;
    grid minor;
    bh(1).FaceColor = default_blue;
    
    subplot(235)
    bh = bar(c_fourier);
    xlim([min(n_fourier) max(n_fourier)+1]);
    ylim([0 1.5]);
    title('Fourier Magnitudes for $$y(\psi)$$');
    grid on;
    grid minor;
    bh(1).FaceColor = default_blue;
    
    subplot(236);
    plot(psi, y, 'color', 'g', 'linewidth', 6)
    hold on;
    PlotFourierSeries(t, a_fourier, b_fourier, n_fourier, default_blue);
    xlim([min(psi) max(psi)]);
    ylim([-1.5 1.5]);
    xlabel('$$\psi$$');
    ylabel('$$\hat{y}(\psi)$$')
    title('Fourier approx. to $$y(\psi)$$');
    grid on;
    grid minor;
    xticks(0:pi:2*pi);
    xticklabels({'$$0$$','$$\pi$$','$$2\pi$$'});
    
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

