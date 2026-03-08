%% Test Exponential Series Expansion for Tanh

clc; clear; close all;

x = -pi:0.001:pi;
M = 100;


%% Straightforward Exponential Series

y_exp = HyperbolicTangentExpSeries(x, M);
y_truth = tanh(x);

figure;
plot(x, y_exp, 'linewidth', 2);
hold on
plot(x, y_truth, '--', 'linewidth', 2);
grid on
legend('Series', 'Truth');
title('Exponential Series Approximation of tanh(x)');
xlabel('x');
ylabel('y=tanh(x)');


%% "2D" Polynomial Series Derived From Exponential Series
M=5; % Large M ensures convergence for low numbers
N=100; % Large N ensures convergence for high numbers
y_2dp = HyperbolicTangent2DPowerSeries(x, M, N);
y_truth = tanh(x);

figure;
plot(x, y_2dp, 'linewidth', 2);
hold on
plot(x, y_truth, '--', 'linewidth', 2);
grid on
legend('Series', 'Truth');
title('Double Power Series Approximation of tanh(x)');
xlabel('x');
ylabel('y=tanh(x)');

