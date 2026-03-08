%% Modified Expansion of Sech
%% Investigation into a modified expansion of the hyperbolic secant

clc; clear; close all;

set(groot, 'DefaultTextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 16);

addpath('./Math/CosTaylorExpansion/');
addpath('./Math/PolynomialTools/');
addpath('./Math/RhoTableBuilder/');
addpath('./Math/SechModifiedExpansion/');
addpath('./Math/SinTaylorExpansion/');
addpath('./Math/SpecialFunctions/');
addpath('./Math/TanhModifiedExpansion/');
addpath('./Visualization/');


%% The Hyperbolic Secant

v = -7:0.1:7;
y = sech(v);

figure;
plot(v, y, 'k-');
xlabel('$$v$$');
ylabel('$$y$$');
title('Hyperbolic Secant');
grid on; grid minor;


%% Step 1) Derive an alternate Taylor Series

% 1.1) Express the sech in terms of its inverse Fourier transform
%
% Note that the sech is it's own Fourier transform!

xi = 0:0.1:50;
y_fourier = zeros(size(v));

for idx = 1:length(v)
    integrand = sech(pi/2*xi).*cos(xi*v(idx));
    y_fourier(idx) = trapz(xi, integrand);
end

figure;
plot(v, y_fourier, 'k-');
xlabel('$$v$$');
ylabel('$$y_F$$');
title('Reconstructed from Fourier Transform');
grid on; grid minor;

% 1.2) Expand the Kernel
%
% Here we take the Taylor series of the kernel cos(xi*v)

y_fourier_taylor = zeros(size(v));
m_max = 40;

for idx = 1:length(v)
    sum = 0;
    for m = 0:m_max
        integrand = sech(pi/2*xi).*xi.^(2*m);
        integral = trapz(xi, integrand);
        term = integral * (-1)^m * v(idx)^(2*m) / factorial(2*m);
        sum = sum + term;
    end
    y_fourier_taylor(idx) = sum;
end

figure;
selection = abs(v) < pi/2;
plot(v(selection), y(selection), 'b-', 'linewidth', 6);
hold on;
plot(v(selection), y_fourier_taylor(selection), 'g-');
title('Reconstructed from Fourier with Taylor Kernel');
xlabel('$$v$$');
ylabel('$$y_{FT}$$');
grid on; grid minor;

% 1.3) Solve the remaining definite integral

m = 6;

integrand = xi.^(2*m) .* sech(pi/2*xi);
integral_numerical = trapz(xi, integrand)
integral_analytical = abs(euler(2*m))
error = abs(integral_numerical - integral_analytical)

% 1.4) Recover the Taylor series

y_taylor = zeros(size(v));

for m = 0:m_max
    term = euler(2*m)*v.^(2*m)/factorial(2*m);
    y_taylor = y_taylor + term;
end

figure;
selection = abs(v) < pi/2;
plot(v(selection), y(selection), 'b-', 'linewidth', 6);
hold on;
plot(v(selection), y_taylor(selection), 'g-');
title('Reconstructed from Taylor Series');
xlabel('$$v$$');
ylabel('$$y_{FT}$$');
grid on; grid minor;


%% 2) The Modification

% 2.1) Replace infinity with rho_v

rho_v = 100;
dxi = 0.1;
xi = 0:dxi:rho_v;

% 2.2) Analyze the integrand

m_max = 10;
m = 0:m_max;

f_sech = zeros(length(xi), length(m));
f_csch = zeros(length(xi), length(m));

for idx = 1:length(m)
    f_sech(:, idx) = xi.^(2*m(idx)) .* sech(pi/2 * xi);
    f_csch(:, idx) = xi.^(2*m(idx)+1) .* csch(pi/2 * xi);
end

figure;
loglog(xi, f_sech, 'k-', 'linewidth', 1);
hold on;
loglog(xi, f_csch, 'k--', 'linewidth', 1);
title('$$f_S(\xi) = \xi^{2m}\mathrm{sech}\left(\frac{\pi}{2}\xi\right), f_C(\xi) = \xi^{2m+1}\mathrm{csch}\left(\frac{\pi}{2}\xi\right)$$');
xlabel('$$\xi$$');
grid on; grid minor;

% 2.3) Determine the percentage of the integral captured for upper bound u

rho_v = 30;
dxi = 0.1;
xi = 0:dxi:rho_v;

