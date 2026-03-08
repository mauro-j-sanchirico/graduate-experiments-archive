function PlotFourierSeries(t, a, b, n, harmonic_color)

T = t(end) - t(1);

omega = 2*pi/T;

sum = zeros(size(t));
    
for idx = 1:length(n)
    
    % If even
    if mod(n(idx),2) == 0
        harmonic = a(idx)*cos(omega*n(idx)*t);
        plot(t, harmonic, '-', 'linewidth', 0.2, 'color', harmonic_color);
        hold on;
    else
        harmonic = b(idx)*sin(omega*n(idx)*t);
        plot(t, harmonic, '-', 'linewidth', 0.2, 'color', harmonic_color);
        hold on;
    end
    
    sum = sum + harmonic;
    
end

plot(t, sum, '-', 'linewidth', 2, 'color', harmonic_color);
    
end

