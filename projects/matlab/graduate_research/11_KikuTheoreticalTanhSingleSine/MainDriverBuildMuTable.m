%% Main Driver for Building Up a Mu Table
%% Builds a table for the function mu(n,l)

clc; clear; close all;

%% Parameters

n_max = 5;
L_max = 500;

%% Build the table

fprintf('Building mu table...\n');

mu_table = zeros(n_max, L_max);

t = 0;
for n = 0:n_max
    tic;
    for L = 0:L_max
        mu_table(n+1, L+1) = ComputeMuFunctionTheoretical(vpa(n), vpa(L));
    end
    dt = toc;
    t = t + dt;
    fprintf('* Finished row %i/%i in %fs (dt = %fs)\n', n, n_max, t, dt);
end

fprintf('Saving mu table...\n');
save('tables/mu_table');
fprintf('Done.\n');