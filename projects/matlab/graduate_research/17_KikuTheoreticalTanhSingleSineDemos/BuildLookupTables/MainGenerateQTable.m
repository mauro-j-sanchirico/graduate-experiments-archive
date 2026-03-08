%% Generate a Q Table
%% Generates a Table of Q Function Values

clc; clear; close all;

addpath('../Math');
addpath('../Math/ExponentialFourierSeries/');
addpath('../Math/LookupTables/')

file_path_name = '../Math/LookupTables/q_table';


%% Loop over m and L and store the q function at each step

% Load the factorial table
factorial_table_struct = load('factorial_table.mat');
factorial_table = factorial_table_struct.factorial_table;

design_flags = GetDesignFlags();
n_max = design_flags.number_of_harmonics_N;
m_max = design_flags.number_of_exponential_terms_M;
L_max = design_flags.number_of_taylor_terms_L;

q_table = vpa(zeros(m_max+1, L_max+1));

for m_idx = 0:m_max
    for l_idx = 0:L_max
        fprintf('m = %i/%i;  l = %i/%i\n', m_idx, m_max, l_idx, L_max);
        q_table(m_idx+1, l_idx+1) = ...
            ComputeQFunction(vpa(m_idx), vpa(l_idx), factorial_table);
    end
end

save(file_path_name, 'q_table');
