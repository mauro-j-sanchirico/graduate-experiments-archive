%% Main Driver for Building Up a Mu Table
%% Builds a table for the function mu(n,l)

clc; clear; close all;

%% Parameters

m_max = 25;
L_max = 500;

%% Build the table

fprintf('Building q table...\n');

q_table = zeros(m_max, L_max);

t = 0;
for m = 0:m_max
    tic;
    for L = 0:L_max
        q_table(m+1, L+1) = ComputeQFunctionTheoretical(vpa(m), vpa(L));
    end
    dt = toc;
    t = t + dt;
    fprintf('* Finished row %i/%i in %fs (dt = %fs)\n', m, m_max, t, dt);
end

fprintf('Saving q table...\n');
save('tables/q_table');
fprintf('Done.\n');