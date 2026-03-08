% Simulates a traveling water wave

clc; clear; close all;

% Wave params
k = 0.5;       % Wavenumber
alpha = 12;  % Outside amplitude
delta = -5;  % Where the wave starts

% Time
t_start = 0;
t_end = 15;
dt = 0.2;

t = t_start:dt:t_end;

% Distance
x_start = 0;
x_stop = 50;
dx = 0.1;

% Animation params
fps = 32;
delay_time = 1/fps;

x = x_start:dx:x_stop;

v = 4*k^3;
fprintf('Simulating wave with velocity = %.2f mps\n', v);

h = figure;
axis tight manual; % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';

for idx = 1:length(t)
    
    u = 12 * k^2 / alpha * sech(k*x - 4*k^3*t(idx) + delta).^2;
    plot(x, u, 'linewidth', 3);
    
    xlim([min(x), max(x)]);
    ylim([0, 3*12*k^2 / alpha]);
    
    title_str = sprintf('t = %0.2f s', t(idx));
    title(title_str);
    xlabel('x (m)');
    ylabel('u (m)');
    grid on;
    
    drawnow
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF File 
    if idx == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delay_time); 
    else 
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay_time); 
    end

end
