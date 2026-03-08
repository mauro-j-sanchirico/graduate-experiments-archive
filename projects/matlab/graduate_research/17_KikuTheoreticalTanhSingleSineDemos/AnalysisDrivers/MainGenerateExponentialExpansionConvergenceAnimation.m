%% Generates convergence analysis for exp series approx. to tanh(v)
%% Show convergence wrt. number of terms and wrt. dv

clc; clear; close all;

addpath('../Math');

gif_file_name = '../Animations/ExponentialExpansionConvergenceAnimation.gif';

set(groot, 'defaultTextInterpreter', 'latex');

default_blue = [0 0.4470 0.7410];
light_blue = [0.5 0.9 0.9];


%% Increase M and Show Effect on Convergence

dv = 0.001;
M_sweep = 1:25;
v = -5:dv:5;
mse_wrt_M = zeros(size(M_sweep));

y_true = tanh(v);

% Animate
h = figure('Renderer', 'painters', 'Position', [100 100 1200 800]);

% Delay time to start the animation
fps = 2;
delay_time = 1/fps;

subplot(3,2,1:2);
hold on;
plot(v, y_true, 'color', light_blue, 'linewidth', 6);
xlim([min(v) max(v)]);
ylim([min(y_true)-0.5 max(y_true)+0.5]);
xlabel('$$v$$');
ylabel('$$y$$');
title( ...
    '$$y = \tanh(v)$$ vs. $$y_a = \textit{{\normalfont sign}}(v)((1+2\sum_{m=1}^{M}{(-1)^me^{-2m|v|}})$$');
grid on;
grid minor;

for idx = 1:length(M_sweep)
    
    M = M_sweep(idx);
    
    y_approx = ComputeTanhExpSeries(v, M);
    
    if mod(M,2) == 0
        exp_color = 'r';
    else
        exp_color = 'm';
    end
    
    error = abs(y_approx - y_true);
    
    mse_wrt_M(idx) = mean(error.^2);
    
    subplot(3,2,1:2)
    plot(v, y_approx, 'color', exp_color, 'linewidth', 0.2);
    hold on
    
    subplot(3,2,3:4)
    semilogy(v, error, 'color', exp_color, 'linewidth', 0.2);
    xlim([min(v) max(v)]);
    ylim([10^-21 10^0]);
    xlabel('$$v$$');
    ylabel('$$\epsilon$$');
    title('$$\epsilon = |y - y_a|$$');
    hold on;
    grid on;
    if idx == 1
        grid minor;
    end
    
    subplot(3,2,5)
    bh = bar(M);
    ylim([0, max(M_sweep)]);
    xticks([]);
    grid on;
    grid minor;
    bh(1).FaceColor = default_blue;
    bh(1).BarWidth = 0.5;
    title('$$M$$');
    
    subplot(3,2,6)
    semilogy(M, mse_wrt_M(idx), 'x', 'color', default_blue);
    xlim([0, max(M_sweep)]);
    ylim([10^-3 10^-1]);
    hold on;
    grid on;
    if idx == 1
        grid minor;
    end
    xlabel('$$M$$');
    ylabel('$$MSE(M)$$');
    title('$$\textit{\normalfont{Convergence Plot}}$$');

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
    
end

