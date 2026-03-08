%% Multinomial Coefs Expample
%% Compute basic multinomial coefficient examples

clc; clear; close all;

%% Load tables

[mi_table, mc_table] = GetMultinomialTables();

%% Trinomial example

x = [1 2 3];
n = 40;
m = length(x);

multinomial_sum = 0;
for idx = 1:length(mi_table{m}{n})
    k = FastMultiIndex(mi_table, m, n, idx);
    mc = FastMultinomialCoef(mc_table, m, n, k);
    term = mc*ComputeMultiIndexPower(x, k);
    multinomial_sum = multinomial_sum + term;
end

multinomial_sum

sum(x).^n

%% Higher order example

x = [2 3 2 4];
n = 35;
m = length(x);

multinomial_sum = 0;
for idx = 1:length(mi_table{m}{n})
    k = FastMultiIndex(mi_table, m, n, idx);
    mc = FastMultinomialCoef(mc_table, m, n, k);
    term = mc*ComputeMultiIndexPower(x, k);
    multinomial_sum = multinomial_sum + term;
end

multinomial_sum

sum(x).^n
