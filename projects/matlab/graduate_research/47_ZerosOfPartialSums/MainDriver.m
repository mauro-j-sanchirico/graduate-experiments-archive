clc; clear; close all;

addpath('./SinTaylorExpansion/')

set(groot, 'DefaultTextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 16);

m_index_max = 3;

t = 0:0.01:10;

rho_table = nan(m_index_max, 1);
rho_norm_table = nan(m_index_max, 1);

figure;

for big_m = 1:m_index_max
    
    sin_taylor_coefs = ...
        GetPolynomialCoefsSinTaylorSeries(big_m);
    
    % Turn sin(t) into sin(n*t)
    exponents = 0:(length(sin_taylor_coefs)-1);
    normcoefs = big_m.^(exponents);
    normcoefs(1:2:end) = 0;
    normcoefs = fliplr(normcoefs);
    
    sin_taylor_coefs_norm = normcoefs.*sin_taylor_coefs;
    
    partial_sum = polyval(sin_taylor_coefs, t);
    partial_sum_norm = polyval(sin_taylor_coefs_norm, t);
    
    % Get the largest real part of all the roots
    sin_taylor_roots = roots(sin_taylor_coefs);
    real_sin_taylor_roots = sort(real(sin_taylor_roots), 'descend');
    rho_table(big_m) = real(real_sin_taylor_roots(1));
    
    % Get the largest real part of all the roots of the normalized sum
    sin_taylor_norm_roots = roots(sin_taylor_coefs_norm);
    real_sin_taylor_norm_roots = sort(real(sin_taylor_norm_roots), 'descend');
    rho_norm_table(big_m) = real(real_sin_taylor_norm_roots(1));
    
    %plot(t, asinh(partial_sum./2)); hold on;
    %plot(t, asinh(partial_sum_norm./2)); hold on;
    
    r = roots(sin_taylor_coefs);
    rn = roots(sin_taylor_coefs_norm);
    subplot(211);
    plot(real(r), imag(r), 'k.');
    hold on;
    subplot(212);
    plot(real(rn), imag(rn), 'k.');
    hold on;
    
end

m = 1:length(rho_table);

% Try to compute a heuristic
q = polyfit(m(40:41), rho_table(40:41),1);

rho_approx = polyval(q, m);

% plot roots with respect to M
figure;
subplot(211)
plot(m, rho_table, 'ko'); hold on;
plot(m, rho_approx);
hold on;
grid on;
grid minor;
xlabel('$$M$$');
title('Range of validity $$\rho(M)$$');

subplot(212)
plot(m, rho_norm_table, 'kx');
hold on;
grid on;
grid minor;
xlabel('$$M$$');
title('Range of validity $$\rho(M)$$');

