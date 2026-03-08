clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 14);

% Gain Steps
g_steps = 0:0.1:4;

% Number of harmonics
big_n = 5;

% Initialize numerical variables
for n = 0:big_n
    b_numerical_result{n+1} = zeros(size(g_steps));
end

% Initialize analytical variables
for n = 0:big_n
    b_analytical_result{n+1} = zeros(size(g_steps));
end

% Expansion params
big_m = 30;
r = 5;
coefs = ComputeModifiedPolyCoefsTanh(big_m*2 + 1, r);
coefs = fliplr(coefs);

dt = 0.001;
t = 0:dt:2*pi;

for idx = 1:length(g_steps)
   
    g = g_steps(idx);
    
    % Compute the function
    y = tanh(g*sin(t));

    % Compute the Fourier Series numerically
    [~, b_numerical, ~, n_vals] = ComputeNumericalFourierSeries(t, y, big_n);
    
    for n = n_vals
        b_numerical_result{n+1}(idx) = b_numerical(n+1);
    end
    
    % Use the formulas
    for n = n_vals
        summation = 0;
        for m = 0:big_m
            jdx = 2*m + 1;
            coef = coefs(jdx+1);
            g_power = g^(jdx);
            integrand = (sin(t).^jdx).*sin(n*t);
            integral = trapz(t, integrand);
            term = coef.*g_power.*integral;
            summation = summation + term;
        end
        b_analytical_result{n+1}(idx) = 1/pi*summation;
    end
end

% Make plots
for n = 1:2:big_n
    figure('Renderer', 'painters', 'Position', [100 100 800 400]);
    plot(g_steps, b_numerical_result{n+1}, 'kx', 'markersize', 10);
    hold on;
    plot(g_steps, b_analytical_result{n+1}, 'ko', 'markersize', 10);
    title(sprintf('Harmonic $$n = %d$$', n));
    xlabel('$$g$$');
    ylabel('$$b_n(g)$$');
    grid on;
    grid minor;
    legend('Numerical', 'Analytical', 'location', 'southeast');
    saveas(gcf,sprintf('harmonic%d.png', n));
end
