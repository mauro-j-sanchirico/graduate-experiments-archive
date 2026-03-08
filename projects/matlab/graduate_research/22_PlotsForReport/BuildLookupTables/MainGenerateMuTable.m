%% Generate a Mu Table
%% Generates a Table of Mu Function Values

clc; clear; close all;

addpath('../Math');
addpath('../Math/LookupTables/');
addpath('../FourierSeriesViaExponential/');
addpath('../');

file_path_name = '../Math/LookupTables/mu_table';

% Set to true to build a new table
% Set to false to continue mining an existing table
build_new_table = true;


%% Loop over n and L and plot the mu function at each step

% Load the binomial table
binomial_table_struct = load('binomial_table.mat');
binomial_table = double(binomial_table_struct.binomial_table);

design_flags = GetDesignFlags();
n_max = design_flags.number_of_harmonics_N;
L_max = design_flags.number_of_taylor_terms_L;

if build_new_table
    mu_table = vpa(nan(n_max+1, L_max+1));
else
    mu_table_struct = load('mu_table.mat');
    mu_table = mu_table_struct.mu_table;
end

for n = 0:n_max
    fprintf('n = %i/%i\n', n, n_max);
    for L = 0:L_max
        tic
        if isnan(mu_table(n+1, L+1))
            mu_table(n+1, L+1) = ComputeMuFunction(n, L, binomial_table);
        end
        elapsed_t = toc;
        fprintf('    l = %i/%i, t = %f\n', L, L_max, elapsed_t)
    end
end

save(file_path_name, 'mu_table');
