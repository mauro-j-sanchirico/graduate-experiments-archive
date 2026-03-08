%% Trinomial Coefs Expample
%% Compute (1 + 2 + 3)^50

clc; clear; close all;

%% Load tables

ti_struct = load('trinomial_indicies_table.mat');
ti_table = ti_struct.trinomial_indicies_table;

tc_struct = load('trinomial_coefs_table.mat');
tc_table = tc_struct.trinomial_coefs_table;

x = [1 2 3];
n = 50;

trinomial_sum = 0;
for idx = 1:length(ti_table{n})
    k = ti_table{n}(idx, :);
    tc = FastTrinomialCoef(tc_table, n, k);
    term = tc*x(1)^k(1)*x(2)^k(2)*x(3)^k(3);
    trinomial_sum = trinomial_sum + term;
end

trinomial_sum

sum(x).^n
