%% Tanh Random Variables
%% Exploring Propagating a Distribution through Tanh

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
sigma = 1;
mu = 0;
normal_pdf_handle = ...
    @(x) 1/(sigma*sqrt(2*pi))*exp(-0.5*((x-mu)/sigma).^2);

% From paper - already exists, didn't need fancy taylor series to derive
tanh_normal_pdf_handle = ...
    @(x) (1./(1-x.^2)).*(1./sqrt(2*pi*sigma^2)).*exp(-(1./2*sigma^2).*(1./2*log((x+1)./(x-1)) - mu).^2);

normal_noise = GenerateDistributedData( ...
       x0, x1, dx, normal_pdf_handle, num_samples);

tanh_normal_noise = tanh(normal_noise);   

figure;
histogram(normal_noise, 'Normalization', 'count');
hold on;
histogram(tanh_normal_noise, 'Normalization', 'count');

selection = x < 1 & x > -1;

figure;
plot(x, normal_pdf_handle(x))
hold on;
%plot(x, imag(tanh_normal_pdf_handle(x)))
%plot(x, real(tanh_normal_pdf_handle(x)))
plot(x(selection), abs(tanh_normal_pdf_handle(x(selection))))
