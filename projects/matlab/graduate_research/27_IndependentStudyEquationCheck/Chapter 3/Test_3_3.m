clc; clear; close all;

gamma = 1;
psi = 0:0.1:2*pi;
M = 20;

lhs = tanh(gamma*sin(psi));

rhs = 0;

for m = 1:M
    numerator = 2^(2*m)*(2^(2*m) - 1)*bernoulli(2*m)*gamma^(2*m-1);
    denominator = factorial(2*m);
    coef = numerator / denominator;
    rhs = rhs + coef*(sin(psi)).^(2*m-1);
end

figure;
plot(psi, lhs);
hold on;
plot(psi, rhs);

error = abs(lhs - rhs);

figure;
plot(psi, error);