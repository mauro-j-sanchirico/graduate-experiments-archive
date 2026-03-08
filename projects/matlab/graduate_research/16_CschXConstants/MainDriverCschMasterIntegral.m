%% Main Driver to Analyze the Csch Master Integral
%% Builds tables analytically and numerically and compares them

clc; clear; close all;

dxi = 0.01;
approx_inf = 1000;

digits(64);

n = 1:50;
Mu_numerical = zeros(size(n));
Mu_analytical = vpa(zeros(size(n)));

for i = 1:length(n)
    
    Mu_numerical(i) = ...
        ComputeMuDefIntegral0InfNumerical(dxi, approx_inf, n(i));
    
    Mu_analytical(i) = ...
        ComputeMuDefIntegral0InfAnalytical(n(i));
    
end

Mu_errors_numerical_vs_analytical = ...
    abs(Mu_numerical - Mu_analytical) + eps;
Mu_errors_analytical_vs_rounded = ...
    abs(Mu_analytical - double(Mu_analytical));

Kappa_analytical = Mu_analytical ./ factorial(vpa(n));
Kappa_errors_analytical_vs_rounded = ...
    abs(Kappa_analytical - double(Kappa_analytical));


%% Plot the errors
%
% Note here that numerical errors are below machine epsilon when the
% Kappa table is computed ***before*** rounding back to double precision.
%

figure;
semilogy(n, Mu_errors_numerical_vs_analytical, 'kx');
hold on;
semilogy(n, Mu_errors_analytical_vs_rounded, 'ko');
grid on;
title('Mu Errors');
xlabel('n');
legend( ...
    'Error numerical vs. analytical', ...
    'Error analytical vs rounded analytical');

figure;
semilogy(n, Kappa_analytical, 'kx');
grid on;
title('Kappa Analytically Computed');
xlabel('n');

figure;
semilogy(n, Kappa_errors_analytical_vs_rounded, 'kx');
grid on;
title('Kappa Errors - Analytical vs. Rounded');