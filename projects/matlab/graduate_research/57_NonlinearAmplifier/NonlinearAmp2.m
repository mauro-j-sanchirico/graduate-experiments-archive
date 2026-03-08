clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 14);

% Gain Steps
g_steps = 0:0.1:4;

% DC Offset
d = 3/2;

% Number of harmonics
big_n = 5;

% Initialize numerical variables
a0_numerical_result = zeros(size(g_steps));

% Initialize analytical variables
a0_analytical_result = zeros(size(g_steps));

% Expansion params
big_m = 30;
r = 5;
coefs = ComputeModifiedPolyCoefsTanh(big_m*2 + 1, r);
coefs = fliplr(coefs);

dt = 0.001;
t = 0:dt:2*pi;
t_int = 0:dt:2*pi;

for idx = 1:length(g_steps)

    g = g_steps(idx);

    % Compute the function
    y = tanh(d + g*sin(t));

    % Compute the Fourier Series numerically
    [a_numerical, ~, ~, n_vals] = ComputeNumericalFourierSeries(t, y, big_n);

    a0_numerical_result(idx) = a_numerical(1);

    % Use the formulas
    summation = 0;
    
    for m = 0:big_m
        jdx = 2*m + 1;
        coef = coefs(jdx+1);
        integrand = (d + g*sin(t_int)).^jdx;
        nintegral = trapz(t_int, integrand);
        %aintegral = ComputeIntegralAnalytic(d, g, m)
        term = coef.*nintegral;
        summation = summation + term;
    end
    a0_analytical_result(idx) = 1/pi*summation;
end

% Make plots
figure('Renderer', 'painters', 'Position', [100 100 800 400]);
plot(g_steps, a0_numerical_result, 'kx', 'markersize', 10);
hold on;
plot(g_steps, a0_analytical_result, 'ko', 'markersize', 10);
%title(sprintf('Output DC Bias for Input DC Bias $$d = %.2f$$', d));
xlabel('$$g$$');
ylabel('$$a_0(g)$$');
grid on;
grid minor;
legend('Numerical', 'Analytical', 'location', 'northeast');
saveas(gcf,sprintf('output_bias_for_input_bias_eq_%0.2f.png', d));

