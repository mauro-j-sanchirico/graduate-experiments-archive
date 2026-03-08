%% Main Driver for Building a Kappa Table
%% Builds up a table for the function Kappa(n,l)

clc; clear; close all;

%% Parameters

n_max = 5;
m_max = 6;
L_max = 500;

%% Build up the table
fprintf('Loading q table...\n');
load('tables/q_table.mat', 'q_table');
[q_rows, q_cols] = size(q_table);
fprintf('Done.  q_table size = [%i, %i] (m x L)\n', q_rows, q_cols);

fprintf('Loading mu table...\n');
load('tables/mu_table.mat', 'mu_table');
[mu_rows, mu_cols] = size(mu_table);
fprintf('Done.  mu_table size = [%i, %i] (n x L)\n', mu_rows, mu_cols);

fprintf('Building Kappa table...\n');

kappa_table = zeros(n_max, L_max);

t = 0;
for n = 0:n_max
    tic;
    for L = 0:L_max
        kappa_table(n+1, L+1) = ComputeKappaFunctionTheoretical( ...
            n, L, m_max, mu_table, q_table);
    end
    dt = toc;
    t = t + dt;
    fprintf('* Finished row %i/%i in %fs (dt = %fs)\n', n, n_max, t, dt);
end

fprintf('Saving kappa table...\n');
save('tables/kappa_table');
fprintf('Done.\n');
