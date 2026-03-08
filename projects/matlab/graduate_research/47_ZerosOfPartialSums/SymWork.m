clc; clear; close all;

syms x t a k;

%assume(k, {'real', 'positive', 'integer'});

k = 10;

integrand = (x-t)^k*sin((k+1)*pi/2 + t);
integral = int(integrand, t, 0, x)

eval_int = subs(integral, [x, k, a], [sym(3.237 - 1i*0.6908), sym(6)])