clc; clear; close all;

x = 0.001:0.001:30;

y = 1 - tanh(x);

cutoff = y > eps;

cutoff_idx = find(cutoff == 0, 1);

x(cutoff_idx)
