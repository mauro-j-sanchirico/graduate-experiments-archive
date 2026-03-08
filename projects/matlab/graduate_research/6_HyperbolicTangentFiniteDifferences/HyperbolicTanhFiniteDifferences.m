%% Hyperbolic Tanget Finite Differences Approximation
%% Setup

clc; clear; close all;

%% Params

N = 20;

%% Finite Difference Operator

x = -2*pi:0.0001:2*pi;
h = 0.0001;

y = tanh(x);
y1 = FiniteDifferenceOperatorTanh(1, h, x)./h;
y2 = FiniteDifferenceOperatorTanh(2, h, x)./h^2;
y3 = FiniteDifferenceOperatorTanh(3, h, x)./h^3;

figure;
plot(x,y, 'linewidth', 2);
hold on;
plot(x,y1, 'linewidth', 2);
plot(x,y2, 'linewidth', 2);
plot(x,y3, 'linewidth', 2);
grid on
grid minor
title('Derivatives of Tanh Computed via Finite Differences');
xlabel('x');


%% Algorithm - Converges OK for a = 0

N = 5;
a_coefs = [];
h = 0.1;
a = 0;

for n=N-1:-1:0
    delta_hn = FiniteDifferenceOperatorTanh(n,h,a);
    a_coefs(end+1) = delta_hn./(factorial(n)*h^n);
end

t = a-pi/2:0.01:a+pi/2;
y = polyval(a_coefs, t);

figure;
plot(t,y, 'b', 'linewidth', 2);
hold on;
plot(t,tanh(t), 'k', 'linewidth', 2);
grid on;
grid minor;
title('Tanh(x) finite difference approximation about a=0: works');
xlabel('x');


%% Algorithm - Doesn't converge for |a|>pi/2

N = 5;
a_coefs = [];
h = 0.1;
a = pi;

for n=N-1:-1:0
    delta_hn = FiniteDifferenceOperatorTanh(n,h,a);
    a_coefs(end+1) = delta_hn./(factorial(n)*h^n);
end

t = a-pi/2:0.01:a+pi/2;
y = polyval(a_coefs, t);

figure;
plot(t,y, 'b', 'linewidth', 2);
hold on;
plot(t,tanh(t), 'k', 'linewidth', 2);
grid on;
grid minor;
title('Tanh Approximation About a = \pi: does not work');
xlabel('x');