%% Illustration of fundamental concept enabling integration of powers
%% Shows that N(mu1, v)^3 + N(mu2, v)^3 ~= (N(mu1, v) + N(mu2,v))^3
%
% Note that this only works in some cases and ended up not being used

clc; clear; close all;

addpath('./Math')

%% Setup

dt = 0.05;
t = 0:dt:pi;

%% Demonstration of 

mean1 = 1;
mean2 = 1.5;
standard_deviation = dt;

% Get two distributions
distribution1 = GetGaussian(t, mean1, standard_deviation);
distribution2 = GetGaussian(t, mean2, standard_deviation);

% Get sum of cubes and cube of sum
sum_of_cubes = distribution1.^3 + distribution2.^3;
cube_of_sum = (distribution1 + distribution2).^3;

% Integrate both
integral_sum_of_cubes = sum(sum_of_cubes)*dt;
integral_cube_of_sum = sum(cube_of_sum)*dt;

% Plot both
figure;
plot(t, sum_of_cubes, 'linewidth', 6, 'color', 'b');
hold on;
plot(t, cube_of_sum, 'linewidth', 2, 'color', 'g');
grid on;
title('Sum of cubed gaussians and cube of summed gaussians');
xlabel('t');
legend_str1 = sprintf('sum of cubes, area = %f', integral_sum_of_cubes);
legend_str2 = sprintf('cube of sum, area = %f', integral_cube_of_sum);
legend({legend_str1, legend_str2});

