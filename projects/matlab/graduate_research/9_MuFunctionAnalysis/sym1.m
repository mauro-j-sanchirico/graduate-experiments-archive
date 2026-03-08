clc; clear; close all;

syms jj ii x

assume(jj, 'integer');
assume(ii, 'integer');

assume(jj >= 0);
assume(ii >= 0);

integrand = x^(2*jj+1)*x^(2*ii+1);

int(integrand, [0, pi])