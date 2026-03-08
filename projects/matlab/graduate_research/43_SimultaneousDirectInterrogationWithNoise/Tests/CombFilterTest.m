clc; clear; close all;

t = 0:0.001:8*pi;

y = sin(2*pi*2*t) + sin(2*pi*4*t);
yn = awgn(y, -10);

figure;
plot(t, yn);

n_harmonics = 3;
tolerance = 0.0001;
yf = ApplyCombFilter(2, t, yn, n_harmonics, tolerance);

figure;
plot(t, yf);
hold on;
plot(t, y);
