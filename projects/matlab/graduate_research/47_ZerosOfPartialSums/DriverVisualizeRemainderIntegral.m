clc; clear; close all;

k = 6;
x = 3.237 - i*0.6908;


Y = EvalIntegral(sym(x), sym(k))

t = 0:0.0001:real(x);

y = EvalIntegrand(x, k, t);

figure;
plot(t, real(y));
hold on;
plot(t, imag(y));

Y_approx = trapz(t,y)

f = sin(x);
taylor_remainder = (1./gamma(k+1))*Y_approx;
taylor_series = f - taylor_remainder



