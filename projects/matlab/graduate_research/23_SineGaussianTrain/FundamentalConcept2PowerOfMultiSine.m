%% Illustration of fundamental concept enabling integration of powers
%% Shows relationship between power of a fourier series and convolution

clc; clear; close all;

%% Demonstration

% Get a multisine
dt = 0.01;
t = 0:dt:2*pi;

a = [0 0 0];
b = [1 1 1];
n = 1:length(a);

v = ComputeReconstructedFunctionFromFourierSeries(a, b, n, t);


figure;
plot(t, v);

v2 = v.^2;
b2 = conv(b, b)
a2 = conv(a, a)
n2 = 1:length(a2);
v2_approx = ComputeReconstructedFunctionFromFourierSeries(a2, b2, n2, t);

figure;
plot(t, v2);
hold on;
plot(t, v2_approx);

