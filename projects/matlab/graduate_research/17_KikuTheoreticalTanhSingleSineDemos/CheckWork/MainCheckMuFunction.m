%% Checks the Mu Function against the numerical variable
%% Demonstrates equivalence of the numerical and analytical mu functions

clc; clear; close all;

addpath('../Math');
addpath('../Math/ExponentialFourierSeries/');

set(groot, 'defaultTextInterpreter', 'latex');

default_blue = [0 0.4470 0.7410];
light_blue = [0.5 0.9 0.9];


%% Loop over n and L and plot the mu function at each step

% Load the binomial table
binomial_table_struct = load('../Math/LookupTables/binomial_table.mat');
binomial_table = binomial_table_struct.binomial_table;

n_max = 3;
L_max = 3;

mu = zeros(n_max+1, L_max+1);
mu_numerical = zeros(n_max+1, L_max+1);
error = zeros(n_max+1, L_max+1);

for n = 0:n_max
    fprintf('n = %i/%i\n', n, n_max);
    for L = 0:L_max
        fprintf('    l = %i/%i\n', L, L_max)
        mu(n+1, L+1) = ComputeMuFunction(n, L, binomial_table);
        mu_numerical(n+1, L+1) = ComputeMuFunctionNumerical(n, L);
        error(n+1, L+1) = abs(mu(n+1, L+1) - mu_numerical(n+1, L+1));
    end
end

figure;
stem3(error);

