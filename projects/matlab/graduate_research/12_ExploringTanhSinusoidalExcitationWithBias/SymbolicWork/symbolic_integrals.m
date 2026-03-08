clc; clear; close all;

syms n omega t phi gamma_1 gamma_0

assume(n, 'integer');

v = gamma_0 + gamma_1*sin(omega*t + phi);

sign_v = v/sqrt(v^2 + eps)

simplify(omega/pi*int(cos(n*omega*t), t, 0, 2*pi/omega))

simplify(omega/pi*int(sin(n*omega*t), t, 0, 2*pi/omega))