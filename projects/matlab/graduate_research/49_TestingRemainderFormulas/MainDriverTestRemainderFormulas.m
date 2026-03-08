%% Tests Remainder Formulas for Partial Sums of Sine and Cosine
%% Expresses remainders in terms of hypergeometric functions

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);


%% Expansion of cosine

big_m_list = 1:5;
du = 0.05;

figure('Renderer', 'painters', 'Position', [10 60 900 450]);

for idx = 1:length(big_m_list)
    
    big_m = big_m_list(idx);
    
    % Compute the range of validity
    q = 2*big_m + 2;
    rho_cos = factorial(q)^(1/q);
    u = 0:du:rho_cos;
    
    % Compute the partial sum
    cos_partial_sum = zeros(size(u));
    
    for m = 0:big_m
        term = (-1)^m * u.^(2*m) / factorial(2*m);
        cos_partial_sum = cos_partial_sum + term;
    end
    
    % Compute the remainder
    remainder = cos(u) - cos_partial_sum;
    
    % Compute the factor of the remainder
    phi_factorial_term = u.^q ./ factorial(q);
    big_h_hypergeometric_term = hypergeom( ...
        1, [big_m+3/2, big_m+2], -u.^2 ./ 4);
    
    remainder_analytical = ...
        -(-1)^big_m * phi_factorial_term .* big_h_hypergeometric_term;
    
    subplot(311)
    plot(u, cos_partial_sum, 'r-');
    hold on;
    plot(u, cos(u), 'b-');
    title('Cosine and its Partial Sums')
    xlabel('$$u$$')
    legend('$$\cos_M(u)$$', '$$\cos(u)$$', 'location', 'southwest')
    grid on; grid minor;
    
    subplot(312)
    plot(u, big_h_hypergeometric_term, 'b-');
    hold on;
    plot(u, phi_factorial_term, 'r-');
    title('Factors of the Remainder of $$\cos_M(u)$$')
    xlabel('$$u$$')
    legend('Hypergeom.', 'Factorial', 'location', 'southwest')
    grid on; grid minor;
    
    subplot(313)
    plot(u, remainder, 'b', 'linewidth', 6);
    hold on;
    plot(u, remainder_analytical, 'g', 'linewidth', 2);
    title('Remainder of $$\cos_M(u)$$')
    xlabel('$$u$$')
    legend('Numerical', 'Analytical', 'location', 'southwest')
    grid on; grid minor;
    
end


%% Expansion of sine

big_m_list = 1:5;
du = 0.05;

figure('Renderer', 'painters', 'Position', [10 60 900 450]);

for idx = 1:length(big_m_list)
    
    big_m = big_m_list(idx);
    
    % Compute the range of validity
    q = 2*big_m + 3;
    rho_cos = factorial(q)^(1/q);
    u = 0:du:rho_cos;
    
    % Compute the partial sum
    sin_partial_sum = zeros(size(u));
    
    for m = 0:big_m
        term = (-1)^m * u.^(2*m+1) / factorial(2*m+1);
        sin_partial_sum = sin_partial_sum + term;
    end
    
    % Compute the remainder
    remainder = sin(u) - sin_partial_sum;
    
    % Compute the factor of the remainder
    phi_factorial_term = u.^q ./ factorial(q);
    big_h_hypergeometric_term = hypergeom( ...
        1, [big_m+5/2, big_m+2], -u.^2 ./ 4);
    
    remainder_analytical = ...
        -(-1)^big_m * phi_factorial_term .* big_h_hypergeometric_term;
    
    subplot(311)
    plot(u, sin_partial_sum, 'r-');
    hold on;
    plot(u, sin(u), 'b-');
    title('Sine and its Partial Sums')
    xlabel('$$u$$')
    legend('$$\sin_M(u)$$', '$$\sin(u)$$', 'location', 'southwest')
    grid on; grid minor;
    
    subplot(312)
    plot(u, big_h_hypergeometric_term, 'b-');
    hold on;
    plot(u, phi_factorial_term, 'r-');
    title('Factors of the Remainder of $$\sin_M(u)$$')
    xlabel('$$u$$')
    legend('Hypergeom.', 'Factorial', 'location', 'southwest')
    grid on; grid minor;
    
    subplot(313)
    plot(u, remainder, 'b', 'linewidth', 6);
    hold on;
    plot(u, remainder_analytical, 'g', 'linewidth', 2);
    title('Remainder of $$\sin_M(u)$$')
    xlabel('$$u$$')
    legend('Numerical', 'Analytical', 'location', 'southwest')
    grid on; grid minor;
    
end
