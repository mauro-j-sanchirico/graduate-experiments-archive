%% Compare Numerical Integration with Analytic Method of GR Rule 2.662.4
%% Setup

clc; clear; close all;


%% Parameters

a = -1;
b = 3;
m = 20;
x = 0:0.0001:2*pi/b;

y = sin(b.*x).^(2*m+1).*exp(a.*x);

figure;
plot(x, y);
grid on;
xlabel('x');
ylabel('f');
title('Function to be integrated');


%% Integrate Numerically

numerical_integral = trapz(x,y);

%% Integrate Analytically

x0 = x(1);
x1 = x(end);
analytic_integral = AnalyticGR2P662P4(x0, x1, a, b, m);

error = abs(numerical_integral - analytic_integral);
fprintf('Error between analytic and numerical: %f\n', error);

%% Test the Simplified Analytic Algorithm For Lower Bound of Zero

a = -1;
b = 20;
m = 20;
x = 0:0.0001:2*pi/b;

y = sin(b.*x).^(2*m+1).*exp(a.*x);

figure;
plot(x, y);
grid on;
xlabel('x');
ylabel('f');
title('Function to be integrated');

numerical_integral_from_zero = trapz(x,y);

x0 = x(1);
x1 = x(end);
analytic_integral_from_zero = AnalyticGR2P662P4From0(x1, a, b, m);

error = abs(numerical_integral_from_zero - analytic_integral_from_zero);
fprintf('Error between analytic and numerical: %f\n', error);

%% Test the Simplified Analytic Algorithm For Fixed Bounds [0 2*pi/b]

a = -1;
b = 20;
m = 20;
x = 0:0.0001:2*pi/b;

y = sin(b.*x).^(2*m+1).*exp(a.*x);

figure;
plot(x, y);
grid on;
xlabel('x');
ylabel('f');
title('Function to be integrated');

numerical_integral_from_zero = trapz(x,y);

x0 = x(1);
x1 = x(end);
analytic_integral_from_zero = AnalyticGR2P662P4FixedBounds(a, b, m);

error = abs(numerical_integral_from_zero - analytic_integral_from_zero);
fprintf('Error between analytic and numerical: %f\n', error);

