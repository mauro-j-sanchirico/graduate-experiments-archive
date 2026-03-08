%% Taylor Series Figures
%% Figures for the Taylor Series of Tanh

clc; clear; close all;

set(0, 'defaulttextInterpreter', 'latex');

addpath('./Math');
addpath('./Math/Statistics')

% Data characteristics
x0 = -10;
x1 = 10;
dx = 0.001;
x = x0:dx:x1;
num_samples = 100000;

% Noise generator (normal)
%sigma = 1;
%mu = 0;
%normal_pdf_handle = ...
%    @(x) 1/(sigma*sqrt(2*pi))*exp(-0.5*((x-mu)/sigma).^2);

normal_pdf_handle = @(x) exp(-x.^2);
tanh_cdf_handle = @(x) 0.5*sqrt(pi)*(erf(atanh(x)) + 1);
tanh_pdf_handle = @(x)  exp(-((atanh(x) + 1).^2))./(1 - x.^2);

normal_noise = GenerateDistributedData( ...
       x0, x1, dx, normal_pdf_handle, num_samples);

figure;
histogram(normal_noise, 'Normalization', 'pdf');
hold on;
histogram(tanh(normal_noise), 'Normalization', 'pdf');

selection = x < 1 & x > -1;

figure;
plot(x, normal_pdf_handle(x));
hold on;
plot(x(selection), tanh_pdf_handle(x(selection)));
plot(x(selection), [diff(tanh_cdf_handle(x(selection)))./diff(x(selection)) nan])

figure;
cdfplot(tanh(normal_noise))
hold on;
plot(x(selection), tanh_cdf_handle(x(selection)));

