%% Truncation Analysis for Expansion of the Hyperbolic Tangent
%% Setup

clc; clear; close all;

set(0,'defaulttextInterpreter','latex');

%% Compute the Integrand

dx = 0.01;

x = 0.1:dx:1000;
n = 1:50;
y = zeros(length(x), length(n));
yp = zeros(length(x), length(n));

% Array to store zeros of the derivatives
z1 = zeros(size(n));
z2 = zeros(size(n));

% Compute the function
for idx = 1:length(n)
    y(:, idx) = ComputeCschFunction(x, n(idx));
end

% Compute first derivative
for idx = 1:length(n)
    yp(:, idx) = ComputeFirstDerivative(x, n(idx));
end

%% Analyze the integrand

% Find the functions' maxima
[max_vals_y, max_idxs_y] = max(y);
[min_vals_yp, min_idxs_yp] = min(yp);

% Find x val cooresponding to each extrema
x_max_y = x(max_idxs_y);
x_min_yp = x(min_idxs_yp);

% Find the y val at each extrema
y_at_x_min_yp = ComputeCschFunction(x_min_yp, n);

% Compute the taylor sine range of validity
rho = 0.8129*n + 1.3991;

% Compute the csch at the taylor range of validity
y_at_rho = ComputeCschFunction(rho, n);


%% For each n determine the percentage captured inside rho

percent_capture = zeros(size(n));

for idx = 1:length(n)
    
    this_y = y(:, idx);
    x1 = x(x < rho(idx));
    x2 = x(x >= rho(idx));
    
    y1 = this_y(x < rho(idx));
    y2 = this_y(x >= rho(idx));
    
    i1 = trapz(x1, y1);
    i2 = trapz(x2, y2);
  
    total = i1 + i2;
    percent_capture(idx) = i1/total*100;

end


%% Semilog Plot

nplot = 10;
xmax = 12;

figure;
subplot(211);
semilogy(x_max_y(1:nplot), max_vals_y(1:nplot), 'kx');
hold on;
semilogy(x_min_yp(1:nplot), y_at_x_min_yp(1:nplot), 'k^');
semilogy(rho(1:nplot), y_at_rho(1:nplot), 'ko');
semilogy(x, y(:,1:nplot), 'k');
grid on;
xlabel('$$x$$');
ylabel('Integrand');
xlim([0 xmax]);
legend( ...
    'Maximum', ...
    'Minimum of Derivative', ...
    'Integrands at \rho', ...
    'Integrands', 'location', 'best');
title('Integrand Critical Points and Taylor Range of Validity');

subplot(212);
semilogy(x_min_yp(1:nplot), abs(min_vals_yp(1:nplot)), 'k^');
hold on;
semilogy(x, abs(yp(:,1:nplot)), 'k');
grid on;
xlabel('$$x$$');
ylabel('Abs(First Derivative of Integrand)');
xlim([0 xmax]);
legend( ...
    'Minimum of Derivative', ...
    'derivatives','location', 'best');


%% Linear Plot

nplot = 5;
xmax = 8;

figure;
subplot(211);
plot(x, y(:,1:nplot), 'k');
hold on;
plot(x_max_y(1:nplot), max_vals_y(1:nplot), 'kx');
plot(rho(1:nplot), y_at_rho(1:nplot), 'ko');
plot(x_min_yp(1:nplot), y_at_x_min_yp(1:nplot), 'k^');
grid on;
xlabel('$$x$$');
ylabel('Integrand');
xlim([0 xmax]);
legend( ...
    'Maximum', ...
    'Minimum of Derivative', ...
    'Integrands at \rho', ...
    'Integrands', 'location', 'best');
title('Integrand Critical Points and Taylor Range of Validity');

subplot(212);
plot(x, yp(:,1:nplot), 'k');
hold on;
plot(x_min_yp(1:nplot), min_vals_yp(1:nplot), 'k^');
grid on;
xlabel('$$x$$');
ylabel('First Derivative of Integrand');
xlim([0 xmax]);
legend( ...
    'Minimum of Derivative', ...
    'derivatives','location', 'best');


%% Number of terms plot

figure;
plot(n, x_max_y, 'kx');
hold on;
semilogy(n, x_min_yp, 'k^');
semilogy(n, rho, 'ko');
grid on;
xlabel('Number of Terms');
legend( ...
    'Maximum of Integrand', ...
    'Minimum of Derivative of Integrand', ...
    'Range of Taylor Sine Validity', 'location', 'best');
title( ...
    'Critical Points and Range of Taylor  Validity wrt. Number of Terms');


%% Percent capture plot

figure;
plot(n, percent_capture, 'kx');
grid on;
xlabel('Number of Terms')
title('Percentage of Furthest Integral Captured');


%% Subroutines

function y = ComputeCschFunction(x, n)
y = csch((pi/2)*x).*x.^n;
end

function y = ComputeFirstDerivative(x, n)
y = -0.5*x.^(n - 1).*csch((pi/2)*x).*(pi*x.*coth((pi/2)*x) - 2*n);
end