figure;
for m = 1:10
    integrand = xi.^(2*m).*sech(pi/2*xi);
    cumsum_integral = cumsum(integrand)*dxi;
    integral = abs(euler(2*m));
    fraction_captured = cumsum_integral/integral;
    plot(xi, fraction_captured, 'k');
    hold on;
end

grid on;
grid minor;
xlabel('$$u$$');
ylabel('$$\kappa(u)$$')
title('$$\frac{\int_0^u \! f(\xi) \, \mathrm{d}x}{\int_0^\infty \! f(\xi)\, \mathrm{d}x}$$, $$f(\xi) = \xi^{2m-1}\mathrm{csch}(\frac{\pi}{2}\xi)$$, $$m = 1...10$$');

% 2.4) Confirm that the limit as x to infinity of the integrand is 0
%
% https://www.wolframalpha.com/input/?i=limit+x+to+infinity+x%5E%282*m%29+*+sech%28pi%2F2*x%29


%% Determine rho_v

% 3.1) Take the partial sum of the kernel

u = 0:0.01:20;

figure;
for big_m = 1:30
    taylor_poly_coefs_cos = GetPolynomialCoefsCosTaylorSeries(big_m);
    taylor_coefs_cos = ComputeCosTaylorCoefs(big_m);
    cos_approx = EvaluateCosTaylorSeries(u, taylor_coefs_cos, big_m);
    cos_approx_poly = polyval(taylor_poly_coefs_cos, u);
    plot(u, cos_approx_poly, 'k--', 'linewidth', 1); hold on;
    plot(u, cos_approx, 'k+', 'linewidth', 1); hold on;
end

plot(u, cos(u), 'b-', 'linewidth', 1);
ylim([-1,1])


% 3.2) Compute rho(M)
m_index_max = 40;
root_type = 1;
plot_flag = false;

rho_cos_table = BuildRhoTable( ...
    m_index_max, root_type, 'cos', plot_flag);
rho_sin_table = BuildRhoTable( ...
    m_index_max, root_type, 'sin', plot_flag);


%% 4) Solve the indefinite integral

epsilon = 1e-8;
dxi = 0.0001;
j_index = 4;
rho_v = 11.06;

% Numerical
a = pi/2;
xi = epsilon:dxi:rho_v;
integrand = xi.^j_index.*sech(a*xi);
integral_numerical = trapz(xi, integrand)

% Analytical
big_lambda_antiderivative_at_rho_v = ...
    ComputeLambdaSechAntiderivative(j_index, rho_v);

big_lambda_antiderivative_at_0 = ...
    ComputeLambdaSechAntiderivative(j_index, 0);

integral_analytical = ...
    big_lambda_antiderivative_at_rho_v ...
  - big_lambda_antiderivative_at_0


%% 4) Confirm that the tanh indefinite integral still works...

epsilon = 1e-8;
dxi = 0.0001;
j_index = 4;
rho_v = 11.06;

% Numerical
a = pi/2;
xi = epsilon:dxi:rho_v;
integrand = xi.^j_index.*csch(a*xi);
integral_numerical = trapz(xi, integrand)

% Analytical
big_lambda_antiderivative_at_rho_v = ...
    ComputeLambdaTanhAntiderivative(j_index, rho_v);

big_lambda_antiderivative_at_epsilon = ...
    ComputeLambdaTanhAntiderivative(j_index, epsilon);

integral_analytical = ...
    big_lambda_antiderivative_at_rho_v ...
  - big_lambda_antiderivative_at_epsilon


% Analyze a mu function - uninteresting
% xi = 0:0.1:15;
% a = pi/2;
% 
% figure;
% 
% for j_index = 1:6
%     mu = ComputeMuFunction(j_index, a, exp(a*xi));
%     plot(xi, asinh(mu/2));
%     hold on;
% end


%% Put the full sech expansion together

number_terms_big_m = 20;
epsilon = 0;
dxi = 0.0001;
max_v = 4;
root_type = 1;
plot_flag = false;
numerical_integral_flag = true;

rho_cos_table = BuildRhoTable( ...
    number_terms_big_m, root_type, 'cos', plot_flag);

poly_coefs = GetPolynomialCoefsSechModifiedExpansion( ...
    number_terms_big_m, epsilon, dxi, max_v, ...
    rho_cos_table, numerical_integral_flag);

v = -max_v:0.01:max_v;
sech_modified = polyval(poly_coefs, v);

figure;
plot(v, sech(v), 'b', 'linewidth', 6);
hold on;
plot(v, sech_modified, 'g', 'linewidth', 2);

