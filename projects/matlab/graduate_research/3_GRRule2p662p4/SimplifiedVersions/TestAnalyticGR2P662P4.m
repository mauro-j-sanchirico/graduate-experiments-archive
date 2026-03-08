clc; clear; close all;

m = 20;
a = -1;
x = 0:0.01:2*pi;

f = exp(a.*x).*sin(x).^(2*m + 1);

figure;
plot(x,f);

tic
numerical_integral = trapz(x,f)
toc

tic
analytic_integral = AnalyticGR2P662P4FixedBounds(a, m)
toc

tic
analytic_integral = VectorizedAnalyticGR2P662P4FixedBounds(a, m)
toc