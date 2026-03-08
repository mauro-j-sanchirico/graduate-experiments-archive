%% Main Generate Lambda Table
%% Generates a Lambda Table to use in expansion of the hyperbolic tangent

clc; clear; close all;

addpath('../Math');
addpath('../Math/LookupTables/');
addpath('../FourierSeriesViaExponential/');
addpath('../');

file_path_name = '../Math/LookupTables/lambda_table';


%% Loop over n and L and compute the lambda coefficient at each step

% Load the q table
q_table_struct = load('q_table.mat');
q_table = double(q_table_struct.q_table);

% Load the mu table
mu_table_struct = load('mu_table.mat');
mu_table = double(mu_table_struct.mu_table);

design_flags = GetDesignFlags();
n_max = design_flags.number_of_harmonics_N;
m_max = design_flags.number_of_exponential_terms_M;
L_max = design_flags.number_of_taylor_terms_L;

lambda_table = zeros(n_max+1, L_max+1);

for n = 0:n_max
    fprintf('n = %i/%i\n', n, n_max);
    for L = 0:L_max
        mu_n_l = LookupMuFunction(n, L, mu_table);
        q_sum = 0;
        for m = 1:m_max
            q_m_l = LookupQFunction(m, L, q_table);
            q_sum = q_sum + q_m_l;
        end
        lambda_table(n+1, L+1) = mu_n_l*q_sum;
    end
end

save(file_path_name, 'lambda_table');
