clc; clear; close all;

p_in = 0:0.1:20;
p_out = -20:0.1:-1;
p_sat = 0.1;

big_l = 1;
g0 = 1;

gain_s = exp(g0*big_l ./ (1 + p_out./p_sat));

figure;

plot(p_out, gain_s);





